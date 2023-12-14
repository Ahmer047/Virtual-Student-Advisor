import 'package:bu_vsa/ui/authentication_screens/signin_screen.dart';
import 'package:bu_vsa/ui/student_screens/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../chatbot/chatbot_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/chatbot.png', height: 200,),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Academia Assist,',
                      style: TextStyle(
                        fontFamily: 'PermanentMarker',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00205C),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 280,
                  child: Text(
                    "I'm here to answer your queries. Ask me about Bahria University.",
                    style: TextStyle(
                      fontFamily: 'ArchitectsDaughter',
                      fontSize: 24,
                      color: Color(0xFF00205C),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 330,
                  height: 55,// Adjust this width as necessary
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatbotScreen()));
                    },
                    child: Text('Chat With Me', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF00205C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 45.0, top: 10.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInScreen()));
                      },
                      icon: Text('Skip'),
                      label: Icon(Icons.arrow_forward),
                      backgroundColor: Color(0xFF00205C),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
