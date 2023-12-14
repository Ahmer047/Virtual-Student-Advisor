import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewStudentScreen extends StatefulWidget {
  @override
  _ViewStudentScreenState createState() => _ViewStudentScreenState();
}

class _ViewStudentScreenState extends State<ViewStudentScreen> {
  final dbRef = FirebaseDatabase.instance.reference().child("students");
  List<Map<String, dynamic>> studentList = [];
  String? searchEnrollment;
  final colorPrimary = Color(0xFF00205C);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await dbRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        var data = snapshot.value as Map;
        studentList.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> studentData = Map<String, dynamic>.from(value);
            studentList.add({
              "enrollment": key,
              ...studentData
            });
          }
        });
        setState(() {});
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Function to delete a student record
  void _deleteStudent(String enrollment) async {
    try {
      await dbRef.child(enrollment).remove();
      setState(() {
        studentList.removeWhere((student) => student['enrollment'] == enrollment);
      });
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  // Function to show the update dialog
  void _showUpdateDialog(Map<String, dynamic> studentData) {
    String newName = studentData['name'];
    String newFatherName = studentData['fatherName'] ?? "";
    String newClassName = studentData['className'] ?? "";
    String newEmail = studentData['email'] ?? "";
    String newPhoneNumber = studentData['phoneNumber'] ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 15,
          titlePadding: EdgeInsets.all(20),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          title: Text(
            'Update Student Details',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: newName,
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newName = value;
                  },
                ),
                TextFormField(
                  initialValue: newFatherName,
                  decoration: InputDecoration(labelText: 'Father Name'),
                  onChanged: (value) {
                    newFatherName = value;
                  },
                ),
                TextFormField(
                  initialValue: newClassName,
                  decoration: InputDecoration(labelText: 'Class'),
                  onChanged: (value) {
                    newClassName = value;
                  },
                ),
                TextFormField(
                  initialValue: newEmail,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    newEmail = value;
                  },
                ),
                TextFormField(
                  initialValue: newPhoneNumber,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    newPhoneNumber = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: colorPrimary)),
            ),
            TextButton(
              onPressed: () async {
                // Create a map with updated fields only
                Map<String, dynamic> updatedFields = {
                  'name': newName,
                  'fatherName': newFatherName,
                  'className': newClassName,
                  'email': newEmail,
                  'phoneNumber': newPhoneNumber,
                };

                // Update the student data in Firebase with the updated fields
                try {
                  await dbRef.child(studentData['enrollment']).update(updatedFields);

                  // Update the studentList with the updated student data
                  int studentIndex = studentList.indexWhere((student) => student['enrollment'] == studentData['enrollment']);
                  studentList[studentIndex] = {
                    ...studentData,
                    ...updatedFields
                  };

                  Navigator.pop(context);
                } catch (e) {
                  print("Error updating data: $e");
                }
              },
              child: Text('Update', style: TextStyle(color: colorPrimary)),
            ),
          ],
          backgroundColor: Colors.white.withOpacity(0.9),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Students'),
        backgroundColor: colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchEnrollment = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Enrollment",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: colorPrimary),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  if (searchEnrollment != null && !(studentList[index]['enrollment'] ?? '').contains(searchEnrollment!)) {
                    return Container();
                  }

                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(studentList[index]['imageUrl'] ?? 'default_image_url'),
                            radius: 40.0,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(studentList[index]['name'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold, color: colorPrimary)),
                                Text(studentList[index]['className'] ?? 'N/A', style: TextStyle(color: colorPrimary)),
                                Text(studentList[index]['enrollment'] ?? 'N/A', style: TextStyle(color: colorPrimary)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: colorPrimary),
                            onPressed: () {
                              _showUpdateDialog(studentList[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteStudent(studentList[index]['enrollment']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
