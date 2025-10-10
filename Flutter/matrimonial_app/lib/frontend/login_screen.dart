import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/database_helper.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _passwordVisible = false;

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please enter email and password.");
      return;
    }

    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (users.isNotEmpty) {
      // User found, save session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setInt('userId', users[0]['id']); // Store user ID for future use
      prefs.setString('userEmail', users[0]['email']);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      _showMessage("Invalid email or password.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Login",style: GoogleFonts.rajdhani(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)), backgroundColor: Colors.blueGrey),
      body:

      Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Adjust width
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                        prefixIcon: Icon(Icons.email,color: Colors.blueGrey,)
                      ),
                      
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                        prefixIcon: Icon(Icons.lock,color: Colors.blueGrey,),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      // obscureText: true,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      child: isLoading ? CircularProgressIndicator(color: Colors.blueGrey) : Text("Login",style: GoogleFonts.rajdhani(fontWeight: FontWeight.bold,fontSize: 18),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
