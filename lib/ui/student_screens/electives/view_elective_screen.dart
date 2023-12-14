import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FetchElectivesScreen extends StatefulWidget {
  @override
  _FetchElectivesScreenState createState() => _FetchElectivesScreenState();
}

class _FetchElectivesScreenState extends State<FetchElectivesScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("electives");
  List<Elective> electivesList = [];

  @override
  void initState() {
    super.initState();
    _loadElectives();
  }

  void _loadElectives() {
    dbRef.once().then((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Ensure the value is a Map before we cast it.
        final result = Map<String, dynamic>.from(snapshot.value as Map);
        final List<Elective> loadedElectives = result.entries.map((entry) {
          // Pass the value as Map<String, dynamic> and the key to the Elective.fromMap method
          return Elective.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
        setState(() {
          electivesList = loadedElectives;
        });
      }
    }).catchError((error) {
      print("Failed to load electives: $error");
    });
  }


  Future<void> _downloadFile(String url, String fileName) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      try {
        final response = await Dio().get(
          url,
          onReceiveProgress: showDownloadProgress,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            // receiveTimeout: 0,
          ),
        );

        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Download completed! File saved to ${file.path}'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error occurred: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission Denied'),
      ));
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00205C), // Set the background color of the AppBar
        title: Text('Electives'),
        centerTitle: true, // If you want to center the title
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(90), // Adjust the radius as needed
            bottomRight: Radius.circular(90),
          ),
        ),
        toolbarHeight: 80.0, // Increase the AppBar height
      ),

      body: ListView.builder(
        itemCount: electivesList.length,
        itemBuilder: (context, index) {
          final elective = electivesList[index];
          return Card(
            margin: EdgeInsets.all(17),
            elevation: 4.0, // Add elevation
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Add border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Left margin for the title
                          child: Text(elective.courseTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Left margin for the text
                          child: Text("Prerequisite: ${elective.prerequisite}"),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Left margin for the text
                          child: Text("Course Code: ${elective.courseCode}"),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Left margin for the text
                          child: Text("Credit Hours: ${elective.creditHours}"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _downloadFile(elective.roadmapUrl, 'Elective_${elective.courseCode}.pdf'),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cloud_download, color: Color(0xFF00205C)),
                              Text("Roadmap", style: TextStyle(color: Color(0xFF00205C))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }




}

class Elective {
  String key;
  String prerequisite;
  String courseCode;
  String courseTitle;
  int creditHours;
  String roadmapUrl;

  Elective({
    required this.key,
    required this.prerequisite,
    required this.courseCode,
    required this.courseTitle,
    required this.creditHours,
    required this.roadmapUrl,
  });

  factory Elective.fromMap(Map<dynamic, dynamic> data, String key) {
    return Elective(
      key: key,
      prerequisite: data['prerequisite'] ?? '',
      courseCode: data['courseCode'] ?? '',
      courseTitle: data['courseTitle'] ?? '',
      creditHours: data['creditHours'] ?? 0,
      roadmapUrl: data['roadmapUrl'] ?? '',
    );
  }
}
