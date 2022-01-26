import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/admin/admin_page.dart';
import 'package:luntian_shop_flutter_next/screens/auth/sign_up.dart';
import 'package:luntian_shop_flutter_next/widget/google_signin_button.dart';

import '../bottom_bar.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _submitForm() async {
    User user = _auth.currentUser!;
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        if (_emailController.text == "luntianshops@gmail.com") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          await _auth
              .signInWithEmailAndPassword(
                  email: _emailController
                      .text, //_emailAddress.toLowerCase().trim(),
                  password: _passwordController.text)
              .then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomBarScreen(
                              screenIndex: 0,
                            )),
                  ));
        }
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
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
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
                Image.asset(
                  "assets/images/luntian.png",
                  scale: 1.5,
                ),
                SizedBox(height: 8),
                Text('Luntian',
                    style: GoogleFonts.courgette(
                        //Courgette
                        textStyle: TextStyle(
                            fontSize: 56,
                            color: Color(0xff41a58d),
                            fontWeight: FontWeight.w500))),
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
                SizedBox(height: 32),
                !_isLoading
                    ? Container(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                            onPressed: _submitForm,
                            child: Text("LOGIN",
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
                      padding: EdgeInsets.all(16),
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
                Text(
                  'Sign in with',
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
