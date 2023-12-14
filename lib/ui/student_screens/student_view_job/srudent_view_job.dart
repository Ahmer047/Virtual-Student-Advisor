import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentViewJobsScreen extends StatefulWidget {
  @override
  _StudentViewJobsScreenState createState() => _StudentViewJobsScreenState();
}

class _StudentViewJobsScreenState extends State<StudentViewJobsScreen> {
  final dbRef = FirebaseDatabase.instance.reference().child("jobs");
  List<Map<String, dynamic>> jobsList = [];

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
        jobsList.clear();
        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> jobData = Map<String, dynamic>.from(value);
            jobData['id'] = key; // Assuming 'id' is the key for each job entry
            jobsList.add(jobData);
          }
        });
        setState(() {});
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        backgroundColor: colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: jobsList.length,
                itemBuilder: (context, index) {
                  var job = jobsList[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        job['imageUrl'] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            job['imageUrl'],
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Container(height: 180, color: Colors.grey[200]),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            job['jobTitle'] ?? "No Title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            job['jobDescription'] ?? "No Description",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
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
