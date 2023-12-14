import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RoadmapListScreen extends StatefulWidget {
  @override
  _RoadmapListScreenState createState() => _RoadmapListScreenState();
}

class _RoadmapListScreenState extends State<RoadmapListScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("roadmaps");

  Map<String, List<Map<dynamic, dynamic>>> roadmapsBySemester = {};
  String selectedProgram = 'Computer Science'; // Default selection

  List<String> programs = ['Computer Science', 'Information Technology', 'Artificial Intelligence']; // Dropdown options

  @override
  void initState() {
    super.initState();
    _getRoadmaps();
  }

  void _getRoadmaps() async {
    dbRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
        Map<String, List<Map<dynamic, dynamic>>> temp = {};
        map.forEach((program, semesters) {
          semesters.forEach((semester, courses) {
            courses.forEach((courseCode, courseData) {
              if (program == selectedProgram) {
                temp.putIfAbsent(semester, () => []);
                temp[semester]!.add({
                  "program": program,
                  "semester": semester,
                  "courseCode": courseCode,
                  ...courseData as Map<dynamic, dynamic>,
                });
              }
            });
          });
        });
        setState(() {
          roadmapsBySemester = temp;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  void _filterRoadmapsByProgram(String program) {
    setState(() {
      selectedProgram = program;
      roadmapsBySemester.clear(); // Clear previous data
      _getRoadmaps(); // Re-fetch data for the selected program
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roadmap'),
        centerTitle: true, // This centers the title
        backgroundColor: Color(0xFF00205C),
        // Increase the height by using the toolbarHeight property
        toolbarHeight: 100.0, // Set this height to whatever suits your design
        shape: RoundedRectangleBorder(
          // Add a bottom border radius
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30), // Adjust the radius to your preference
          ),
        ),
        // Use flexibleSpace to create a background with a gradient or image
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Make sure this matches the AppBar's border radius
            ),
            // Add a gradient or image background if you want
            // gradient: LinearGradient(
            //   colors: [Colors.blue, Colors.purple],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
          ),
        ),
      ),


      body: Column(

        children: [
          SizedBox(height: 25.0),
          // Dropdown to select the program
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color(0xFF00205C), // This sets the dropdown's internal canvas color
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), // Rounded corners
                color: Color(0xFF00205C), // Color for the dropdown button itself
              ),
              padding: EdgeInsets.symmetric(horizontal: 10), // Padding for the inner content
              child: DropdownButtonHideUnderline( // Hides the default underline of DropdownButton
                child: DropdownButton<String>(
                  value: selectedProgram,
                  iconEnabledColor: Colors.white, // Sets the dropdown arrow icon color
                  style: TextStyle(color: Colors.white), // Sets the text color
                  dropdownColor: Color(0xFF00205C), // Sets the dropdown background color when opened
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _filterRoadmapsByProgram(newValue);
                    }
                  },
                  items: programs.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // This will not have effect on DropdownMenuItem
                        ),
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.white), // Text color for each dropdown item
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          SizedBox(height: 15.0),
          // Conditional to check if the list is empty
          Expanded(
            child: roadmapsBySemester.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: roadmapsBySemester.keys.length,
              itemBuilder: (context, index) {
                String semester = roadmapsBySemester.keys.elementAt(index);
                List<Map<dynamic, dynamic>> courses = roadmapsBySemester[semester]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,    // Change this value as needed for top padding
                        bottom: 15.0, // Change this value as needed for bottom padding
                        left: 35.0,   // Change this value as needed for left padding
                        right: 25.0,  // Change this value as needed for right padding
                      ),

                      child: Text(
                        '$semester',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // to disable ListView's scrolling
                      itemCount: courses.length,
                      itemBuilder: (context, courseIndex) {
                        var course = courses[courseIndex];
                        // Wrap Card with Container to add margin
                        return Container(
                          // Setting the margin to 5% of the screen width from both sides
                          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                          child: Card(
                            elevation: 15, // Set the elevation as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22), // Set the border radius as needed
                            ),
                            child: ListTile(
                              title: Text(course["courseTitle"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Prerequisite: ${course["prerequisite"] ?? "None"}'),
                                ],
                              ),
                              trailing: Text('Credits: ${course["creditHours"]}'),
                            ),
                          ),
                        );
                      },
                    ),

                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
