import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/frontend/dashboard.dart';
import 'package:matrimonial_app/frontend/edit_user.dart';
import 'package:matrimonial_app/frontend/user_details.dart';
import '../utils/calculate_age.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadUsers() async {
    final response = await http.get(Uri.parse('https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link'));
    if (response.statusCode == 200) {
      setState(() {
        users = List<Map<String, dynamic>>.from(
            jsonDecode(response.body).map((user) => {
              "id": user["id"],
              "name": user["name"] ?? "",
              "email": user["email"] ?? "",
              "mobile": user["mobile"]?.toString() ?? "",  // Convert to String
              "dob": user["dob"] ?? "",  // Ensure DOB remains as String
              "gender": user["gender"] ?? "Not Specified",
              "city": user["city"] ?? "",
              "hobbies": user["hobbies"] is List ? List<String>.from(user["hobbies"]) : [],
              "password": user["password"] ?? "",
              "favorite": user["favorite"] is bool ? user["favorite"] : false,
            })
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load users")),
      );
    }
  }

  Future<void> _toggleFavorite(String userId, bool currentFavorite) async {
    // Update the local state immediately
    setState(() {
      users = users.map((user) {
        if (user['id'] == userId) {
          user['favorite'] = !currentFavorite; // Toggle the favorite status
        }
        return user;
      }).toList();
    });

    // Make the API call in the background
    final response = await http.put(
      Uri.parse('https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'favorite': !currentFavorite}),
    );

    // If the API call fails, revert the local state
    if (response.statusCode != 200) {
      setState(() {
        users = users.map((user) {
          if (user['id'] == userId) {
            user['favorite'] = currentFavorite; // Revert the favorite status
          }
          return user;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update favorite status")),
      );
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link/$userId'));
    if (response.statusCode == 200) {
      _loadUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user")),
      );
    }
  }

  void _confirmDelete(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteUser(userId);
                Navigator.of(context).pop();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> get filteredUserList {
    String query = searchController.text.toLowerCase();
    return users.where((user) {
      return (user['name'] ?? '').toLowerCase().contains(query) ||
          (user['dob'] != null && Utils.calculateAge(int.parse(user['dob'].toString())).toString().contains(query)) ||
          (user['email'] ?? '').toLowerCase().contains(query) ||
          (user['mobile']?.toString() ?? '').contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
                (route) => false,
          ),
        ),
        title: isSearching
            ? TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search users...",
            hintStyle: TextStyle(color: Colors.white60, fontSize: 18),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
        )
            : Text("List Of Users", style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                }
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
          child: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: filteredUserList.isEmpty
                    ? Center(
                  child: Text("No users found", style: GoogleFonts.rajdhani(fontSize: 25, color: Colors.black)),
                )
                    : ListView.builder(
                  itemCount: filteredUserList.length,
                  itemBuilder: (context, index) {

                    final user = filteredUserList[index];
                    int age = 0; // Default age

                    DateTime dobDate;
                    if (user['dob'] is String && user['dob'].isNotEmpty) {
                      try {
                        dobDate = DateFormat("dd/MM/yyyy").parse(user['dob']); // Correct format
                        age = Utils.calculateAge(dobDate.millisecondsSinceEpoch);
                      } catch (e) {
                        print("Error parsing DOB: $e");
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(userDetails: user, userIndex: index),
                          ),
                        );
                      },
                      child: Card(
                        color: Color(0xFFfaffff),
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.blueGrey,
                                child: Text(
                                  user['name'][0].toUpperCase(),
                                  style: GoogleFonts.rajdhani(fontSize: 43, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 20),
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
                              // Add the buttons column here
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      user['favorite'] == true ? Icons.favorite : Icons.favorite_border,
                                      color: user['favorite'] == true ? Colors.pink : Colors.blueGrey,
                                    ),
                                    onPressed: () => _toggleFavorite(user['id'], user['favorite'] ?? false),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blueGrey),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditUserScreen(userDetails: user, userIndex: -1),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(user['id']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}