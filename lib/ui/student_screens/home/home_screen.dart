import 'package:bu_vsa/ui/authentication_screens/signin_screen.dart';
import 'package:bu_vsa/ui/student_screens/home/student_home_card.dart';
import 'package:bu_vsa/ui/student_screens/home/student_profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
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
class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final databaseReference = FirebaseDatabase.instance.reference().child("students");

  // Expanded data fields
  String? nickname;
  String? className;
  String? email;
  String? fatherName;
  String? name;
  String? phoneNumber;
  String? imageUrl;

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void fetchData() async {
    String? enrollment = enrollmentService.enrollment;

    if (enrollment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment value is null.')),
      );
      return;
    }

    try {
      DataSnapshot snapshot = await databaseReference.child(enrollment).get();
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        setState(() {
          nickname = data['nickname'];
          className = data['className'];
          email = data['email'];
          fatherName = data['fatherName'];
          name = data['name'];
          phoneNumber = data['phoneNumber'];
          imageUrl = data['imageUrl'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No data found for the given enrollment.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: StudentDrawerScreen(
        nickname: nickname,
        className: className,
        email: email,
        fatherName: fatherName,
        name: name,
        phoneNumber: phoneNumber,
        imageUrl: imageUrl,
      ),
      backgroundColor: Color(0xFF00205C),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: openDrawer,
                  ),
                  if (nickname != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Hi, $nickname',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'RobotoSlab',
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () => logout(context)
                ),
              ),
            ],
          ),
          Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Your other content here
          Expanded(
            child: StudentCardScreen(),
          ),
        ],
      ),
    );
  }
}
