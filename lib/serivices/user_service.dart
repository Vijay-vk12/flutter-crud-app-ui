import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:reg_user_app/models/user_model.dart';

class UserService {
  late final Future<String> baseUrl;

  UserService() {
    baseUrl = _getBaseUrl();
  }

  Future<String> _getBaseUrl() async {
    if (kIsWeb) {
      print('Running on Web');
      return 'https://mytestandroidloginapp.onrender.com/user';
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.isPhysicalDevice) {
        print('Running on real Android device');
        return 'https://mytestandroidloginapp.onrender.com/user'; // Replace with your local IP
      } else {
        print('Running on Android emulator');
        return 'https://mytestandroidloginapp.onrender.com/user';
      }
    }

    print('Running on iOS or other platform');
    return 'https://mytestandroidloginapp.onrender.com/user'; // Replace with your local IP
  }

  Future<List<User>> getUsers() async {
    try {
      final url = await baseUrl;
      final response = await http
          .get(Uri.parse('$url/all'))
          .timeout(const Duration(seconds: 10));

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((userJson) => User.fromJson(userJson)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    final url = await baseUrl;
    final response = await http.delete(Uri.parse('$url/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<http.Response> saveUser(
      String name, String phone, String email, String address, String password) async {
    final url = await baseUrl;
    var uri = Uri.parse('$url/register');

    Map<String, String> headers = {"Content-type": "application/json"};

    Map<String, String> data = {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'password': password
    };

    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);

    if (kDebugMode) {
      print(response.body);
    }

    return response;
  }

  Future<void> updateUser(User user) async {
    final url = await baseUrl;
    final response = await http.put(
      Uri.parse('$url/update/${user.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update user");
    }
  }
}
