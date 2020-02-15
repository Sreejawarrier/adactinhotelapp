import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails userDetails) =>
    json.encode(userDetails.toJson());

class UserDetails extends Equatable {
  static const String _loggedUser = "Loggeduser";

  final String username;
  final String token;

  UserDetails({this.username, this.token});

  @override
  List<Object> get props => [username, token];

  factory UserDetails.fromSharedPreferences(SharedPreferences preferences) {
    final String savedData = preferences.getString(_loggedUser);
    if (savedData?.isNotEmpty == true) {
      return userDetailsFromJson(savedData);
    }

    return null;
  }

  Future<void> toPreferences(SharedPreferences preferences) async {
    await preferences.setString(_loggedUser, json.encode(toJson()));
  }

  static Future<void> removeFromPreferences(
      SharedPreferences preferences) async {
    await preferences.remove(_loggedUser);
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        username: json["username"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "token": token,
      };

  @override
  String toString() {
    return 'UserDetails { $username, $token }';
  }
}
