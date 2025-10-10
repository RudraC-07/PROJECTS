import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/calculate_age.dart';

class UserDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> userDetails;
  final int userIndex;

  UserDetailsScreen({required this.userDetails, required this.userIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${userDetails['name']}'s Details",style: GoogleFonts.rajdhani(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueGrey, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child:
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // Profile Avatar & Name
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        userDetails['name'][0].toUpperCase(),
                        style: GoogleFonts.rajdhani(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userDetails['name'],
                      style: GoogleFonts.rajdhani(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 30),

                    // Personal Details Card
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,bottom: 5),
                      child: sectionTitle("Personal Details"),
                    ),
                    detailsCard([
                      detailRow(Icons.phone, "Phone", userDetails['mobile']),
                      detailRow(Icons.email, "Email", userDetails['email']),
                      detailRow(Icons.wc, "Gender", userDetails['gender']),
                      detailRow(Icons.location_city, "City", userDetails['city']),
                      detailRow(Icons.cake, "Birthdate", userDetails['dob']),
                      // detailRow(Icons.tag, "Age", userDetails['age'].toString()),
                      detailRow(Icons.favorite, "Hobbies", formatHobbies(userDetails['hobbies'])),
                    ]),

                    const SizedBox(height: 20),

                    // Hobby Highlights Card
                    // sectionTitle("Hobby Highlights"),
                    // detailsCard([
                    //   detailRow(Icons.favorite, "Hobbies",
                    //       userDetails['hobbies'].isNotEmpty ? userDetails['hobbies'].join(", ") : "None"
                    //   ),
                    // ]),

                    const SizedBox(height: 10),

                    // Close Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.symmetric(horizontal: 37, vertical: 15),
                      ),
                      child: Text("Close", style: GoogleFonts.rajdhani(fontSize: 21, color: Colors.white,fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.rajdhani(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
      ),
    );
  }

  // Details Card
  Widget detailsCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(children: children),
    );
  }

  // Detail Row with Icon
  Widget detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 22),
          const SizedBox(width: 10),
          Text("$label :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  String formatHobbies(dynamic hobbies) {
    if (hobbies is List) {
      return hobbies.isNotEmpty ? hobbies.join(", ") : "None";
    } else if (hobbies is String) {
      return hobbies.trim().isNotEmpty ? hobbies : "None";
    } else {
      return "None";
    }
  }
}
