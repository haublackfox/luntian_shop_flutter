import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/my_products.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/my_sales.dart';

import 'upload_product_form.dart';

class MyShopHome extends StatefulWidget {
  //const MyShopHome({Key? key}) : super(key: key);

  const MyShopHome({Key? key, required String shop_id})
      : _shop_id = shop_id,
        super(key: key);

  final String _shop_id;
  @override
  _MyShopHomeState createState() => _MyShopHomeState();
}

class _MyShopHomeState extends State<MyShopHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int to_ship = 0;
  int receive = 0;
  int completed = 0;
  int cancel = 0;
  int refund = 0;

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    User user = _auth.currentUser!;
    // _uid = user.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');

    // print("AAAAAAAAAAAAAAAAAAAAAAAAA" + _uid.toString());
    //user.isAnonymous ? null :
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('shop').doc(user.uid).get();

    // // if (userDoc == null) {
    // //   return;
    // // } else {
    // setState(() {
    //   _name = userDoc.get('name');
    //   _email = userDoc.get('email'); //user.email.toString();
    //   _joinedAt = userDoc.get('joinedAt');
    //   _phoneNumber = userDoc.get('phone');
    //   _userImageUrl = userDoc.get(
    //       'image_url'); //user.photoURL.toString(); //userDoc.get('imageUrl');
    //   _shopName = userDoc.get('shop_name'); //
    // });
    // //}
    // print("name $_name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'My Shop',
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
            receive = 0;
            completed = 0;
            cancel = 0;
            refund = 0;

            documents.forEach((doc) {
              print("IIIIIIIIIIIIIIIIIIII");
              print(doc["shop_id"]);
              print("IIIIIIIIIIIIIIIIIIII");
              //   if (doc["status"] == "To Ship" || doc["status"] == "To Pay") {
              //     ++to_ship;
              //   }
              //   if (doc["status"] == "Cancel") {
              //     ++cancel;
              //   }
              //   if (doc["status"] == "Refund") {
              //     ++refund;
              //   }

              if (doc["status"] == "To Ship" &&
                  doc["shop_id"] == widget._shop_id) {
                ++to_ship;
              }
              if (doc["status"] == "To Receive" &&
                  doc["shop_id"] == widget._shop_id) {
                ++receive;
              }
              if (doc["status"] == "Completed" &&
                  doc["shop_id"] == widget._shop_id) {
                ++completed;
              }
              if (doc["status"] == "Cancel" &&
                  doc["shop_id"] == widget._shop_id) {
                ++cancel;
              }
              if (doc["status"] == "Refund" &&
                  doc["shop_id"] == widget._shop_id) {
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
                  Container(
                    color: Colors.white,
                    child: ListTile(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MySalesScreen(
                                        shop_id: widget._shop_id,
                                        page_no: 0,
                                      )),
                            ),
                        leading: Icon(
                            MaterialCommunityIcons.clipboard_text_outline,
                            color: Colors.blue[900]),
                        title: Row(
                          children: [
                            Text("My Sales"),
                            Spacer(),
                            Text(
                              "View Sales History",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[700]),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.grey[700],
                            )
                          ],
                        )
                        //trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Column(
                              children: [
                                IconBadge(
                                  icon: Icon(
                                    AntDesign.inbox,
                                    size: 32,
                                    color: Colors.grey[600],
                                  ),
                                  itemCount: to_ship,
                                  badgeColor: Colors.red,
                                  itemColor: Colors.white,
                                  hideZero: true,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MySalesScreen(
                                              shop_id: widget._shop_id,
                                              page_no: 0,
                                            )),
                                  ),
                                ),
                                Text("To Ship")
                              ],
                            ),
                          ),
                          InkWell(
                            child: Column(
                              children: [
                                IconBadge(
                                  icon: Icon(
                                    MaterialCommunityIcons.truck_delivery,
                                    size: 32,
                                    color: Colors.grey[600],
                                  ),
                                  itemCount: receive,
                                  badgeColor: Colors.red,
                                  itemColor: Colors.white,
                                  hideZero: true,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MySalesScreen(
                                              shop_id: widget._shop_id,
                                              page_no: 1,
                                            )),
                                  ),
                                ),
                                Text("Shipping")
                              ],
                            ),
                          ),
                          InkWell(
                            child: Column(
                              children: [
                                IconBadge(
                                  icon: Icon(
                                    MaterialCommunityIcons.file_cancel_outline,
                                    size: 32,
                                    color: Colors.grey[600],
                                  ),
                                  itemCount: cancel,
                                  badgeColor: Colors.red,
                                  itemColor: Colors.white,
                                  hideZero: true,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MySalesScreen(
                                              shop_id: widget._shop_id,
                                              page_no: 3,
                                            )),
                                  ),
                                ),
                                Text("Cancelled")
                              ],
                            ),
                          ),
                          InkWell(
                            child: Column(
                              children: [
                                IconBadge(
                                  icon: Icon(
                                    MaterialCommunityIcons.cash_refund,
                                    size: 32,
                                    color: Colors.grey[600],
                                  ),
                                  itemCount: refund,
                                  badgeColor: Colors.red,
                                  itemColor: Colors.white,
                                  hideZero: true,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MySalesScreen(
                                              shop_id: widget._shop_id,
                                              page_no: 4,
                                            )),
                                  ),
                                ),
                                Text("Return/Refund")
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProducts(
                                  shop_id: widget._shop_id,
                                )),
                      ),
                      leading: Icon(
                        Feather.box,
                        color: Colors.deepOrange,
                      ),
                      title: Text("My Products"),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadProductForm()),
                      ),
                      leading: Icon(
                        Ionicons.md_add_circle_outline,
                        color: Colors.deepOrange,
                      ),
                      title: Text("Add New Products"),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
