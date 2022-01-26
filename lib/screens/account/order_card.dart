import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:luntian_shop_flutter_next/screens/account/my_orders.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/my_sales.dart';

class OrderCard extends StatefulWidget {
  //const OrderCard({Key? key}) : super(key: key);

  const OrderCard({Key? key}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
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
    User user = _auth.currentUser!;
    return StreamBuilder(
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
            if (doc["status"] == "To Ship" && doc["user_id"] == user.uid) {
              ++to_ship;
            }
            if (doc["status"] == "To Receive" && doc["user_id"] == user.uid) {
              ++receive;
            }
            if (doc["status"] == "Completed" && doc["user_id"] == user.uid) {
              ++completed;
            }
            if (doc["status"] == "Cancel" && doc["user_id"] == user.uid) {
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
                Container(
                  color: Colors.white,
                  child: ListTile(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyOrderScreen(
                                      //shop_id: widget._shop_id,
                                      page_no: 0,
                                    )),
                          ),
                      leading: Icon(
                          MaterialCommunityIcons.clipboard_text_outline,
                          color: Colors.blue[900]),
                      title: Row(
                        children: [
                          Text("My Orders"),
                          Spacer(),
                          Text(
                            "View Purchase History",
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
                                      builder: (context) => MyOrderScreen(
                                            //shop_id: widget._shop_id,
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
                                  Feather.truck,
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
                                      builder: (context) => MyOrderScreen(
                                            //shop_id: widget._shop_id,
                                            page_no: 1,
                                          )),
                                ),
                              ),
                              Text("To Receive")
                            ],
                          ),
                        ),
                        InkWell(
                          child: Column(
                            children: [
                              IconBadge(
                                icon: Icon(
                                  MaterialCommunityIcons.star_circle_outline,
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
                                      builder: (context) => MyOrderScreen(
                                            //shop_id: widget._shop_id,
                                            page_no: 2,
                                          )),
                                ),
                              ),
                              Text("To Rate")
                            ],
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 8,
                ),

                //   Container(
                //     color: Colors.white,
                //     child: ListTile(
                //       onTap: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => UploadProductForm()),
                //       ),
                //       leading: Icon(
                //         Ionicons.md_add_circle_outline,
                //         color: Colors.deepOrange,
                //       ),
                //       title: Text("Add New Products"),
                //       trailing: Icon(Icons.keyboard_arrow_right),
                //     ),
                //   )
              ],
            ),
          );
        });
  }
}
