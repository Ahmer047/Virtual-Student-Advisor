import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminRoadmapScreen extends StatefulWidget {
  @override
  _AdminRoadmapScreenState createState() => _AdminRoadmapScreenState();
}

class _AdminRoadmapScreenState extends State<AdminRoadmapScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("roadmaps");

  String prerequisite = '';
  String courseCode = '';
  String courseTitle = '';
  int creditHours = 0;
  String selectedProgram = 'Computer Science';
  String selectedSemester = 'Semester 1';
  bool _isLoading = false;

  List<String> programs = ['Computer Science', 'Information Technology', 'Artificial Intelligence'];
  List<String> semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'];

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      setState(() {
        _isLoading = true;
      });

      form.save();

      // Fetching the event first and then the snapshot from the event
      DatabaseEvent event = await dbRef.child(selectedProgram).child(selectedSemester).child(courseCode).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        // If course exists, prompt to replace
        _promptReplaceCourse();
      } else {
        // If course doesn't exist, proceed to register
        _registerCourse();
      }
    }
  }

  void _promptReplaceCourse() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("Replace Course?"),
        content: Text("$courseTitle for $selectedProgram $selectedSemester Course Code $courseCode already exists. Do you want to replace it?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              _registerCourse();
            },
            child: Text("Yes"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
            },
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  Future<void> _registerCourse() async {
    try {
      await dbRef.child(selectedProgram).child(selectedSemester).child(courseCode).set({
        'prerequisite': prerequisite,
        'courseCode': courseCode,
        'courseTitle': courseTitle,
        'creditHours': creditHours,
      });

      _showCupertinoDialog(
        title: "Success",
        content: "Successfully Registered $courseTitle for $selectedProgram $selectedSemester Course Code $courseCode",
      );

    } catch (error) {
      _showCupertinoDialog(title: "Error", content: "Error registering course: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCupertinoDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Roadmap'),
        backgroundColor: Color(0xFF00205C),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: selectedProgram,
                  items: programs.map((program) {
                    return DropdownMenuItem(
                      child: Text(program),
                      value: program,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProgram = value.toString();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Program'),
                ),
                DropdownButtonFormField(
                  value: selectedSemester,
                  items: semesters.map((semester) {
                    return DropdownMenuItem(
                      child: Text(semester),
                      value: semester,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSemester = value.toString();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Semester'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course Code'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Course Code is required';
                    return null;
                  },
                  onSaved: (value) => courseCode = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course Title'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Course Title is required';
                    return null;
                  },
                  onSaved: (value) => courseTitle = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prerequisite'),
                  onSaved: (value) => prerequisite = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Credit Hours'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Credit Hours are required';
                    if (int.tryParse(value) == null) return 'Enter a valid number';
                    if (int.parse(value) > 3) return 'Maximum of 3 credit hours allowed';
                    return null;
                  },
                  onSaved: (value) => creditHours = int.parse(value!),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
