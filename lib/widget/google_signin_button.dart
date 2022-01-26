import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/authentication.dart';
import '../screens/bottom_bar.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: _isSigningIn
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              )
            : GestureDetector(
                onTap: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  User? user =
                      await Authentication.signInWithGoogle(context: context);

                  //   final User user = _auth.currentUser;
                  final _uid = user?.uid;
                  user?.reload();

                  var date = DateTime.now().toString();
                  var dateparse = DateTime.parse(date);
                  var formattedDate =
                      "${dateparse.day}-${dateparse.month}-${dateparse.year}";

                  DocumentSnapshot doc = await usersRef.doc(_uid).get();
                  if (!doc.exists) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .set({
                      'id': _uid,
                      'name': user?.displayName ?? '',
                      'email': user?.email ?? '',
                      'password': '',
                      'phone': user?.phoneNumber ?? '',
                      'address': '',
                      'image_url': user?.photoURL ?? '',
                      'shop_name': '',
                      'shop_id': '',
                      'joinedAt': formattedDate,
                      'createdAt': Timestamp.now(),
                    });
                  }

                  setState(() {
                    _isSigningIn = false;
                  });

                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BottomBarScreen(
                          screenIndex: 0,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/google.jpg',
                      ),
                    ),
                  ),
                ),
              ));
  }
}
