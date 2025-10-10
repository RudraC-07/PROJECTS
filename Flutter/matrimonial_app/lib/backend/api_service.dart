import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link";

  // Fetch all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> rawData = json.decode(response.body);

      return rawData.map((user) {
        return {
          "id": user["id"].toString(),
          "name": user["name"] ?? "",
          "email": user["email"] ?? "",
          "mobile": user["mobile"].toString(), // Ensure mobile is a String
          "dob": user["dob"] ?? "", // Ensure dob is a String
          "gender": user["gender"] ?? "",
          "city": user["city"] ?? "",
          "hobbies": user["hobbies"] is List ? user["hobbies"].join(", ") : user["hobbies"], // Ensure hobbies is a String
          "password": user["password"] ?? "",
          "favorite": user["favorite"] ?? false,
        };
      }).toList();
    }
    throw Exception("Failed to load users");
  }

  // Add a new user
  Future<void> addUser(Map<String, dynamic> user) async {
    Map<String, dynamic> formattedUser = {
      "id": user["id"]?.toString() ?? "", // Ensure id is a String
      "name": user["name"] ?? "",
      "email": user["email"] ?? "",
      "mobile": user["mobile"] is String ? int.tryParse(user["mobile"]) ?? 0 : user["mobile"], // Ensure mobile is a Number
      "dob": _formatDob(user["dob"]) ?? "01/01/2000", // Ensure dob is a String in DD/MM/YYYY
      "gender": user["gender"] ?? "",
      "city": user["city"] ?? "",
      "hobbies": _formatHobbies(user["hobbies"]) ?? "", // Ensure hobbies is a String
      "password": user["password"] ?? "",
      "favorite": user["favorite"] ?? false, // Ensure favorite is a Boolean
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formattedUser),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add user");
    }
  }

  // Update user (edit details or toggle favorite)
  Future<void> updateUser(String id, Map<String, dynamic> user) async {
    Map<String, dynamic> formattedUser = {
      "id": id,
      "name": user["name"] ?? "",
      "email": user["email"] ?? "",
      "mobile": user["mobile"] is String ? int.tryParse(user["mobile"]) ?? 0 : user["mobile"], // Ensure mobile is a Number
      "dob": _formatDob(user["dob"]) ?? "01/01/2000", // Ensure dob is a String in DD/MM/YYYY
      "gender": user["gender"] ?? "",
      "city": user["city"] ?? "",
      "hobbies": _formatHobbies(user["hobbies"]) ?? "", // Ensure hobbies is a String
      "password": user["password"] ?? "",
      "favorite": user["favorite"] ?? false, // Ensure favorite is a Boolean
    };

    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formattedUser),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update user");
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete user");
    }
  }

  String _formatDob(dynamic dob) {
    if (dob is String) {
      return dob; // Already a String in DD/MM/YYYY
    } else if (dob is int) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dob * 1000);
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    }
    return "01/01/2000"; // Default value if null or invalid
  }

  String _formatHobbies(dynamic hobbies) {
    if (hobbies is List) {
      return hobbies.join(", "); // Convert List to CSV String
    } else if (hobbies is String) {
      return hobbies; // Already a String
    }
    return ""; // Default if empty or invalid
  }
}