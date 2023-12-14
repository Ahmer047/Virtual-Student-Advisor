import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../main.dart';
import '../admin_screens/admin_home_screen.dart';
import '../student_screens/home/home_screen.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}


class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _enrollmentController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedUserRole = 'Student';
  bool _isLoading = false; // Add loading indicator state

  final dbRef = FirebaseDatabase.instance.reference().child("students");

  @override
  void dispose() {
    _passwordController.dispose();
    _enrollmentController.dispose();
    super.dispose();
  }



  // Function to handle the sign-in logic
  void _signIn() async {
    if (_isLoading) return; // Don't perform sign-in while loading

    if (_selectedUserRole == "Student") {
      // Hash the input password
      String hashedInputPassword = hashPassword(_passwordController.text);

      // Query the database to check student credentials
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      DataSnapshot snapshot = await dbRef
          .child(_enrollmentController.text)
          .once()
          .then((event) => event.snapshot);

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (snapshot.value != null) {
        var studentData = snapshot.value as Map<dynamic, dynamic>;

        if (studentData['password'] == hashedInputPassword) {
          enrollmentService.enrollment = _enrollmentController.text;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          _enrollmentController.clear();
          _passwordController.clear();
        } else {
          _showCupertinoAlertDialog("Incorrect password.");
        }

      } else {
        // Show a Cupertino alert for enrollment not found
        _showCupertinoAlertDialog("Enrollment not found.");
      }
    } else if (_selectedUserRole == "Admin") {
      // Here we do a simple hardcoded check for admin credentials
      if (_enrollmentController.text == "admin" &&
          _passwordController.text == "admin@123") {

        // Navigate to the admin home screen if admin credentials are correct
        Navigator.push(

          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
        _enrollmentController.clear();
        _passwordController.clear();
      } else {
        // Show a Cupertino alert for incorrect admin credentials
        _showCupertinoAlertDialog("Incorrect Admin credentials.");
      }
    }
  }


  // Function to hash the password using SHA-256
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Function to show a Cupertino-style alert dialog
  void _showCupertinoAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Icon(
            CupertinoIcons.xmark_circle_fill,
            color: CupertinoColors.destructiveRed,
            size: 40.0,
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(message),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF00205C),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Rest of your content here
                const SizedBox(height: 30),
                Container(
                  width: 230,
                  height: 230,
                  child: Image.asset("assets/images/logo1.png"),
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextField(
                    controller: _enrollmentController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Color(0xFF00205C)),
                      labelText: "Enrollment",
                      filled: true,
                      fillColor: Colors.white60.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Color(0xFF00205C), width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF00205C)),
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white60.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Color(0xFF00205C), width: 1),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFF00205C),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    value: _selectedUserRole,
                    items: ['Student', 'Admin'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUserRole = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: _signIn,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF00205C)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 52),
                GestureDetector(
                  onTap: () {
                    _showCupertinoAlertDialog("Please visit our support center to reset your password.");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        color: Color(0xFF00205C),
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFF00205C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
        // Loading Indicator
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00205C)),
              ),
            ),
          ),
      ],
    );
  }
}