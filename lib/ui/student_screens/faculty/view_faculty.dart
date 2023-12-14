import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewFacultyScreen extends StatefulWidget {
  @override
  _ViewFacultyScreenState createState() => _ViewFacultyScreenState();
}

class _ViewFacultyScreenState extends State<ViewFacultyScreen> {
  final dbRef = FirebaseDatabase.instance.reference().child("faculty");
  List<Map<String, dynamic>> facultyList = [];
  String? searchName;
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
        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> facultyData = Map<String, dynamic>.from(value);
            facultyData['name'] = key;
            facultyList.add(facultyData);
          }
        });
        setState(() {});
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Widget _buildInfoRow(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: colorPrimary.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Faculty'),
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
                    searchName = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Faculty Name",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: colorPrimary),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: facultyList.length,
                itemBuilder: (context, index) {
                  if (searchName != null &&
                      !facultyList[index]['name'].toLowerCase().contains(searchName!.toLowerCase())) {
                    return Container(); // Return empty container if not a match
                  }

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 15,
                          titlePadding: EdgeInsets.all(20),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                          title: Text(
                            'Faculty Details',
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
                                SizedBox(height: 10),
                                _buildInfoRow("Name:", facultyList[index]['name']),
                                _buildInfoRow("Designation:", facultyList[index]['designation'] ?? "N/A"),
                                _buildInfoRow("Office:", facultyList[index]['office'] ?? "N/A"),
                                _buildInfoRow("Email:", facultyList[index]['email'] ?? "N/A"),
                                _buildInfoRow("Research Area:", facultyList[index]['researchArea'] ?? "N/A"),
                                _buildInfoRow("Qualification/Institute:", facultyList[index]['qualificationInstitute'] ?? "N/A"),
                                _buildInfoRow("Phone:", facultyList[index]['phoneNumber'] ?? "N/A"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close', style: TextStyle(color: colorPrimary)),
                            ),
                          ],
                          backgroundColor: Colors.white.withOpacity(0.9),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.blueGrey.shade100],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(facultyList[index]['imageUrl'] ?? ""),
                                radius: 40.0,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(facultyList[index]['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorPrimary,
                                            fontSize: 16
                                        )
                                    ),
                                    Text(facultyList[index]['designation'] ?? "N/A",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorPrimary.withOpacity(0.7),
                                            fontSize: 14
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
