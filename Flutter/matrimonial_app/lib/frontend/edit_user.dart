import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../backend/database_helper.dart';
import 'user_list.dart';
import 'package:http/http.dart' as http; // Import http package for API calls
import 'dart:convert';

class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  final int userIndex;

  EditUserScreen({super.key, required this.userDetails,required this.userIndex  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  List<String> cities = ["Rajkot", "Ahmedabad", "Surat", "Vadodara"];
  List<String> genders = ["Male", "Female", "Other"];
  Map<String, bool> hobbies = {"Cricket": false, "Dancing": false, "Singing": false};

  String? dobError;
  String? cityError;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  late String selectedCity;
  late String selectedGender;
  DateTime? date;
  List<String> selectedHobbies = [];

  final GlobalKey<FormState> _formKey = GlobalKey();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userDetails['name']);
    emailController = TextEditingController(text: widget.userDetails['email']);
    mobileNumberController = TextEditingController(text: widget.userDetails['mobile'].toString());
    confirmPasswordController = TextEditingController(text: widget.userDetails['password']);
    passwordController = TextEditingController(text: widget.userDetails['password']);
    selectedCity = widget.userDetails['city'];
    selectedGender = widget.userDetails['gender'];
    var hobbiesData = widget.userDetails['hobbies'];
    if (hobbiesData is String) {
      selectedHobbies = hobbiesData.split(','); // Convert comma-separated string to list
    } else if (hobbiesData is List) {
      selectedHobbies = List<String>.from(hobbiesData);
    } else {
      selectedHobbies = [];
    }
    if (widget.userDetails['dob'] != null) {
      if (widget.userDetails['dob'] is int) {
        // If dob is a timestamp (milliseconds since epoch)
        date = DateTime.fromMillisecondsSinceEpoch(widget.userDetails['dob']);
      } else if (widget.userDetails['dob'] is String) {
        try {
          date = DateFormat('dd/MM/yyyy').parse(widget.userDetails['dob']);
        } catch (e) {
          print("Invalid date format: ${widget.userDetails['dob']}");
          date = null;
        }
      }
    }


    List<String> userHobbies = widget.userDetails['hobbies'].toString().split(',');
    hobbies.updateAll((key, value) => userHobbies.contains(key));
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => date = pickedDate);
    }
  }

  // void updateUser() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   int userId = widget.userDetails?['id'] ?? 0;
  //   int isFavorite = widget.userDetails?['favorite'] ?? 0;
  //
  //   Map<String, dynamic> updatedUser = {
  //     'id': userId,  // Ensure this is present
  //     'name': nameController.text,
  //     'email': emailController.text,
  //     'mobile': mobileNumberController.text,
  //     'dob': DateFormat('dd/MM/yyyy').format(date!),
  //     'gender': selectedGender,
  //     'city': selectedCity,
  //     'hobbies': hobbies.keys.where((hobby) => hobbies[hobby]!).toList().join(','),
  //     'password': passwordController.text,
  //     'favorite': isFavorite,  // If applicable
  //   };
  //
  //   await DatabaseHelper.instance.updateUser(updatedUser);
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserListScreen()));
  // }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    String userId = widget.userDetails['id'].toString();
    bool isFavorite = widget.userDetails['favorite'] ?? false;

    Map<String, dynamic> updatedUser = {
      'id': userId,
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileNumberController.text,
      'dob': DateFormat('dd/MM/yyyy').format(date!),
      'gender': selectedGender,
      'city': selectedCity,
      'hobbies': hobbies.keys.where((hobby) => hobbies[hobby]!).toList().join(','),
      'password': passwordController.text,
      'favorite': isFavorite,
    };

    // Make API call to update user
    final response = await http.put(
      Uri.parse('https://67c684ca351c081993fd98c8.mockapi.io/user/heart_link/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedUser),
    );

    if (response.statusCode == 200) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User updated successfully!")),
      );
      // Navigate back to the user list screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserListScreen()));
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update user")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserListScreen())),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text("Edit User",style: GoogleFonts.rajdhani(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
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

          Padding(
            padding: const EdgeInsets.all(20.0),
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
              child: Form(
                key: _formKey,
                child:
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    inputTextField(
                    label: "Enter Name",
                    controller: nameController,
                    fieldName: "Name",
                    icon: Icons.person,
                    regex: r"^[a-zA-Z\s'-]{3,50}$",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s-]')), // Restricts numbers
                    ],
                  ),
                  inputTextField(
                    label: "Enter Email Address",
                    controller: emailController,
                    fieldName: "Email",
                    icon: Icons.email,
                    regex: r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                    textInputType: TextInputType.emailAddress
                  ),
                  inputTextField(
                    label: "Enter Mobile Number",
                    controller: mobileNumberController,
                    fieldName: "Mobile Number",
                    icon: Icons.phone,
                    regex: r"^\+?[0-9]{10,15}$",
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),

                      const SizedBox(height: 10),

                      buildDatePicker(),

                      const SizedBox(height: 10),

                      buildDropdown("Select City", cities, selectedCity, (value) {
                        setState(() {
                          selectedCity = value!;
                          cityError = null;
                        });
                      }, cityError),

                      // Gender Dropdown
                      buildDropdown("Select Gender", genders, selectedGender, (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      }),

                      // Hobbies
                      buildHobbies(),

                      // Password Fields
                      inputPasswordField(label: "Enter Password", controller: passwordController),
                      inputPasswordField(label: "Confirm Password", controller: confirmPasswordController, confirm: true),


                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                        child: Text(
                          "Password must be \nat least 8 characters long, \ninclude an uppercase and lowercase letter, \na number, \nand a special character(!@#&*~_).",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 107,top: 8),
                        child: ElevatedButton(
                          onPressed: updateUser,
                          child: Text("Save",style: GoogleFonts.rajdhani(fontSize: 20,fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget inputTextField({
    required String label,
    required TextEditingController controller,
    required String fieldName,
    IconData? icon,
    String? regex,
    TextInputType textInputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        textCapitalization: fieldName == "Name"
            ? TextCapitalization.words
            : TextCapitalization.none,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          prefixIcon: icon != null ? Icon(icon, color: Colors.blueGrey) : null, // Icon added
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "$fieldName cannot be empty";
          }
          if (regex != null && !RegExp(regex).hasMatch(value)) {
            return "Invalid $fieldName format";
          }
          return null;
        },
      ),
    );
  }

  Widget buildDatePicker() {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: date == null ? "" : DateFormat('dd/MM/yyyy').format(date!),
      ),
      decoration: InputDecoration(
        labelText: "Select DOB",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueGrey),
        errorText: dobError,
      ),
      onTap: () async {
        DateTime today = DateTime.now();
        DateTime lastValidDate = DateTime(today.year - 18, today.month, today.day);

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? lastValidDate,
          firstDate: DateTime(today.year - 80),
          lastDate: lastValidDate,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colors.blueGrey),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            date = pickedDate;
            dobError = null;
          });
        }
      },
      validator: (value) => date == null ? 'DOB cannot be empty' : null,
    );
  }

  Widget buildDropdown(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged, [String? errorText]) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(25),
        value: selectedValue.isEmpty ? null : selectedValue,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select a city"; // Error message
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          prefixIcon: Icon(
            label == "Select City" ? Icons.location_city : Icons.wc, // Directly assigning the icon
            color: Colors.blueGrey,
          ),
          errorText: errorText,
        ),
      ),
    );
  }

  Widget buildHobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10.0, left: 8, bottom: 5),
          child: Text("Hobbies:", style: TextStyle(color: Colors.black, fontSize: 18)),
        ),
        Column(
          children: hobbies.keys.map((String key) {
            return CheckboxListTile(
              title: Text(key),
              value: hobbies[key],
              onChanged: (bool? value) {
                setState(() {
                  hobbies[key] = value!;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget inputPasswordField({
    required String label,
    required TextEditingController controller,
    bool confirm = false, // New parameter to differentiate fields
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
          suffixIcon: IconButton(
            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password cannot be empty";
          }
          if (!confirm) {
            // Only validate password rules for the first field
            String passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~_]).{8,}$';
            if (!RegExp(passwordPattern).hasMatch(value)) {
              return "Password must be at least 8 characters, include an uppercase, lowercase, number, and special character.";
            }
          } else {
            // Confirm password validation
            if (value != passwordController.text) {
              return "Passwords do not match";
            }
          }
          return null;
        },
      ),
    );
  }
}
