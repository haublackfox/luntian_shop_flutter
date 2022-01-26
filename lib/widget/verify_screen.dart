import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/bottom_bar.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';

class VerifyScreen extends StatefulWidget {
  // const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;
  bool isLoading = false;
  String shopId = "";
  @override
//   void initState() {
//     super.initState();

//   }

  void getData() async {
    isLoading = true;
    User user = _auth.currentUser!;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    print("kkkkkkkkkkkkkk");
    print(userDoc.get('shop_id'));
    print("kkkkkkkkkkkk");

    // final DocumentSnapshot shopDoc = await FirebaseFirestore.instance
    //     .collection('shops')
    //     .doc(userDoc.get(userDoc.get('shop_id')))
    //     .get();

    try {
      setState(() {
        shopId = userDoc.get('shop_id');
      });

      print("JJJJJJJJJJJJJJJJJJ");
      print(shopId);
      print("JJJJJJJJJJJJJJJJJJ");
    } catch (e) {
      print("ERROR");
      setState(() {
        isLoading = false;
      });
    }

    // print("CCCCCCCCCCCC");
    // print(fullName);
    // print("CCCCCCCCCCCC");

    // _nameCtrl.text = fullName;
    // _addr1Ctrl.text = address1;
    // _addr2Ctrl.text = address2;
    // _phoneCtrl.text = phone;
    // _postalCtrl.text = postal_code;
    isLoading = false;
  }

  @override
  void initState() {
    getData();
    user = auth.currentUser;
    user!.sendEmailVerification();

    checkEmailVerified();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomBarScreen(
                        screenIndex: 4,
                      )),
            );
          },
          child: Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.all(2),
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10),
                //padding: EdgeInsets.all(2),
                child: Image.asset("assets/images/luntian.png",
                    fit: BoxFit.cover, height: 100)),
            Text(
              "Verify your Email",
              style: GoogleFonts.sourceSansPro(
                  color: Colors.black87,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "\nWe have sent an email to ${user!.email}",
              style: GoogleFonts.sourceSansPro(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            Text(
              '\nYou need to verify your email to continue. If you have not received the verification email, please check your "Spam" or "Bulk Email" folder. You can also click the resend button below to have another email sent to you.',
              style: GoogleFonts.sourceSansPro(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              child: ElevatedButton(
                onPressed: () {
                  checkEmailVerified();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "Check again and continue",
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff41a58d)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Color(0xff41a58d))))),
              ),
            ),
            InkWell(
              onTap: () {
                showSnackBar(
                    context,
                    "Email verification was re-sent, please check your email.",
                    Colors.blue,
                    3000);
                user!.sendEmailVerification();
              },
              child: Text(
                "Resend verification Email",
                style: GoogleFonts.sourceSansPro(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    print("AAAAAAAAAAAAA" + user!.emailVerified.toString());
    if (user!.emailVerified == true) {
      FirebaseFirestore.instance.collection('shops').doc(shopId).update({
        "isVerified": true,
      });
      showSnackBar(
          context,
          "Your shop has now been verified. You can setup your shop.",
          Colors.green,
          3000);
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //       builder: (_) => HomeScreen(user: user!, screenIndex: 0)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBarScreen(
                  screenIndex: 4,
                )),
      );
    } else if (user!.emailVerified == false) {}
  }
}
