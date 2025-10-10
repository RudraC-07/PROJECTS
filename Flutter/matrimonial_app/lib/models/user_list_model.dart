import 'package:flutter/material.dart';
import '../backend/database_helper.dart';

class UserListModel {
  List<Map<String, dynamic>> _userList = [];

  List<Map<String, dynamic>> get userList => _userList;

  // Load users from DB
  Future<List<Map<String, dynamic>>> getUsers() async {
    _userList = await DatabaseHelper.instance.getAllUsers();
    return _userList;
  }

  // Add user (return updated list)
  Future<List<Map<String, dynamic>>> addUser(Map<String, dynamic> user) async {
    _userList.add(user);
    return _userList;
  }

  // Remove user (return updated list)
  Future<List<Map<String, dynamic>>> removeUser(int userId) async {
    _userList.removeWhere((user) => user['id'] == userId);
    return _userList;
  }

  // Toggle favorite status (return updated list)
  Future<List<Map<String, dynamic>>> toggleFavorite(int userId) async {
    int index = _userList.indexWhere((user) => user['id'] == userId);
    if (index != -1) {
      int newFavoriteStatus = (_userList[index]['favorite'] == 1) ? 0 : 1;
      await DatabaseHelper.instance.updateFavoriteStatus(userId, newFavoriteStatus);
      _userList[index]['favorite'] = newFavoriteStatus;
    }
    return _userList;
  }
}
