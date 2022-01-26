import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/authentication/authentication.dart';
import 'package:luntian_shop_flutter_next/screens/admin/admin_orders.dart';
import 'package:luntian_shop_flutter_next/screens/admin/products_page.dart';
import 'package:luntian_shop_flutter_next/screens/admin/users_page.dart';
import 'package:luntian_shop_flutter_next/screens/auth/login.dart';
import 'package:luntian_shop_flutter_next/utils/flutter_icons.dart';
import 'package:luntian_shop_flutter_next/utils/src/entypo.dart';

import 'shops_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isLoading = false;

  int usersNo = 0;
  int productsNo = 0;
  int shopsNo = 0;
  int ordersNo = 0;

  List<String> images = [
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png"
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;

    FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        usersNo = querySnapshot.docs.length;
      });
    });

    FirebaseFirestore.instance
        .collection("shops")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        shopsNo = querySnapshot.docs.length;
      });
    });

    FirebaseFirestore.instance
        .collection("product")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        productsNo = querySnapshot.docs.length;
      });
    });

    FirebaseFirestore.instance
        .collection("order")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        ordersNo = querySnapshot.docs.length;
      });
    });

    isLoading = false;
  }

  Widget _buildSingleContainer(
      IconData icon, int count, String name, BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.green[400]!,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.green[400]!),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  count.toString(),
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.green[400]!,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        // MaterialApp(
        //   home:

        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                InkWell(
                  child: Icon(Feather.power),
                )
              ],
              title: Row(
                children: [
                  Text(
                    'Admin Panel',
                    style: GoogleFonts.comfortaa(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

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
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Card(
                    child: Row(
                      children: [
                        Container(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Earnings (Daily):",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                                Text("₱ 200:",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Color(0xff41a58d),
                                        fontWeight: FontWeight.w700)),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Earnings (Monthly):",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                                Text("₱ 6200:",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Color(0xff41a58d),
                                        fontWeight: FontWeight.w700)),

                                SizedBox(
                                  height: 4,
                                ),
                                Text("Earnings (Total):",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                                Text("₱ 6200",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Color(0xff41a58d),
                                        fontWeight: FontWeight.w700)),
                                //   Text("App Total Earnings (Total:)",
                                //       style: TextStyle(color: Colors.black)),
                                //   Text("Sellers CominTotal Earnings (Total:)",
                                //       style: TextStyle(color: Colors.black))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 2,
                        // Generate 100 widgets that display their index in the List.
                        children: //List.generate(4, (index) {
                            [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UsersPage()),
                              );
                            },
                            child: _buildSingleContainer(
                              Entypo.users,
                              usersNo,
                              "Users",
                              context,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopsPage()),
                              );
                            },
                            child: _buildSingleContainer(
                                Entypo.shop, shopsNo, "Shops", context),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminProducts()),
                              );
                            },
                            child: _buildSingleContainer(
                                Entypo.box, productsNo, "Products", context),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminOrders()),
                                );
                              },
                              child: _buildSingleContainer(Entypo.clipboard,
                                  ordersNo, "Orders", context)),
                        ]
                        // }),
                        ),
                  ),
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
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
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
                                  content: const Text('Do you wanna Sign out?'),
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
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                          );
                                        },
                                        child: const Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.red),
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

            //   Container(
            //       // padding: EdgeInsets.all(12.0),
            //       child: Column(
            //     children: [
            //       Container(
            //         color: Colors.white,
            // child: ListTile(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => UsersPage()),
            //     );
            //   },
            //   title: const Text('Users'),
            //   trailing: const Icon(Icons.chevron_right_rounded),
            //   leading: Icon(
            //     Entypo.users,
            //     color: Colors.green[400]!,
            //   ),
            // ),
            //       ),
            //       Container(
            //         color: Colors.white,
            //         child: ListTile(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => ShopsPage()),
            //             );
            //           },
            //           title: const Text('Shops'),
            //           trailing: const Icon(Icons.chevron_right_rounded),
            //           leading: Icon(
            //             Entypo.location,
            //             color: Colors.green[400]!,
            //           ),
            //         ),
            //       ),
            //       Container(
            //         color: Colors.white,
            //         child: ListTile(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => AdminPage()),
            //             );
            //           },
            //           title: const Text('Admin'),
            //           trailing: const Icon(Icons.chevron_right_rounded),
            //           leading: Icon(
            //             Entypo.location,
            //             color: Colors.green[400]!,
            //           ),
            //         ),
            //       ),
            //       Container(
            //         color: Colors.white,
            //         child: ListTile(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => AdminPage()),
            //             );
            //           },
            //           title: const Text('Admin'),
            //           trailing: const Icon(Icons.chevron_right_rounded),
            //           leading: Icon(
            //             Entypo.location,
            //             color: Colors.green[400]!,
            //           ),
            //         ),
            //       ),
            //     ],
            //   )),
            );
    // );
  }
}
