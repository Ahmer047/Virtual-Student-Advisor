import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewJobsScreen extends StatefulWidget {
  @override
  _ViewJobsScreenState createState() => _ViewJobsScreenState();
}

class _ViewJobsScreenState extends State<ViewJobsScreen> {
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
        jobsList.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> jobData = Map<String, dynamic>.from(value);
            jobData['id'] = key; // Assuming 'id' is the key of each job
            jobsList.add(jobData);
          }
        });
        setState(() {});
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Function to delete a job record
  void _deleteJob(String jobId) async {
    try {
      await dbRef.child(jobId).remove();
      setState(() {
        jobsList.removeWhere((job) => job['id'] == jobId);
      });
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Jobs'),
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
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      title: Text(
                        jobsList[index]['title'] ?? "No Title",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                      ),
                      subtitle: Text(
                        "ID: ${jobsList[index]['id']}",
                        style: TextStyle(
                          color: colorPrimary.withOpacity(0.7),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteJob(jobsList[index]['id']);
                        },
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
