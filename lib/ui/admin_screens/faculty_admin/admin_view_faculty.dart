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
        facultyList.clear(); // Clear the list before adding new data
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

  // Function to delete a faculty record
  void _deleteFaculty(String facultyName) async {
    try {
      await dbRef.child(facultyName).remove();
      setState(() {
        facultyList.removeWhere((faculty) => faculty['name'] == facultyName);
      });
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  // Function to show the update dialog
  void _showUpdateDialog(Map<String, dynamic> facultyData) {
    String newName = facultyData['name'];

    String newDesignation = facultyData['designation'] ?? "";
    String newOffice = facultyData['office'] ?? "";
    String newEmail = facultyData['email'] ?? "";
    String newResearchArea = facultyData['researchArea'] ?? "";
    String newQualificationInstitute = facultyData['qualificationInstitute'] ?? "";
    String newPhoneNumber = facultyData['phoneNumber'] ?? "";

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
            'Update Faculty Details',
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
                _buildInfoRow("Name:", facultyData['name']),
                TextFormField(
                  initialValue: newDesignation,
                  decoration: InputDecoration(labelText: 'Designation'),
                  onChanged: (value) {
                    newDesignation = value;
                  },
                ),
                TextFormField(
                  initialValue: newOffice,
                  decoration: InputDecoration(labelText: 'Office'),
                  onChanged: (value) {
                    newOffice = value;
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
                  initialValue: newResearchArea,
                  decoration: InputDecoration(labelText: 'Research Area'),
                  onChanged: (value) {
                    newResearchArea = value;
                  },
                ),
                TextFormField(
                  initialValue: newQualificationInstitute,
                  decoration: InputDecoration(labelText: 'Qualification/Institute'),
                  onChanged: (value) {
                    newQualificationInstitute = value;
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
                  'designation': newDesignation,
                  'office': newOffice,
                  'email': newEmail,
                  'researchArea': newResearchArea,
                  'qualificationInstitute': newQualificationInstitute,
                  'phoneNumber': newPhoneNumber,
                };

                // Update the faculty data in Firebase with the updated fields
                try {
                  await dbRef.child(facultyData['name']).update(updatedFields);

                  // Remove the old record from facultyList
                  facultyList.removeWhere((faculty) => faculty['name'] == facultyData['name']);

                  // Add the updated record to facultyList
                  facultyList.add({
                    'name': newName,
                    'designation': newDesignation,
                    'office': newOffice,
                    'email': newEmail,
                    'researchArea': newResearchArea,
                    'qualificationInstitute': newQualificationInstitute,
                    'phoneNumber': newPhoneNumber,
                  });

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

                  return Card(
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
                                          fontSize: 16)),
                                  Text(facultyList[index]['designation'] ?? "N/A",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colorPrimary.withOpacity(0.7),
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                _showUpdateDialog(facultyList[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteFaculty(facultyList[index]['name']);
                              },
                            ),
                          ],
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
