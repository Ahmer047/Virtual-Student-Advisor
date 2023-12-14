import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_view_jobs.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("jobs");
  final FirebaseStorage storage = FirebaseStorage.instance;

  String jobId = '';
  String jobTitle = '';
  String jobDescription = '';
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

    final ref = storage.ref().child('job_ads').child(jobId);
    final uploadTask = ref.putFile(_imageFile!);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();
    final imageUrl = await _uploadImage();

    try {
      await dbRef.child(jobId).set({
        'jobTitle': jobTitle,
        'jobDescription': jobDescription,
        'imageUrl': imageUrl,
      });
      _showCupertinoDialog(
        title: "Success",
        content: "Job Posted Successfully",
      );
    } catch (error) {
      _showCupertinoDialog(title: "Error", content: "Error posting job: $error");
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Job'),
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
                  Container(
                    width: screenWidth * 0.95,
                    height: 200,
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo),
                  label: Text("Choose Ad Image"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.40, 40),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Job ID', prefixIcon: Icon(Icons.work)),
                  validator: (value) {
                    if (value!.isEmpty) return 'Job ID is required';
                    return null;
                  },
                  onSaved: (value) => jobId = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Job Title', prefixIcon: Icon(Icons.title)),
                  validator: (value) {
                    if (value!.isEmpty) return 'Job Title is required';
                    return null;
                  },
                  onSaved: (value) => jobTitle = value!,
                ),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Job Description',
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Job Description is required';
                    return null;
                  },
                  onSaved: (value) => jobDescription = value!,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Post Job"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    minimumSize: Size(screenWidth * 0.95, 50),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewJobsScreen()),
                    );
                  },
                  child: Text("View Jobs"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C), // You may want to use color constants or ThemeData for colors
                    minimumSize: Size(screenWidth * 0.95, 50), // Make sure 'screenWidth' is defined in your widget
                  ),
                ),

                SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
