import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String image_url;
  final String shop_name;
  final String shop_id;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.image_url,
    required this.shop_name,
    required this.shop_id,
  });
}
