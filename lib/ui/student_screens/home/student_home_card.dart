import 'package:bu_vsa/ui/student_screens/student_view_job/srudent_view_job.dart';
import 'package:flutter/material.dart';

import '../../Welcome Screen/welcome_screen.dart';
import '../../chatbot/chatbot_screen.dart';
import '../calculate_gpa/gpa_screen.dart';

import '../electives/view_elective_screen.dart';
import '../faculty/view_faculty.dart';
import '../result/student_result_screen.dart';
import '../roadmap/view_roadmap_screen.dart';
import '../student_notification/student_notification_screen.dart';
import '../timetable/view_timetable_screen.dart';
import '../view_fee_structure/view_fee_screen.dart';
import 'home_screen.dart';

class StudentCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(22.0), // Margin around the card
      elevation: 15.0, // Add a background shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: ()
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GpaScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust for desired corner radius
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0), // Padding to the bottom of the icon
                          child: Icon(
                            Icons.calculate_rounded,
                            color: Color(0xFF556B2F), // Dark Brown
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'GPA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF556B2F), // Forest Green
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                        Text(
                          'Calculator',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF556B2F), // Forest Green
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ],
                    ),

                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentViewJobsScreen()),
                      );

                      // Add button functionality here
                    },


                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust for desired corner radius
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0), // Padding to the bottom of the icon
                          child: Icon(
                            Icons.work,
                            color: Color(0xFF8B4513), // Dark Brown
                            size: 40.0,
                          ),
                        ),

                        Text(
                          'Jobs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8B4513), // Forest Green
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  ElevatedButton(
                    onPressed: ()
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FetchStudentScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Icon(
                            Icons.bar_chart_outlined,
                            color: Color(0xFF008B8B),
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'Result',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF008B8B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeTableDisplayScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Icon(
                            Icons.calendar_month,
                            color: Color(0xFF6B8E23),
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'TimeTable',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF6B8E23),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context)=>FetchFeeScreen()),
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Icon(
                            Icons.money,
                            color: Color(0xFF2F4F4F),
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'Fee',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2F4F4F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Structure',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2F4F4F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewFacultyScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 110.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Icon(
                            Icons.school,
                            color: Color(0xFF001F3F),
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'Faculty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF001F3F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoadmapListScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Icon(
                            Icons.timeline_sharp,
                            color: Color(0xFF722F37),
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'Road Map',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF722F37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FetchElectivesScreen()),
                      );

                      // Add button functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(140.0, 120.0),
                      elevation: 25.0,
                      shadowColor: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Icon(
                            Icons.menu_book,
                            color: Color(0xFF008B8B),
                            size: 40.0,
                          ),
                        ),
                        Text(
                          'Electives',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF008B8B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 11.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatbotScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(110.0, 70.0),
                    elevation: 25.0,
                    shadowColor: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Chat with AcademiaAssist',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
