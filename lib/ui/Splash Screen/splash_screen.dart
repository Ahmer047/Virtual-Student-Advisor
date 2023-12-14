import 'package:flutter/material.dart';

import '../Welcome Screen/welcome_screen.dart';
import '../authentication_screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay (you can replace this with any initialization logic)
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the next screen
      Navigator.of(context).pushReplacement(_createRoute(WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize background color
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween(begin: 0.5, end: 1.0),
          duration: Duration(seconds: 4),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Center(
            child: Image.asset(
              'assets/images/logo1.png', // Your splash screen image
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
