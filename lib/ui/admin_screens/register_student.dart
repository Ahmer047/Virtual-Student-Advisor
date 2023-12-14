import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';

class RegisterStudentScreen extends StatefulWidget {
  @override
  _RegisterStudentScreenState createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("students");
  final FirebaseStorage storage = FirebaseStorage.instance;

  String enrollment = '';
  String password = '';
  String name = '';
  String nickname = '';
  String fatherName = '';
  String className = '';
  String phoneNumber = '';
  String email = '';
  String? selectedSemester;
  Map<String, double> semesterGPAs = {};
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    final ref = storage.ref().child('student_images').child(enrollment);
    final uploadTask = ref.putFile(_imageFile!);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final imageUrl = await _uploadImage();

      try {
        DataSnapshot snapshot = (await dbRef.child(enrollment).once()).snapshot;

        if (snapshot.value != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Error"),
              content: Text("Student with enrollment $enrollment already registered!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        } else {
          // Hash the password using SHA-256
          final hashedPassword = sha256.convert(utf8.encode(password)).toString();

          await dbRef.child(enrollment).set({
            'password': hashedPassword,
            'name': name,
            'nickname': nickname,
            'fatherName': fatherName,
            'className': className,
            'phoneNumber': phoneNumber,
            'email': email,
            'semesterGPA': semesterGPAs,
            'imageUrl': imageUrl,
          });
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),  // green-colored tick (checkmark) icon
                  SizedBox(height: 16),  // spacing
                  Text("Successfully Registered", textAlign: TextAlign.center),  // centered text
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );

        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error registering student: $error")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Student'),
        backgroundColor: Color(0xFF00205C),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                if (_imageFile != null)
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo),
                  label: Text("Choose Image"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.40, 40),
                  ),
                ),



                TextFormField(
                  decoration: InputDecoration(labelText: 'Enrollment'),
                  validator: (value) {
                    if (!RegExp(r"^\d{2}-\d{6}-\d{3}$").hasMatch(value!)) {
                      return 'Enter a valid enrollment format (xx-xxxxxx-xxx)';
                    }
                    return null;
                  },
                  onSaved: (value) => enrollment = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d).+$").hasMatch(value!)) {
                      return 'Password should contain characters and numerics';
                    }
                    return null;
                  },
                  onSaved: (value) => password = value!,
                  obscureText: true, // Hide the password input
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Name is required';
                    return null;
                  },
                  onSaved: (value) => name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'NickName'),
                  validator: (value) {
                    if (value!.isEmpty) return 'NickName is required';
                    return null;
                  },
                  onSaved: (value) => nickname = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Father\'s Name'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Father\'s Name is required';
                    return null;
                  },
                  onSaved: (value) => fatherName = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Class'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Class is required';
                    return null;
                  },
                  onSaved: (value) => className = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (!RegExp(r"^\d{10,12}$").hasMatch(value!)) {
                      return 'Phone number should be between 10 and 12 digits';
                    }
                    return null;
                  },
                  onSaved: (value) => phoneNumber = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value!)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Semesters Passed'),
                  items: ['1', '2', '3', '4', '5', '6', '7', '8']
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  onChanged: (value) => setState(() => selectedSemester = value as String?),
                  onSaved: (value) => selectedSemester = value as String?,
                ),
                for (int i = 1; i <= int.parse(selectedSemester ?? '1'); i++)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Semester $i GPA'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      double gpa = double.tryParse(value!) ?? 0;
                      if (gpa < 0 || gpa > 4) {
                        return 'GPA should be between 0 and 4';
                      }
                      return null;
                    },
                    onSaved: (value) => semesterGPAs['Semester $i'] = double.parse(value!),
                  ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.95, 50),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}