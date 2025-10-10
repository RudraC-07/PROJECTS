import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/calculate_age.dart';
import 'user_details.dart';

class FavouriteUserScreen extends StatefulWidget {
  @override
  _FavouriteUserScreenState createState() => _FavouriteUserScreenState();
}

class _FavouriteUserScreenState extends State<FavouriteUserScreen> {
  List<Map<String, dynamic>> favoriteUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteUsers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link'),
      );

      if (response.statusCode == 200) {
        List<dynamic> allUsers = jsonDecode(response.body);

        print("Full API Response: $allUsers");

        List<Map<String, dynamic>> favUsers = allUsers
            .where((user) => user['favorite'] == true || user['favorite'] == 1)
            .map((user) => Map<String, dynamic>.from(user))
            .toList();

        print("Filtered Favorite Users: $favUsers");

        setState(() {
          favoriteUsers = favUsers;
          filteredUsers = favUsers;
        });
      } else {
        print("❌ Failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching users: $e");
    }
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = favoriteUsers
          .where((user) => user['name']
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _toggleFavorite(String userId, bool isCurrentlyFavorite) async {
    try {
      final response = await http.put(
        Uri.parse('https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link/$userId'),
        body: jsonEncode({'favorite': !isCurrentlyFavorite ? true : false}), // Ensure true/false
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("✅ Favorite status updated for user ID: $userId");
        _loadFavoriteUsers(); // Refresh list
      } else {
        print("❌ Failed to update favorite status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error updating favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search favorite users...',
            hintStyle: TextStyle(color: Colors.white60, fontSize: 18),
            border: InputBorder.none,
          ),
          onChanged: _filterUsers,
        )
            : Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Favorite User",
            style: GoogleFonts.rajdhani(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  filteredUsers = favoriteUsers;
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: filteredUsers.isEmpty
              ? Center(
            child: Text(
              "No favorite users found",
              style: GoogleFonts.rajdhani(fontSize: 25, color: Colors.black),
            ),
          )
              : ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              var user = filteredUsers[index];
              print("DOB Data Type: ${user['dob'].runtimeType}, Value: ${user['dob']}");

              int age = 0;

              if (user['dob'] != null) {
                try {
                  DateTime dobDate;

                  if (user['dob'] is String) {
                    // Ensure it's a valid date format before parsing
                    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(user['dob'])) {
                      dobDate = DateFormat("dd/MM/yyyy").parse(user['dob']);
                    } else {
                      throw FormatException("Unexpected String format for DOB: ${user['dob']}");
                    }
                  } else if (user['dob'] is int) {
                    // Convert timestamp to DateTime (assuming it's in seconds)
                    dobDate = DateTime.fromMillisecondsSinceEpoch(user['dob'] * 1000);
                  } else {
                    throw FormatException("DOB is neither a valid String nor an int");
                  }

                  // Calculate age
                  age = Utils.calculateAge(dobDate.millisecondsSinceEpoch);
                } catch (e) {
                  print("❌ Error parsing DOB: $e");
                }
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsScreen(
                        userDetails: user,
                        userIndex: index,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Color(0xFFfaffff),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 19, left: 20, right: 10, bottom: 19),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blueGrey,
                          child: Text(
                            user['name'][0].toUpperCase(),
                            style: GoogleFonts.rajdhani(
                                fontSize: 43, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user['name'].trim()} | $age yr",
                                style: GoogleFonts.rajdhani(
                                    fontSize: 21, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.email, size: 18, color: Colors.grey[700]),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      user['email'] ?? 'N/A',
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.phone, size: 18, color: Colors.grey[700]),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      user['mobile'] ?? 'N/A',
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.wc, size: 18, color: Colors.grey[700]),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      user['gender'] ?? 'N/A',
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            user['favorite'] == true ? Icons.favorite : Icons.favorite_border,
                            color: user['favorite'] == true ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(user['id'], user['favorite']),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
