import 'package:google_fonts/google_fonts.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:luntian_shop_flutter_next/authentication/authentication.dart';
import 'package:luntian_shop_flutter_next/models/user.dart';
import 'package:luntian_shop_flutter_next/provider/products.dart';
import 'package:luntian_shop_flutter_next/provider/user.dart';
import 'package:luntian_shop_flutter_next/screens/account/order_card.dart';
import 'package:luntian_shop_flutter_next/screens/address/address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/account/my_orders.dart';
import 'package:luntian_shop_flutter_next/screens/admin/admin_page.dart';
import 'package:luntian_shop_flutter_next/screens/auth/login.dart';
import 'package:luntian_shop_flutter_next/screens/chats/messages_page.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/my_shop_page.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/sellers_registration.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/upload_product_form.dart';
import 'package:luntian_shop_flutter_next/screens/wishlist.dart';
import 'package:luntian_shop_flutter_next/widget/verify_screen.dart';

import '../user_state.dart';
import '/consts/colors.dart';
import '/consts/my_icons.dart';
import '/provider/dark_theme_provider.dart';
import '../cart.dart';
import '/screens/wishlist/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

// import 'orders/order.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  ScrollController _scrollController = ScrollController();
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid = '';
  String _name = '';
  String _email = '';
  String _joinedAt = '';
  String _userImageUrl = '';
  String _phoneNumber = '';
  String _shopName = '';
  String _shopId = '';
  String _verified = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User user = _auth.currentUser!;
    _uid = user.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');

    print("AAAAAAAAAAAAAAAAAAAAAAAAA" + _uid.toString());
    //user.isAnonymous ? null :
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    // if (userDoc == null) {
    //   return;
    // } else {

    final DocumentSnapshot shopDoc = await FirebaseFirestore.instance
        .collection('shops')
        .doc(userDoc.get('shop_id'))
        .get();

    setState(() {
      _name = userDoc.get('name');
      _email = userDoc.get('email'); //user.email.toString();
      _joinedAt = userDoc.get('joinedAt');
      _phoneNumber = userDoc.get('phone');
      _userImageUrl = userDoc.get(
          'image_url'); //user.photoURL.toString(); //userDoc.get('imageUrl');
      _shopName = userDoc.get('shop_name'); //
      _verified = shopDoc.get('isVerified').toString(); //
    });
    //}

    print("VEEEERRRRRRRRIFFFFFFFFFFFFYYY " + _verified);
    // print("name $_name");
  }

  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser!;
    _uid = user.uid;
    final usersProvider = Provider.of<Users>(context);
    List<UserData> userInfos = usersProvider.users;

    // final productsData = Provider.of<Products>(context);
    // productsData.fetchMyProducts(userInfos[0].shop_id);

    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Account',
          style: GoogleFonts.comfortaa(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),

        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagesPage()),
              );
            },
            child: Container(
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(2),
                child: Icon(AntDesign.message1, color: Colors.black)),
          ),
        ],
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Container(
        //       margin: EdgeInsets.only(left: 5),
        //       padding: EdgeInsets.all(2),
        //       child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        // ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  streamSnapshots) {
            if (streamSnapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshots.data!.docs;

            documents.forEach((doc) {
              if (doc["id"] == _uid) {
                print("TRUEEEEEEEEEEEEEEEE");
                _name = doc["name"];
                _email = doc["email"];
                _shopName = doc['shop_name']; //   userDoc.get('shop_name'); //
                _shopId = doc['shop_id'];
              }
              print("ZZZZZZZZZZ");
              print(doc);
            });

            print(documents);

            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(userInfos[0].email),
                          // Padding(
                          //     padding: const EdgeInsets.only(left: 8.0),
                          //     child: userTitle(title: 'User Bag')),
                          // Divider(
                          //   thickness: 1,
                          //   color: Colors.grey,
                          // ),
                          //   const SizedBox(
                          //     height: 12,
                          //   ),

                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            color: Colors.white,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Center(
                                  child: ClipOval(
                                      child: Material(
                                          color: Colors.blue,
                                          child: _userImageUrl != ''
                                              ? Container(
                                                  height: 75,
                                                  width: 75,
                                                  child: Image.network(
                                                    _userImageUrl,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                )
                                              : user.photoURL != null
                                                  ? Container(
                                                      height: 75,
                                                      width: 75,
                                                      child: Image.network(
                                                        user.photoURL!,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 75,
                                                      width: 75,
                                                      // padding:
                                                      //     const EdgeInsets.symmetric(
                                                      //         horizontal: 36,
                                                      //         vertical: 26),
                                                      child: Center(
                                                        child: Text(
                                                            _email[
                                                                0], //userInfos[0].email[0] ?? '',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        32,
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ))),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _name,
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      child: Text(
                                        // userInfos[0].email != '' ? userInfos[0].email : '',
                                        _email,
                                        //                  userInfos[0].email ?? '',
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Center(
                          //   child: InkWell(
                          //     onTap: () {
                          //       //   Navigator.push(
                          //       //     context,
                          //       //     MaterialPageRoute(
                          //       //         builder: (context) => EditShopScreen()),
                          //       //   );
                          //     },
                          //     splashColor: Theme.of(context).splashColor,
                          //     child: InkWell(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => UploadProductForm()),
                          //         );
                          //       },
                          //       child: const Text(
                          //         'Add a Products',
                          //         style: TextStyle(
                          //             color: Color(0xff41a58d),
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // userInfos[0].shop_name == '' &&
                          //         userInfos[0].shop_name != null
                          //     ? Container()

                          // userInfos[0].shop_name == '' &&
                          //         userInfos[0].shop_name != null
                          //     ?

                          //  : Container(),
                          OrderCard(),

                          _verified != 'false' && _shopName != ''
                              ? Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyShopHome(
                                                  shop_id: _shopId,
                                                )),
                                      );
                                    },
                                    title: const Text('My Shop'),
                                    trailing:
                                        const Icon(Icons.chevron_right_rounded),
                                    leading:
                                        Icon(Entypo.shop, color: Colors.green),
                                  ),
                                )
                              : _verified == "false"
                                  ? Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VerifyScreen()),
                                          );
                                        },
                                        title: const Text('Verify Shop Email'),
                                        trailing: const Icon(
                                            Icons.chevron_right_rounded),
                                        leading: Icon(Entypo.shop,
                                            color: Colors.green),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.green[50],
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SellerRegistration()),
                                          );
                                        },
                                        title: Row(
                                          children: [
                                            Text("Become a Seller"),
                                            Spacer(),
                                            Text(
                                              "Free Registration",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        trailing: const Icon(
                                            Icons.chevron_right_rounded),
                                        leading: Icon(Entypo.shop,
                                            color: Colors.green),
                                      ),
                                    ),

                          //   Center(
                          //       child: InkWell(
                          //         onTap: () {
                          //           //   Navigator.push(
                          //           //     context,
                          //           //     MaterialPageRoute(
                          //           //         builder: (context) => EditShopScreen()),
                          //           //   );
                          //         },
                          //         splashColor: Theme.of(context).splashColor,
                          //         child: InkWell(
                          //           onTap: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       SellerRegistration()),
                          //             );
                          //           },
                          //           child: const Text(
                          //             'Become a Seller',
                          //             style: TextStyle(
                          //                 color: Color(0xff41a58d),
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(WishlistScreen.routeName),
                              splashColor: Colors.red,
                              child: ListTile(
                                title: const Text('Wishlist'),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                                leading: Icon(
                                  Feather.heart,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(CartScreen.routeName);
                              },
                              title: const Text('Cart'),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              leading: Icon(
                                Feather.shopping_cart,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ),
                          //   ListTile(
                          //     onTap: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => MyOrderScreen()),
                          //       );
                          //     },
                          //     title: const Text('My Orders'),
                          //     trailing: const Icon(Icons.chevron_right_rounded),
                          //     leading: Icon(MyAppIcons.bag),
                          //   ),

                          //   ListTile(
                          //     onTap: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => MyOrderScreen()),
                          //       );
                          //     },
                          //     title: const Text('My Profile'),
                          //     trailing: const Icon(Icons.chevron_right_rounded),
                          //     leading: Icon(Icons.person),
                          //   ),

                          Container(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddressScreen()),
                                );
                              },
                              title: const Text('My Address'),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              leading: Icon(
                                Entypo.location,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          //   Container(
                          //     color: Colors.white,
                          //     child: ListTile(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => AdminPage()),
                          //         );
                          //       },
                          //       title: const Text('Admin'),
                          //       trailing: const Icon(Icons.chevron_right_rounded),
                          //       leading: Icon(
                          //         Entypo.location,
                          //         color: Colors.blue,
                          //       ),
                          //     ),
                          //   ),

                          Material(
                            color: Colors.white,
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () async {
                                  // Navigator.canPop(context)? Navigator.pop(context):null;
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6.0),
                                                child: Image.network(
                                                  'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Sign out'),
                                              ),
                                            ],
                                          ),
                                          content: const Text(
                                              'Do you wanna Sign out?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () async {
                                                  //   await _auth.signOut().then(
                                                  //       (value) => Navigator.pop(
                                                  //           context));

                                                  await Authentication.signOut(
                                                      context: context);
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()),
                                                  );
                                                },
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ))
                                          ],
                                        );
                                      });
                                },
                                title: const Text('Logout'),
                                leading: const Icon(
                                  Entypo.log_out,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }

//   Widget _buildFab() {
//     //starting fab position
//     final double defaultTopMargin = 200.0 - 4.0;
//     //pixels from top where scaling should start
//     final double scaleStart = 160.0;
//     //pixels from top where scaling should end
//     final double scaleEnd = scaleStart / 2;

//     double top = defaultTopMargin;
//     double scale = 1.0;
//     if (_scrollController.hasClients) {
//       double offset = _scrollController.offset;
//       top -= offset;
//       if (offset < defaultTopMargin - scaleStart) {
//         //offset small => don't scale down

//         scale = 1.0;
//       } else if (offset < defaultTopMargin - scaleEnd) {
//         //offset between scaleStart and scaleEnd => scale down

//         scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
//       } else {
//         //offset passed scaleEnd => hide fab
//         scale = 0.0;
//       }
//     }

//     return Positioned(
//       top: top,
//       right: 16.0,
//       child: Transform(
//         transform: Matrix4.identity()..scale(scale),
//         alignment: Alignment.center,
//         child: FloatingActionButton(
//           backgroundColor: Colors.purple,
//           heroTag: "btn1",
//           onPressed: () {},
//           child: Icon(Icons.camera_alt_outlined),
//         ),
//       ),
//     );
//   }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
      ),
    );
  }
}
