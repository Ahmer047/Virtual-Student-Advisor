import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:photo_view/photo_view.dart'; // <-- New Import
import 'package:bu_vsa/ui/student_screens/home/home_screen.dart';

class TimeTableDisplayScreen extends StatefulWidget {
  @override
  _TimeTableDisplayScreenState createState() => _TimeTableDisplayScreenState();
}

class _TimeTableDisplayScreenState extends State<TimeTableDisplayScreen> {
  final _database = FirebaseDatabase.instance.reference().child('timetable');
  String? selectedProgram;
  String? selectedSection;
  String? imageUrl;
  Map<String, List<String>> sections = {};
  bool errorOccurred = false;
  bool isLoading = true; // Initialize with true for initial loading
  bool isImageLoading = false; // New flag for image loading

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });

    DatabaseEvent event = await _database.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> programs = snapshot.value as Map<dynamic, dynamic>;

      for (var program in programs.keys) {
        sections[program] = List<String>.from(programs[program].keys);
      }
    } else {
      setState(() {
        errorOccurred = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  fetchImageUrl() async {
    setState(() {
      isLoading = true;
      isImageLoading = true; // Set flag to true when starting image loading
    });

    if (selectedProgram != null && selectedSection != null) {
      DatabaseEvent event = await _database.child(selectedProgram!).child(selectedSection!).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value is Map<dynamic, dynamic>) {
        imageUrl = (snapshot.value as Map<dynamic, dynamic>)['image_url'];
      } else {
        errorOccurred = true;
        imageUrl = null; // Set imageUrl to null to remove the displayed image
      }
    }

    setState(() {
      isLoading = false;
      isImageLoading = false; // Set flag to false when image loading is done
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("TimeTable")),
        backgroundColor: Color(0xFF00205C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Add your logout logic here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xFF00205C),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Center(child: Text('Select Program', style: TextStyle(color: Colors.white))),
                  value: selectedProgram,
                  items: sections.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(child: Text(value, style: TextStyle(color: Colors.white))),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedProgram = newValue;
                      selectedSection = null;
                      imageUrl = null;
                    });
                  },
                  dropdownColor: Color(0xFF00205C),
                  style: TextStyle(color: Colors.white),
                  isExpanded: true,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xFF00205C),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Center(child: Text('Select Section', style: TextStyle(color: Colors.white))),
                  value: selectedSection,
                  items: (sections[selectedProgram] ?? []).map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(child: Text(value, style: TextStyle(color: Colors.white))),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedSection = newValue;
                    });
                    fetchImageUrl();
                  },
                  dropdownColor: Color(0xFF00205C),
                  style: TextStyle(color: Colors.white),
                  isExpanded: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : imageUrl != null
                  ? Stack(
                children: [
                  PhotoView(
                    imageProvider: NetworkImage(imageUrl!),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    errorBuilder: (context, error, stackTrace) => Center(child: Text('Error loading image.')),
                  ),
                  if (isImageLoading)
                    Center(child: CircularProgressIndicator()) // Show spinner on top of the image
                ],
              )
                  : Center(child: errorOccurred ? Text('Error fetching data.') : Text('Image will be displayed here')),
            ),
          ],
        ),
      ),
    );
  }
}