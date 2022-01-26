import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/address/address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/address/seller_address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/address/shipping_address_screen.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';

import '../../consts/colors.dart';
import '../../services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AdminOrders extends StatefulWidget {
  static const routeName = '/AdminOrders';

  @override
  _AdminOrdersState createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? selectedImage;

  final _formKey = GlobalKey<FormState>();

  var _shopTitle = '';
  var _shopEmail = '';
  var _shopPhone = '';
  var _shopAddress = '';
  var _shopPostalCode = '';
//   var _productQuantity = '';

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  String _categoryValue = '';
  String _brandValue = '';
  GlobalMethods _globalMethods = GlobalMethods();
  DateTime now = DateTime.now();

  File? _pickedImage;
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

    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
    print(userDoc);
    print(userDoc != null);
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");

    try {
      setState(() {
        fullName = userDoc.get('name');
        address1 = userDoc.get('address1');
        address2 = userDoc.get('address2');
        phone = userDoc.get('phone');
        postal_code = userDoc.get('postal_code');
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

  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    final isValid = _formKey.currentState!.validate() && hasAddress;
    FocusScope.of(context).unfocus();

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
    if (isValid) {
      _formKey.currentState?.save();
      final User user = _auth.currentUser!;
      final _uid = user.uid;
      final shop_id = uuid.v4();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('shopImages')
              .child(_shopTitle + now.toString() + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('shops')
              .doc(shop_id)
              .set({
            'id': shop_id,
            'user_id': _uid,
            'shop_name': _shopTitle,
            'shop_logo': url,
            'cover_photo': '',
            'createdAt': Timestamp.now(),
          });

          usersRef.doc(_uid).update({
            "shop_id": shop_id,
            "shop_name": _shopTitle,
          });

          showSnackBar(
              context,
              "Shop has been successfully registered, you can now acces 'My Shop'.",
              Colors.green,
              3000);
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
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
    final User user = _auth.currentUser!;
    final _uid = user.uid;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        //   appBar: AppBar(
        //     backgroundColor: Color(0xff41a58d),
        //     title: Text("Seller Registration"),
        //     centerTitle: true,
        //   ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            'List of Orders',
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
        // bottomSheet: Container(
        //   height: kBottomNavigationBarHeight * 0.8,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: ColorsConsts.white,
        //     border: Border(
        //       top: BorderSide(
        //         color: Colors.grey,
        //         width: 0.5,
        //       ),
        //     ),
        //   ),
        //   child: Material(
        //     color: Theme.of(context).backgroundColor,
        //     child: InkWell(
        //       onTap: _trySubmit,
        //       splashColor: Colors.grey,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.max,
        //         children: <Widget>[
        //           Padding(
        //             padding: const EdgeInsets.only(right: 2),
        //             child: _isLoading
        //                 ? Center(
        //                     child: Container(
        //                         height: 40,
        //                         width: 40,
        //                         child: CircularProgressIndicator()))
        //                 : Container(
        //                     //width: 100,
        //                     child: ElevatedButton(
        //                         onPressed: _trySubmit,
        //                         //onPressed: () {}, //_submitForm,
        //                         child: Row(children: [
        //                           Text("Register Shop",
        //                               style: GoogleFonts.comfortaa(
        //                                   fontSize: 16,
        //                                   color: Colors.white,
        //                                   fontWeight: FontWeight.w700)),
        //                         ]),
        //                         style: ElevatedButton.styleFrom(
        //                           //shape: StadiumBorder(),
        //                           primary: Color(0xff41a58d),
        //                         )),
        //                   ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
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

              return Container(
                child: ListView(children: [
                  SizedBox(
                    height: 4,
                  ),
                  //   Column(
                  //     children: [Text(documents.length.toString())],
                  //   ),
                  ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) => Container(
                            child: Card(
                                child: Container(
                                    height: 120,

                                    //margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight:
                                              const Radius.circular(16.0),
                                          topRight: const Radius.circular(16.0),
                                        ),
                                        //color: Colors.grey[100],
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 130,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  documents[index]
                                                      .data()["imageUrl"]),
                                              //  fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6.0,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        documents[index]
                                                            .data()["name"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15),
                                                      ),
                                                    ),
                                                    // Spacer(),
                                                    // Text(
                                                    //   //   "Status: " +
                                                    //   documents[index]
                                                    //       .data()["status"],
                                                    //   maxLines: 1,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    //   style: GoogleFonts.roboto(
                                                    //       color: Colors.green,
                                                    //       fontWeight:
                                                    //           FontWeight.w400,
                                                    //       fontSize: 15),
                                                    // ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "Shop: " +
                                                            documents[index]
                                                                    .data()[
                                                                "brand"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "Status: " +
                                                            documents[index]
                                                                    .data()[
                                                                "status"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    // Text(
                                                    //   'Sub Total:',
                                                    //   style: GoogleFonts.openSans(
                                                    //       color: Colors.grey[600],
                                                    //       fontSize: 16,
                                                    //       fontWeight: FontWeight.w400),
                                                    // ),
                                                    // SizedBox(
                                                    //   width: 5,
                                                    // ),
                                                    FittedBox(
                                                      child: Text(
                                                        "PHP " +
                                                            documents[index]
                                                                .data()["price"]
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,

                                                          color: Colors.green,

                                                          // color: themeChange.darkTheme
                                                          //     ? Colors.brown.shade900
                                                          //     : Color(0xff41a58d)
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    FittedBox(
                                                      child: Text(
                                                        "x" +
                                                            documents[index]
                                                                .data()[
                                                                    "quantity"]
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,

                                                          color: Colors.green,

                                                          // color: themeChange.darkTheme
                                                          //     ? Colors.brown.shade900
                                                          //     : Color(0xff41a58d)
                                                        ),
                                                      ),
                                                    ),
                                                    // Spacer(),
                                                    // FittedBox(
                                                    //   child: Text(
                                                    //     "x" +
                                                    //         quantity
                                                    //             .toString() +
                                                    //         "    ",
                                                    //     style: TextStyle(
                                                    //       fontSize: 14,
                                                    //       fontWeight:
                                                    //           FontWeight.w400,
                                                    //       // color: themeChange.darkTheme
                                                    //       // ? Colors.brown.shade900
                                                    //       // : Color(0xff41a58d)
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                Divider(
                                                  height: 2,
                                                  color: Colors.grey[400],
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Spacer(),
                                                //     ElevatedButton(
                                                //         onPressed: null, child: Text("Pending"))
                                                //   ],
                                                // )
                                                Row(
                                                  children: [
                                                    Text(
                                                      "    " + "Order ID",
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                        "#" +
                                                            documents[index]
                                                                .data()["id"]
                                                                .toString()
                                                                .substring(
                                                                    0, 13)
                                                                .toUpperCase() +
                                                            "    ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600
                                                            // color: Colors.green,
                                                            ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))

                                //   Container(
                                //     padding: EdgeInsets.symmetric(vertical: 8),
                                //     child: Row(
                                //       children: [
                                //         SizedBox(
                                //           width: 8,
                                //         ),
                                //         ClipOval(
                                //             child: Material(
                                //                 color: Colors.blue,
                                //                 child:
                                //                     // documents[index]
                                //                     //             .data()["image_url"] !=
                                //                     //         ''
                                //                     //     ? Image.network(
                                //                     //         documents[index]
                                //                     //             .data()["image_url"]
                                //                     //             .toString(),
                                //                     //         fit: BoxFit.fitHeight,
                                //                     //       )
                                //                     //     :
                                //                     Container(
                                //                   width: 50,
                                //                   height: 50,
                                //                   //   padding: const EdgeInsets.symmetric(
                                //                   //       horizontal: 20, vertical: 20),
                                //                   child: Center(
                                //                     child: Text(
                                //                         documents[index]
                                //                                 .data()["email"]
                                //                                 .toString()[
                                //                             0], //userInfos[0].email[0] ?? '',
                                //                         style: const TextStyle(
                                //                             fontSize: 20,
                                //                             color: Colors.white)),
                                //                   ),
                                //                 ))),
                                //         SizedBox(
                                //           width: 8,
                                //         ),
                                //         Column(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             Text(
                                //               documents[index]
                                //                   .data()["name"]
                                //                   .toString(),
                                //               style: TextStyle(fontSize: 16),
                                //             ),
                                //             SizedBox(
                                //               height: 4,
                                //             ),
                                //             Text(documents[index]
                                //                 .data()["email"]
                                //                 .toString())

                                //             //   Text(to_ship.toString())
                                //           ],
                                //         ),
                                //         //   Text(to_ship.toString())
                                //       ],
                                //     ),
                                //   ),
                                ),
                          )

                      //   Container(
                      //         padding: const EdgeInsets.all(8),
                      //         child: Text(to_ship[index][0]),
                      //       )

                      ),
                ]),
              );
              ;
            }));
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
