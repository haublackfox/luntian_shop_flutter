import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luntian_shop_flutter_next/widget/google_signin_button.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import '/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bottom_bar.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usersRef = FirebaseFirestore.instance.collection('users');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _isLoading = false;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await _auth
            .createUserWithEmailAndPassword(
                email:
                    _emailController.text, //_emailAddress.toLowerCase().trim(),
                password: _passwordController.text)
            .catchError((error) {
          showSnackBar(
              context, error.toString().split("]")[1], Colors.red, 3000);
        });

        //REUSE FOR SIGNING UP
        final User user = _auth.currentUser!;
        final _uid = user.uid;
        user.reload();

        print("AAAAAAAAAAAAAAAAAAAAA" + user.uid.toString());
        //user.updateProfile(displayName: )

        var date = DateTime.now().toString();
        var dateparse = DateTime.parse(date);
        var formattedDate =
            "${dateparse.day}-${dateparse.month}-${dateparse.year}";

        DocumentSnapshot doc = await usersRef.doc(_uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'phone': _auth.currentUser?.phoneNumber ?? '',
            'address': '',
            'image_url': _auth.currentUser?.photoURL ?? '',
            'shop_name': '',
            'shop_id': '',
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
        }

        //REUSE FOR SIGNING UP
        showSnackBar(
            context,
            "Your account has been registered. You can now Log In.",
            Colors.green,
            3000);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (error) {
        //_globalMethods.authErrorHandle(error.message, context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

//    createUserInFireStore() async {
//     DocumentSnapshot doc = await usersRef.doc(_user.uid).get();
//     if (!doc.exists) {
//       usersRef.doc(_user.uid).set({
//         "id": _user.uid,
//         "photoUrl": _user.photoURL,
//         "email": _user.email,
//         "displayName": _user.displayName,
//       });
//     }
//   }

  @override
  Widget build(BuildContext context) {
    Widget _buildSocialBtn(Function onTap, AssetImage logo) {
      return GestureDetector(
        onTap: () => onTap,
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
              image: logo,
            ),
          ),
        ),
      );
    }

    Widget _buildSocialBtnRow() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // _buildSocialBtn(
            //   () => print('Login with Facebook'),
            //   AssetImage(
            //     'assets/images/facebook.jpg',
            //   ),
            // ),
            GoogleSignInButton()
          ],
        ),
      );
    }

    Widget _buildSignupBtn() {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Have an Account? ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  color: Color(0xff41a58d),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //   Image.asset(
                //     "assets/images/luntian.png",
                //     scale: 1.5,
                //   ),
                SizedBox(height: 40),
                Text('Create Account',
                    style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                            fontSize: 36,
                            color: Color(0xff41a58d),
                            fontWeight: FontWeight.w500))),
                SizedBox(height: 40),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'The Name must be provided.';
                    } else if (name.length < 3) {
                      return 'Name length requires 3 or more characters.';
                    }
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'The email must be provided.';
                    } else if (EmailValidator.validate(email) == false) {
                      return 'A valid email must be provided.';
                    }
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (password) {
                    if (password!.isEmpty) {
                      return 'The password must be provided.';
                    } else if (password.length < 6) {
                      return 'Password length requires 6 or more characters.';
                    }
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _confirmPasswordController,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                      child: Icon(_obscureText2
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: UnderlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                  validator: (password) {
                    if (password!.isEmpty) {
                      return 'The confirm password must be provided.';
                    } else if (password != _passwordController.text) {
                      return 'Confirm password must match the previous password.';
                    }
                  },
                ),

                SizedBox(height: 32),
                !_isLoading
                    ? Container(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                            onPressed: _submitForm
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => BottomBarScreen()),
                            // );
                            ,
                            child: Text("CREATE ACCOUNT",
                                style: GoogleFonts.comfortaa(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Color(0xff41a58d),
                            )),
                      )
                    : CircularProgressIndicator(),
                SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: Divider(
                      height: 2,
                      thickness: 2,
                      //color: Colors.black,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Or",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                    child: Divider(
                      height: 2,
                      thickness: 2,
                      // color: Colors.black,
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Text(
                  'Sign up with',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                _buildSocialBtnRow(),
                _buildSignupBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
