import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimonial_app/frontend/dashboard.dart';
import 'package:matrimonial_app/frontend/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..forward();

    // Scale Animation
    _animation = Tween<double>(begin: 0.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate after checking login status
    Future.delayed(Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => isLoggedIn ? DashboardScreen() : LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset('assets/images/splash_screen_logo.jpg', width: 200),
        ),
      ),
    );
  }
}