import 'package:firebase_auth/firebase_auth.dart';
import 'package:luntian_shop_flutter_next/screens/admin/admin_page.dart';

import 'my_shop/upload_product_form.dart';
import '../screens/landing_page.dart';
import 'package:flutter/material.dart';

import 'bottom_bar.dart';

class MainScreens extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser!;
    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
    print(user.uid);
    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
    return user.uid == "4dkstbCYNTWkVj4N2sIzibPaKqu1"
        ? AdminPage()
        : PageView(
            children: [
              BottomBarScreen(
                screenIndex: 0,
              ),
              UploadProductForm()
            ],
          );
  }
}
