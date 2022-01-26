import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import 'package:uuid/uuid.dart';

class RateProduct extends StatefulWidget {
//   const RateProduct({Key? key}) : super(key: key);

  final String productId;

  final String orderId;

  const RateProduct({required this.productId, required this.orderId});

  @override
  _RateProductState createState() => _RateProductState();
}

class _RateProductState extends State<RateProduct> {
  final messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uuid = const Uuid();
  int _selectRate = 5;
  bool _isLoading = false;
  String senderName = "";

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    User user = _auth.currentUser!;

    //user.isAnonymous ? null :
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      senderName = userDoc.get('name');
      //senderPhone = userDoc.get('phoneNumber');
    });
  }

  void _trySubmit() async {
    setState(() {
      _isLoading = true;
    });
    final User user = _auth.currentUser!;
    final _uid = user.uid;
    final custom_id = uuid.v4();

    try {
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(custom_id)
          .set({
        'user_id': _uid,
        'rating_no': _selectRate,
        'rated_by': senderName,
        'product_id': widget.productId,
        'comment': messageController.text
      });

      print("LLLLLLLLLLLLLLLLLL");
      print(widget.productId);
      print("LLLLLLLLLLLLLLLLLL");
      print("LLLLLLLLLLLLLLLLLL");
      print(widget.orderId);
      print("LLLLLLLLLLLLLLLLLL");

      await FirebaseFirestore.instance
          .collection('order')
          .doc(widget.orderId)
          .update({
        'rated': "1",
      });

      showSnackBar(context, "Product rated successfully", Colors.green, 3000);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (error) {
      // _globalMethods.authErrorHandle(error.toString(), context);
      // print('error occured ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            //onTap: _trySubmit,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()))
                      : Container(
                          //width: 100,
                          child: ElevatedButton(
                              onPressed: _trySubmit,
                              //onPressed: () {}, //_submitForm,
                              child: Row(children: [
                                Text("Submit Rating",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              style: ElevatedButton.styleFrom(
                                //shape: StadiumBorder(),
                                primary: Color(0xff41a58d),
                              )),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Rate Product',
          style: GoogleFonts.comfortaa(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.all(2),
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 24),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.all(2),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectRate = index + 1;
                          });
                        },
                        child: index < _selectRate
                            ? Icon(Icons.star,
                                size: 40, color: Colors.yellow[600])
                            : Icon(Icons.star_border,
                                size: 40, color: Colors.yellow[600])),
                  );
                }),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      //   TextSpan(
                      //       text: '*',
                      //       style: TextStyle(
                      //         color: Colors.red[300],
                      //       )),
                      TextSpan(
                          text: 'Comment',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600])),
                    ],
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText:
                        "Share your experience and help others make better choices!",
                    hintStyle: TextStyle(color: Colors.grey[700]),
                    border: InputBorder.none,
                  ),
                  maxLines: 12,
                  minLines: 12,
                  controller: messageController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
