import 'package:flutter/material.dart';
import '../backend/database_helper.dart';

class FavoriteProvider {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _favoriteUsers = [];

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    _users = await DatabaseHelper.instance.getAllUsers();
    return _users;
  }

  Future<List<Map<String, dynamic>>> getFavoriteUsers() async {
    _favoriteUsers = await DatabaseHelper.instance.getAllUsers();
    return _favoriteUsers.where((user) => user['favorite'] == 1).toList();
  }

  Future<void> updateFavoriteStatus(int id, int newFavorite) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'favorite': newFavorite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleFavorite(int userId) async {
    int index = _users.indexWhere((user) => user['id'] == userId);
    if (index != -1) {
      int newStatus = (_users[index]['favorite'] == 1) ? 0 : 1;
      await updateFavoriteStatus(userId, newStatus);
      _users[index]['favorite'] = newStatus;
    }
  }
}
