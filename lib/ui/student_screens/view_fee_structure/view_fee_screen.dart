import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FetchFeeScreen extends StatefulWidget {
  @override
  _FetchFeeScreenState createState() => _FetchFeeScreenState();
}

class _FetchFeeScreenState extends State<FetchFeeScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<dynamic> creditHourRates = [];
  List<Map<String, dynamic>> semesterCreditHours = [];
  bool isLoading = false;

  String? selectedProgram;
  List<String> programs = [
    'Computer Science',
    'Artificial Intelligence',
    'Information Technology',
  ];

  @override
  void initState() {
    super.initState();
    selectedProgram = programs.first; // Initialize the selected program
    fetchFeeStructure(selectedProgram!); // Fetch fee structure for the initial program
  }

  Future<void> fetchFeeStructure(String program) async {
    setState(() => isLoading = true);
    creditHourRates.clear();
    semesterCreditHours.clear();

    DatabaseEvent event = await databaseReference.child('feeStructure').child(program).once();
    final programData = event.snapshot.value;

    if (programData is Map) {
      if (programData['creditHourRate'] != null) {
        creditHourRates.add(programData['creditHourRate']);
      }

      programData.forEach((key, value) {
        if (value is Map && value['creditHours'] != null) {
          semesterCreditHours.add({
            'semester': key,
            'creditHours': value['creditHours'],
          });
        }
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Fetch Fee Structure'),
        backgroundColor: Color(0xFF00205B),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),

        child: Column(
          children: [
            Container(
              width: screenWidth * 0.7,

              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: BoxDecoration(
                color: Color(0xFF00205C),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  fillColor: Color(0xFF00205C),
                ),
                dropdownColor: Color(0xFF00205C),
                value: selectedProgram,
                hint: Text(
                  'Select Program',
                  style: TextStyle(color: Colors.white),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedProgram = newValue;
                    fetchFeeStructure(newValue!);
                  });
                },
                items: programs.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                iconEnabledColor: Colors.white,
              ),
            ),
            SizedBox(height: 15), // Add space between dropdown and list
            Expanded(
              child: Container(
                color: Color(0xFF00205C),
                child: ListView.builder(
                  itemCount: semesterCreditHours.length,
                  itemBuilder: (context, index) {
                    var semesterInfo = semesterCreditHours[index];
                    double creditHourRate = creditHourRates.isNotEmpty ? double.tryParse(creditHourRates[0].toString()) ?? 0 : 0;
                    int creditHours = int.tryParse(semesterInfo['creditHours'].toString()) ?? 0;
                    double miscCharges = 5000;
                    double totalFees = (creditHourRate * creditHours) + miscCharges;

                    return Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0), // Add rounded corners
                        ),
                        elevation: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: screenWidth * 0.025),
                        child: Container(
                          width: screenWidth * 0.95,

                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Semester ${semesterInfo['semester']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Credit Hrs: ${semesterInfo['creditHours']} ',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Miscellaneous : 5000',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Total Fees: ${totalFees.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
