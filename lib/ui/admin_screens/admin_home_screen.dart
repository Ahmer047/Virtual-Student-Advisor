import 'package:bu_vsa/ui/admin_screens/job%20upload/admin_job_screen.dart';
import 'package:bu_vsa/ui/admin_screens/register_student.dart';
import 'package:bu_vsa/ui/admin_screens/upload_electives/upload_elective_screen.dart';
import 'package:bu_vsa/ui/admin_screens/upload_roadmap/upload_roadmap_screen.dart';
import 'package:bu_vsa/ui/admin_screens/view_student.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../authentication_screens/signin_screen.dart';
import 'admin_timetable/admin_timetable.dart';
import 'faculty_admin/faculty_upload.dart';
import 'fees_admin/fee_upload_screen.dart';

void logout(BuildContext context) {
  // Assuming you use SharedPreferences to keep the user logged in
  SharedPreferences.getInstance().then((prefs) {
    prefs.remove('userEnrollment'); // Or whatever key you've used
    prefs.remove('userType'); // If you're storing the user type
    // Clear any other user-related prefs
  }).catchError((error) {
    print("Failed to clear preferences: $error");
  });


  // Navigate back to the sign-in screen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => SignInScreen()),
        (Route<dynamic> route) => false,
  );
}

class AdminHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Calculate the common button styling
    final commonButtonStyle = ElevatedButton.styleFrom(
      primary: Color(0xFF00205C),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.257,
        vertical: screenSize.height * 0.03,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00205C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => logout(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
    child: Padding(
    padding: EdgeInsets.only(bottom: screenSize.height * 0.03),
        child: Column(

          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF00205C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenSize.height * 0.02),
                  child: Text(
                    "Admin Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.05,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 150.0,
              height: 150.0,
              child: Center(
                child: Icon(
                  Icons.admin_panel_settings,
                  color: Color(0xFF00205C),
                  size: 111.0,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Center(
              child: Container(
                width: screenSize.width * 0.845,  // Setting the width to 60% of the screen width
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterStudentScreen(),
                      ),
                    );
                  },
                  style: commonButtonStyle,
                  icon: Icon(Icons.add, size: screenSize.width * 0.06),
                  label: Text(
                    'Add Student',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.031,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewStudentScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    // Set a fixed width for the button
                    minimumSize: Size(screenSize.width * 0.40, screenSize.height * 0.10),
                  ),
                  icon: Icon(Icons.remove_red_eye, size: screenSize.width * 0.06),
                  label: Text(
                    'View Student',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.033,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.04),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimeTableScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: Size(screenSize.width * 0.40, screenSize.height * 0.10),
                  ),
                  icon: Icon(Icons.calendar_month_rounded, size: screenSize.width * 0.06),
                  label: Text(
                    'Timetable',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.033,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeeUploadScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    // Set a fixed width for the button
                    minimumSize: Size(screenSize.width * 0.40, screenSize.height * 0.10),
                  ),
                  icon: Icon(Icons.money, size: screenSize.width * 0.06),
                  label: Text(
                    'Fee Structure',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.033,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.04),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadElectiveScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: Size(screenSize.width * 0.40, screenSize.height * 0.10),
                  ),
                  icon: Icon(Icons.list_alt_outlined, size: screenSize.width * 0.06),
                  label: Text(
                    'Elective List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.033,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),
            Center(
              child: Container(
                width: screenSize.width * 0.845,  // Setting the width to 60% of the screen width
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadFacultyScreen(),
                      ),
                    );
                  },
                  style: commonButtonStyle,
                  icon: Icon(Icons.add, size: screenSize.width * 0.06),
                  label: Text(
                    'Faculty List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.031,
                    ),
                  ),
                ),
              ),
            ),


            SizedBox(height: screenSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostJobScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: Size(screenSize.width * 0.40, screenSize.height * 0.10),
                  ),
                  icon: Icon(Icons.work, size: screenSize.width * 0.06),
                  label: Text(
                    'Add Job',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.037,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.04),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminRoadmapScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00205C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: Size(screenSize.width * 0.40, screenSize.height * 0.10),
                  ),
                  icon: Icon(Icons.library_books_sharp, size: screenSize.width * 0.06),
                  label: Text(
                    'Road Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),


            // Add more widgets as needed
          ],
        ),
      )
      ),
    );
  }
}
