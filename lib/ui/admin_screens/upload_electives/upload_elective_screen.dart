import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class UploadElectiveScreen extends StatefulWidget {
  @override
  _UploadElectiveScreenState createState() => _UploadElectiveScreenState();
}

class _UploadElectiveScreenState extends State<UploadElectiveScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("electives");
  final FirebaseStorage storage = FirebaseStorage.instance;

  String prerequisite = '';
  String courseCode = '';
  String courseTitle = '';
  int creditHours = 0;
  File? _roadmapFile;
  bool _isLoading = false;

  Future<void> _pickPDF() async {
    final pickedFile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      setState(() {
        _roadmapFile = File(pickedFile.files.single.path!);
      });
    }
  }

  Future<String?> _uploadPDF() async {
    if (_roadmapFile == null) return null;

    final ref = storage.ref().child('elective_roadmaps').child(courseCode);
    final uploadTask = ref.putFile(_roadmapFile!);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final roadmapUrl = await _uploadPDF();

      try {
        DataSnapshot snapshot = (await dbRef.child(courseCode).once()).snapshot;

        if (snapshot.value != null) {
          _showCupertinoDialog(
            title: "Error",
            content: "Elective with the course code $courseCode already registered!",
          );
        } else {
          await dbRef.child(courseCode).set({
            'prerequisite': prerequisite,
            'courseCode': courseCode,
            'courseTitle': courseTitle,
            'creditHours': creditHours,
            'roadmapUrl': roadmapUrl,
          });
          _showCupertinoDialog(
            title: "Success",
            content: "Successfully Registered $courseTitle",
          );
        }
      } catch (error) {
        _showCupertinoDialog(title: "Error", content: "Error registering elective: $error");
      }
    }
    setState(() {
      _isLoading = false;
    });
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Elective'),
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
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickPDF,
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text("Select Roadmap (PDF)"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.40, 40),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prerequisite', prefixIcon: Icon(Icons.list_alt)),
                  onSaved: (value) => prerequisite = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course Code', prefixIcon: Icon(Icons.code)),
                  validator: (value) {
                    if (value!.isEmpty) return 'Course Code is required';
                    return null;
                  },
                  onSaved: (value) => courseCode = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course Title', prefixIcon: Icon(Icons.title)),
                  validator: (value) {
                    if (value!.isEmpty) return 'Course Title is required';
                    return null;
                  },
                  onSaved: (value) => courseTitle = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Credit Hours', prefixIcon: Icon(Icons.timer)),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Credit Hours are required';
                    if (int.tryParse(value) == null) return 'Enter a valid number';
                    if (int.parse(value) > 3) return 'Maximum of 3 credit hours allowed';
                    return null;
                  },
                  onSaved: (value) => creditHours = int.parse(value!),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Register Elective"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.95, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
