import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/frontend/add_user.dart';
import 'package:matrimonial_app/frontend/favourite_user.dart';
import 'package:matrimonial_app/frontend/login_screen.dart';
import 'package:matrimonial_app/frontend/user_list.dart';
import 'package:matrimonial_app/frontend/about_us.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<bool> _isTapped = List.generate(4, (index) => false);

  // Logout function with confirmation dialog
  Future<void> _logout() async {
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout Confirmation"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel logout
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm logout
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // Proceed with logout if user confirmed
    if (confirmLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn'); // Remove login session
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Heart Link" with Logout Button
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Heart Link" Title
                    Text(
                      "Heart Link",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(width: 140,),
                    // Logout Button
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white, size: 25),
                      onPressed: _logout,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 21.0),
                child: Row(
                  children: [
                    const Icon(Icons.handshake_outlined, size: 15, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      "A Link to Your Happily Ever After.",
                      style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: List.generate(4, (index) {
                    return _buildAnimatedCard(
                      index: index,
                      icon: _getIcon(index),
                      label: _getLabel(index),
                      iconColor: _getIconColor(index),
                      onTap: () => _navigateToScreen(index),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_add_alt_1_rounded;
      case 1:
        return Icons.group_rounded;
      case 2:
        return Icons.favorite;
      case 3:
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  Color _getIconColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue; // Add User
      case 1:
        return Colors.blueGrey; // User List
      case 2:
        return Colors.red; // Favourite
      case 3:
        return Colors.teal; // About Us
      default:
        return Colors.black;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Add User";
      case 1:
        return "User List";
      case 2:
        return "Favorite";
      case 3:
        return "About Us";
      default:
        return "";
    }
  }

  void _navigateToScreen(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = AddUserScreen();
        break;
      case 1:
        screen = UserListScreen();
        break;
      case 2:
        screen = FavouriteUserScreen();
        break;
      case 3:
        screen = AboutUsScreen();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildAnimatedCard({
    required int index,
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isTapped[index] = true);
      },
      onTapUp: (_) {
        setState(() => _isTapped[index] = false);
        onTap();
      },
      onTapCancel: () {
        setState(() => _isTapped[index] = false);
      },
      child: AnimatedScale(
        scale: _isTapped[index] ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Card(
          color: Color(0xFFfaffff),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: iconColor),
              const SizedBox(height: 7),
              Text(
                label,
                style: GoogleFonts.bebasNeue(
                  fontSize: 25,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
