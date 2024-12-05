import 'dart:convert';

import 'package:assignment_2_offline_capabilities_with_local_storage/db_helper/db_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/users_model.dart';
import '../services/api_services.dart';

class UserProvider with ChangeNotifier {
  final _db = DBHelper();
  List<UserModel> _users = [];
  String? _errorMessage;
  bool _isLoading = false;

  /// -- Getter
  List<UserModel> get users => _users;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// -- Fetch all users method
  Future<void> fetchUsers({required bool isConnected}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (isConnected) {
    try {
      final response = await ApiServices.fetchUsers();
      final List<dynamic> mapData = jsonDecode(response.body);
      _users = mapData.map((user) => UserModel.fromMap(user)).toList();

      ///-- Cached fetched data locally in SQLite
      await _db.clearCache();
      for (var user in _users) {
        await _db.insertUsers(user);
      }
    } catch (e) {
      _errorMessage = e.toString();
      await loadCachedUsers();
    }
    } else {
     await loadCachedUsers();
     if (_users.isEmpty) {
       _errorMessage = "No cached data available.";
     }
    }
    _isLoading = false;
    notifyListeners();
  }

  /// -- Load Cached Users
  Future<void> loadCachedUsers() async {
    _users = await _db.getUsers();
    notifyListeners();
  }
}
