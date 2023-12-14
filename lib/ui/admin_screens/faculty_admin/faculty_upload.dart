import 'dart:convert';
import 'dart:io';
import 'package:bu_vsa/ui/admin_screens/faculty_admin/admin_view_faculty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadFacultyScreen extends StatefulWidget {
  @override
  _UploadFacultyScreenState createState() => _UploadFacultyScreenState();
}

class _UploadFacultyScreenState extends State<UploadFacultyScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("faculty");
  final FirebaseStorage storage = FirebaseStorage.instance;

  String name = '';
  String email = '';
  String office = '';
  String qualificationInstitute = '';
  String designation = '';
  String researchArea = '';
  String phoneNumber = '';
  File? _imageFile;
  bool _isLoading = false;

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

    final ref = storage.ref().child('faculty_images').child(name);
    final uploadTask = ref.putFile(_imageFile!);
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
      final imageUrl = await _uploadImage();

      try {
        DataSnapshot snapshot = (await dbRef.child(name).once()).snapshot;

        if (snapshot.value != null) {
          _showCupertinoDialog(
            title: "Error",
            content: "Faculty with the name $name already registered!",
          );
        } else {
          await dbRef.child(name).set({
            'name': name,
            'email': email,
            'office': office,
            'qualificationInstitute': qualificationInstitute,
            'designation': designation,
            'researchArea': researchArea,
            'phoneNumber': phoneNumber,
            'imageUrl': imageUrl,
          });
          _showCupertinoDialog(
            title: "Success",
            content: "Successfully Registered $name",
          );
        }
      } catch (error) {
        _showCupertinoDialog(title: "Error", content: "Error registering faculty: $error");
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
        title: Text('Register Faculty'),
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
                  decoration: InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value!.isEmpty) return 'Name is required';
                    return null;
                  },
                  onSaved: (value) => name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email is required';
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Office', prefixIcon: Icon(Icons.business)),
                  onSaved: (value) => office = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Qualification & Institute', prefixIcon: Icon(Icons.school)),
                  onSaved: (value) => qualificationInstitute = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Designation', prefixIcon: Icon(Icons.badge)),
                  onSaved: (value) => designation = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Research Area', prefixIcon: Icon(Icons.find_in_page_rounded)),
                  onSaved: (value) => researchArea = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                  onSaved: (value) => phoneNumber = value!,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Register Faculty"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.95, 50),
                  ),
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewFacultyScreen(),
                      ),
                    );
                  },
                  child: Text("View Faculty"),
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
