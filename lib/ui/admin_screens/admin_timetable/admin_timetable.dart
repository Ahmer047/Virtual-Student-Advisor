import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TimeTableScreen extends StatefulWidget {
  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final _database = FirebaseDatabase.instance.reference().child("timetable");
  final _storage = FirebaseStorage.instance;

  List<String> _programs = [
    'Computer Science',
    'Information Technology',
    'Artificial Intelligence'
  ];
  String? _selectedProgram;
  TextEditingController _sectionController = TextEditingController();
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  RegExp sectionPattern = RegExp(r"^[A-Z]{2}-\d{1}[A-Z]{1}$");

  Future<void> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> uploadToFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String section = _sectionController.text;

      if (!sectionPattern.hasMatch(section)) {
        _showDialog('Error', 'Invalid class/section format.');
        return;
      }

      if (_selectedProgram == null) {
        _showDialog('Error', 'Please select a program.');
        return;
      }

      DatabaseEvent event = await _database.child(_selectedProgram!).child(section).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        _showDialog('Error', 'Timetable for this program and section is already uploaded.');
        return;
      }

      if (_image != null) {
        final Reference storageReference = _storage.ref().child("timetable/images/${_image!.name}");
        final UploadTask uploadTask = storageReference.putFile(File(_image!.path));

        final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => {});
        final String imageUrl = await storageSnapshot.ref.getDownloadURL();

        await _database.child(_selectedProgram!).child(section).set({
          'image_url': imageUrl,
        });


        _showDialog('Success', 'Timetable uploaded successfully.');
      } else {
        _showDialog('Error', 'Please select an image before uploading.');
      }
    } catch (error) {
      _showDialog('Error', 'Error during upload: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Screen'),
        backgroundColor: Color(0xFF00205C),
      ),
      body: _isLoading
          ? Center(child: SpinKitFadingCircle(color: Color(0xFF00205C)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Select Program'),
              value: _selectedProgram,
              items: _programs.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedProgram = newValue;
                });
              },
            ),
            TextField(
              controller: _sectionController,
              decoration: InputDecoration(
                hintText: 'Enter Class/Section (e.g. CS-1A)',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadToFirebase,
              child: Text('Upload to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}