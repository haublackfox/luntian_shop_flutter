import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:luntian_shop_flutter_next/screens/address/shipping_address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/my_sales.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import 'package:uuid/uuid.dart';

import 'upload_product_form.dart';

class ArrangeShipmentPage extends StatefulWidget {
  //const ArrangeShipmentPage({Key? key}) : super(key: key);

  const ArrangeShipmentPage({
    Key? key,
    required List toship,
  })  : _toship = toship,
        super(key: key);

  final List _toship;
//   final String _order_id;
  @override
  _ArrangeShipmentPageState createState() => _ArrangeShipmentPageState();
}

class _ArrangeShipmentPageState extends State<ArrangeShipmentPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int to_ship = 0;
  int cancel = 0;
  int refund = 0;
  bool _isLoading = false;
  String url = '';
  var uuid = const Uuid();
  var fullName = '';
  var phone = '';
  var address1 = '';
  var postal_code = '';
  var address2 = '';
  bool isLoading = false;
  bool hasAddress = true;

  var customerfullName = '';
  var customerphone = '';
  var customeraddress1 = '';
  var customerpostal_code = '';
  var customeraddress2 = '';

//   @override
//   void initState() {
//     super.initState();

//     getData();
//   }

//   void getData() async {
//     User user = _auth.currentUser!;
//     // _uid = user.uid;

//     print('user.displayName ${user.displayName}');
//     print('user.photoURL ${user.photoURL}');

//     // print("AAAAAAAAAAAAAAAAAAAAAAAAA" + _uid.toString());
//     //user.isAnonymous ? null :
//     final DocumentSnapshot userDoc =
//         await FirebaseFirestore.instance.collection('shop').doc(user.uid).get();

//     // // if (userDoc == null) {
//     // //   return;
//     // // } else {
//     // setState(() {
//     //   _name = userDoc.get('name');
//     //   _email = userDoc.get('email'); //user.email.toString();
//     //   _joinedAt = userDoc.get('joinedAt');
//     //   _phoneNumber = userDoc.get('phone');
//     //   _userImageUrl = userDoc.get(
//     //       'image_url'); //user.photoURL.toString(); //userDoc.get('imageUrl');
//     //   _shopName = userDoc.get('shop_name'); //
//     // });
//     // //}
//     // print("name $_name");
//   }

  void _trySubmit() async {
    // print("SSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    // final isValid = _formKey.currentState!.validate() && hasAddress;
    // FocusScope.of(context).unfocus();

    // if (isValid) {
    //   _formKey.currentState?.save();
    //   print(_shopTitle);
    //   //   print(_productPrice);
    //   //   print(_productCategory);
    //   //   print(_productBrand);
    //   //   print(_productDescription);
    //   //   print(_productQuantity);
    //   // Use those values to send our request ...
    // }
    //if (isValid) {
    //_formKey.currentState?.save();
    final User user = _auth.currentUser!;
    final _uid = user.uid;
    final shop_id = uuid.v4();
    try {
      //   final DocumentSnapshot userDoc = await FirebaseFirestore.instance
      //       .collection('shipping_address')
      //       .doc(user.uid)
      //       .get();

      //   final DocumentSnapshot customerDoc = await FirebaseFirestore.instance
      //       .collection('shipping_address')
      //       .doc(widget._toship[1])
      //       .get();

      print("AHKJFHDKJFHDSKJFHSDKF");

      FirebaseFirestore.instance
          .collection('order')
          .doc(widget._toship[0])
          .update({
        "status": "To Receive",
      });

      showSnackBar(context, "Product is now ready to ship", Colors.green, 3000);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MySalesScreen(
                  page_no: 1,
                  shop_id: widget._toship[2],
                )),
      );

      //   Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (error) {
      //_globalMethods.authErrorHandle(error.toString(), context);
      print('error occured ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    //}
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    User user = _auth.currentUser!;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('shipping_address')
        .doc(user.uid)
        .get();

    final DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection('shipping_address')
        .doc(widget._toship[1])
        .get();

    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
    print(user.uid);
    print(widget._toship[1]);
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");

    try {
      setState(() {
        fullName = userDoc.get('name');
        address1 = userDoc.get('address1');
        address2 = userDoc.get('address2');
        phone = userDoc.get('phone');
        postal_code = userDoc.get('postal_code');

        customerfullName = customerDoc.get('name');
        customeraddress1 = customerDoc.get('address1');
        customeraddress2 = customerDoc.get('address2');
        customerphone = customerDoc.get('phone');
        customerpostal_code = customerDoc.get('postal_code');
      });
    } catch (e) {
      print("ERROR");
      setState(() {
        hasAddress = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Arrange Shipment ',
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('order').snapshots(),
          builder: (ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  streamSnapshots) {
            if (streamSnapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshots.data!.docs;
            to_ship = 0;
            cancel = 0;
            refund = 0;

            documents.forEach((doc) {
              print("IIIIIIIIIIIIIIIIIIII");
              print(doc["shop_id"]);
              print("IIIIIIIIIIIIIIIIIIII");
              if (doc["status"] == "To Ship" || doc["status"] == "To Pay") {
                ++to_ship;
              }
              if (doc["status"] == "Cancel") {
                ++cancel;
              }
              if (doc["status"] == "Refund") {
                ++refund;
              }
              //   print("ZZZZZZZZZZ");
              //   print(doc);
              print("ZZZZZZZZZZ");
              print(to_ship);
              print("ZZZZZZZZZZ");
            });
            return Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Card(
                    elevation: 0.5,
                    child: ListTile(
                      trailing: InkWell(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShippingAddressScreen(
                                          toship: widget._toship,
                                        )),
                              ),
                          child: Icon(Icons.edit)),
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.pin_drop,
                              color: Color(0xff41a58d),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pickup Address"),
                                SizedBox(height: 4),
                                !hasAddress
                                    ? Text(
                                        "Please set you Address ->",
                                        style: TextStyle(fontSize: 14),
                                      )
                                    : Container(),
                                Text(
                                  fullName + " | " + phone,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  address2,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  address1,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  postal_code,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Card(
                    elevation: 0.5,
                    child: ListTile(
                      //   trailing: InkWell(
                      //       onTap: () {},
                      //       //   => Navigator.push(
                      //       //         context,
                      //       //         MaterialPageRoute(
                      //       //             builder: (context) => ShippingAddressScreen(
                      //       //                   toship: widget._toship,
                      //       //                 )),
                      //       //),
                      //       child: Icon(Icons.edit)),
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.pin_drop,
                              color: Color(0xff41a58d),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Customer Address"),
                                SizedBox(height: 4),
                                !hasAddress
                                    ? Text(
                                        "Please set you Address ->",
                                        style: TextStyle(fontSize: 14),
                                      )
                                    : Container(),
                                Text(
                                  customerfullName + " | " + phone,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  customeraddress2,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  customeraddress1,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  customerpostal_code,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _trySubmit, //_submitForm,
                      child: Text("CONFIRM",
                          style: GoogleFonts.comfortaa(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        //shape: StadiumBorder(),
                        primary: Color(0xff41a58d),
                      )),
                ],
              ),
            );
          }),
    );
  }
}
