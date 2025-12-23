import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/dashboard_model.dart';

class UserPrefsService {
  static const _key = 'user_model';
  static const _rememberKey = 'remember_me';
  static const _dashboardKey = 'dashboard_data';

  static Future<void> saveUser(
    UserModel user, {
    bool rememberMe = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_key, jsonString);
    await prefs.setBool(_rememberKey, rememberMe);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserModel.fromJson(jsonMap);
  }

  static Future<bool> isRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberKey) ?? false;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_rememberKey);
  }

  // Dashboard Data Methods
  static Future<void> saveDashboardData(DashboardPointsModel dashboard) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(dashboard.toJson());
    await prefs.setString(_dashboardKey, jsonString);
  }

  static Future<DashboardPointsModel?> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_dashboardKey);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return DashboardPointsModel.fromJson(jsonMap);
  }

  static Future<void> clearDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dashboardKey);
  }
}
