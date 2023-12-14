import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bu_vsa/services/enrollment_services.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

import '../../../main.dart';
import '../home/home_screen.dart';

class FetchStudentScreen extends StatefulWidget {
  @override
  _FetchStudentScreenState createState() => _FetchStudentScreenState();
}

class _FetchStudentScreenState extends State<FetchStudentScreen> {
  final databaseReference =
  FirebaseDatabase.instance.reference().child("students");

  Map<dynamic, dynamic>? studentData;
  Map<dynamic, dynamic>? studentTranscript;

  @override
  void initState() {
    super.initState();
    fetchStudentDetails(); // Fetch student details as soon as the screen is opened
    fetchStudentTranscript(); // Fetch transcript data as soon as the screen is opened
  }

  void fetchStudentDetails() async {
    String? enrollment = enrollmentService.enrollment;

    if (enrollment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment value is null.')),
      );
      return;
    }

    try {
      DataSnapshot snapshot = await databaseReference.child(enrollment).get();
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        setState(() {
          studentData = data.cast<String, dynamic>();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No data found for the given enrollment.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  void fetchStudentTranscript() async {
    String? enrollment = enrollmentService.enrollment;

    if (enrollment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment value is null.')),
      );
      return;
    }

    try {
      DataSnapshot snapshot =
      await databaseReference.child(enrollment).child('semesterGPA').get();
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        setState(() {
          studentTranscript = data.cast<String, dynamic>();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('No transcript data found for the given enrollment.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching transcript data: $error')),
      );
    }
  }

  double? calculateAverage() {
    if (studentTranscript == null) {
      return null; // Return null if no data is available
    }

    List<dynamic> values = studentTranscript!.values.toList();
    double sum = 0.0;
    int count = 0;

    for (var value in values) {
      if (value is num) {
        // Check if the value is a number (int or double)
        sum += value.toDouble(); // Convert to double if necessary
        count++;
      }
    }

    if (count > 0) {
      return sum / count;
    } else {
      return null; // Return null if no valid numeric values are found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF00205C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download, color: Colors.white), // Add the download icon
            onPressed: () {
              // Handle the download action here
              // You can implement the file download logic
              // For example, you can use the `url_launcher` package to open a URL for download.
            },
          ),
        ],

      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Stack(
            alignment: Alignment.bottomCenter, // Align text at the bottom
            children: [
              // Background Image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo1.png',
                      width: 60, // Adjust the size as needed
                      height: 60,
                    ),
                    SizedBox(height: 10), // Add some space between logo and title
                    Text(
                      'Bahria University Islamabad',
                      style: GoogleFonts.openSans(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color for the title
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      ' ${enrollmentService.enrollment}',
                      style: GoogleFonts.openSans(
                        fontSize: 22,
                        color: Colors.black, // Text color for enrollment
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Name: ${studentData?['name'] ?? 'N/A'}',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.black, // Text color for student info
                      ),
                    ),
                    Text(
                      'F Name: ${studentData?['fatherName'] ?? 'N/A'}',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.black, // Text color for student info
                      ),
                    ),
                    Text(
                      'Class: ${studentData?['className'] ?? 'N/A'}',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.black, // Text color for student info
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'CGPA: ${calculateAverage()?.toStringAsFixed(2) ?? 'N/A'}',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color for CGPA
                      ),
                    ),
                    SizedBox(height: 16),
                    studentTranscript != null
                        ? Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: Colors.black26),
                          children: buildTableRows(),
                        ),
                      ),
                    )
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(height: 25),
                    Text(
                      'Department Of Computer Science ',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color for CGPA
                      ),
                    ),
                    // Text at the bottom with italic style
                    Padding(
                      padding: const EdgeInsets.all(3.0),

                      child: Text(
                        'This is a computer-generated document',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> buildTableRows() {
    List<TableRow> rows = [];

    if (studentTranscript != null) {
      // Header row
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: Color(0xFF00205C).withOpacity(0.2),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Semester',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'GPA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      // Data rows
      List<dynamic> keys = studentTranscript!.keys.toList();
      List<dynamic> values = studentTranscript!.values.toList();
      for (int i = 0; i < studentTranscript!.length; i++) {
        rows.add(
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Semester ${i + 1}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(values[i].toString()),
              ),
            ],
          ),
        );
      }
    }

    return rows;
  }
}
