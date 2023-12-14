import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class FeeUploadScreen extends StatefulWidget {
  @override
  _FeeUploadScreenState createState() => _FeeUploadScreenState();
}

class _FeeUploadScreenState extends State<FeeUploadScreen> {
  final _creditHourController = TextEditingController();
  final _creditHourPerSemesterController = TextEditingController();

  List<String> programs = ["Computer Science", "Information Technology", "Artificial Intelligence"];
  String? selectedProgramForCreditHourRate;
  String? selectedProgramForSemester;
  String? selectedSemester;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF00205C),
      appBar: AppBar(
        title: Text('Upload Fee Structure'),
        backgroundColor: Color(0xFF00205C),  // Setting the AppBar color here
        centerTitle: true,  // Centering the title text here
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),

              // Program Dropdown for Credit Hour Rate
              DropdownButton<String>(
                value: selectedProgramForCreditHourRate,
                hint: Text('Select Program for Credit Hour Rate', style: TextStyle(color:  Color(0xFF00205C))),
                style: TextStyle(color: Color(0xFF00205C)),
                items: programs.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Color(0xFF00205C))),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedProgramForCreditHourRate = newValue;
                  });
                },
                dropdownColor: Colors.white,
              ),

              // Credit Hour Rate Text Field
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _creditHourController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Credit Hour Rate',
                    labelStyle: TextStyle(color: Color(0xFF00205C)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: Color(0xFF00205C)),// Setting border radius here
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00205C)),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  style: TextStyle(color:  Color(0xFF00205C)),
                ),
              ),
              SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.6, // This sets the width to 80% of the screen width
            child:
              ElevatedButton(
                child: Text('Upload Credit Hour Rate', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00205C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () async {
                  if (selectedProgramForCreditHourRate == null || _creditHourController.text.isEmpty) {
                    _showErrorDialog("Please select a program and provide the credit hour rate!");
                    return;
                  }
                  try {
                    await databaseReference.child('feeStructure').child(selectedProgramForCreditHourRate!).update({
                      'creditHourRate': _creditHourController.text
                    });
                    _showSuccessDialog("Credit hour rate uploaded successfully!");
                    _creditHourController.clear();
                  } catch (e) {
                    _showErrorDialog("Failed to upload credit hour rate.");
                  }
                },
              ),
          ),
              SizedBox(height: 50),
              Divider(
                color: Color(0xFF00205C),
                thickness: 2.0,
              ),
              SizedBox(height: 20),

              // Program Dropdown for Semester
              DropdownButton<String>(
                value: selectedProgramForSemester,
                hint: Text('Select Program for Semester', style: TextStyle(color: Color(0xFF00205C))),
                items: programs.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Color(0xFF00205C))),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedProgramForSemester = newValue;
                  });
                },
                dropdownColor: Colors.white,
              ),

              // Semester Dropdown
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedSemester,
                hint: Text('Select Semester', style: TextStyle(color: Color(0xFF00205C))),
                items: ["1", "2", "3", "4", "5", "6", "7", "8"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Color(0xFF00205C))),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedSemester = newValue;
                  });
                },
                dropdownColor: Colors.white,
              ),

              // Credit Hours per Semester TextField
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _creditHourPerSemesterController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Credit Hours per Semester',
                    labelStyle: TextStyle(color: Color(0xFF00205C)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: Color(0xFF00205C)),// Setting border radius here
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00205C)),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    hintText: '1-22',
                  ),
                  style: TextStyle(color: Color(0xFF00205C)),
                ),
              ),
              SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.6, // This sets the width to 80% of the screen width
            child:
            ElevatedButton(
                child: Text('Update Semester Cr. Hrs.', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00205C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () async {
                  if (selectedProgramForSemester == null || selectedSemester == null || _creditHourPerSemesterController.text.isEmpty) {
                    _showErrorDialog("All fields are mandatory for semester credit hours!");
                    return;
                  }
                  if(int.parse(_creditHourPerSemesterController.text) < 1 || int.parse(_creditHourPerSemesterController.text) > 22) {
                    _showErrorDialog("Credit hours per semester should be between 1 and 22.");
                    return;
                  }
                  try {
                    await databaseReference.child('feeStructure').child(selectedProgramForSemester!).child(selectedSemester!).child('creditHours').set(_creditHourPerSemesterController.text);
                    _showSuccessDialog("Semester credit hours uploaded successfully!");
                    _creditHourPerSemesterController.clear();
                  } catch (e) {
                    _showErrorDialog("Failed to upload semester credit hours.");
                  }
                },
              ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _creditHourController.dispose();
    _creditHourPerSemesterController.dispose();
    super.dispose();
  }
}
