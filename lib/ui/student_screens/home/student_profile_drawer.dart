import 'package:flutter/material.dart';
import '../../../main.dart';
import 'home_screen.dart';

class StudentDrawerScreen extends StatelessWidget {
  String? enrollment = enrollmentService.enrollment;

  final String? nickname;
  final String? className;
  final String? email;
  final String? fatherName;
  final String? name;
  final String? phoneNumber;
  final String? imageUrl;

  StudentDrawerScreen({
    this.nickname,
    this.className,
    this.email,
    this.fatherName,
    this.name,
    this.phoneNumber,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 70.0),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF00205C),
                width: 5.0,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl ?? ''),
              radius: 44,
            ),
          ),
          SizedBox(height: 19.0),
          Center(
            child: Text(
              '${name ?? "Unknown"}',
              style: TextStyle(
                color: Color(0xFF00205C),
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ),
          SizedBox(height: 7.0),
          Center(
            child: Text(
              '${enrollment ?? "Unknown"}',
              style: TextStyle(
                color: Color(0xFF00205C),
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFF00205C),
              child: ListView(
                children: [
                  SizedBox(height: 7.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: 22.0), // Adjust this value as needed
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Make the Row take the smallest space necessary
                        children: [
                          Icon(
                            Icons.class_outlined, // You can replace this with your desired icon
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0), // Provide some spacing between the icon and the text
                          Text(
                            '${className ?? "Unknown"}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 17.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: 22.0), // Adjust this value as needed
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Make the Row take the smallest space necessary
                        children: [
                          Icon(
                            Icons.phone, // You can replace this with your desired icon
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0), // Provide some spacing between the icon and the text
                          Text(
                            '${phoneNumber ?? "Unknown"}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 17.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: 22.0), // Adjust this value as needed
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Make the Row take the smallest space necessary
                        children: [

                          SizedBox(width: 8.0), // Provide some spacing between the icon and the text
                          Text(
                            'F Name: ${fatherName ?? "Unknown"}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 17.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: 22.0), // Adjust this value as needed
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Make the Row take the smallest space necessary
                        children: [
                          Icon(
                            Icons.email_rounded, // You can replace this with your desired icon
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0), // Provide some spacing between the icon and the text
                          Text(
                            '${email ?? "Unknown"}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 255.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 22.0, bottom: 55.0),  // Adjust as needed
                      child: GestureDetector(
                        onTap: ()  => logout(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout,  // logout icon
                              color: Colors.white,
                              size: 26.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                  // ... add more details as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
