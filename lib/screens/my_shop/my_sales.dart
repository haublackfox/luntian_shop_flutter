import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/arrange_shipment.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MySalesScreen extends StatefulWidget {
  const MySalesScreen({Key? key, required String shop_id, required int page_no})
      : _shop_id = shop_id,
        _page_no = page_no,
        super(key: key);

  final String _shop_id;
  final int _page_no;
  @override
  _MySalesScreenState createState() => _MySalesScreenState();
}

class _MySalesScreenState extends State<MySalesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    getData();

    super.initState();
  }

  void getData() {
    setState(() {
      _selectedPageIndex = widget._page_no;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: ThemeFromThemeMode(value.themeMode()),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              'My Sales',
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
                  child:
                      Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
            ),
          ),
          body: DefaultTabController(
            length: 5,
            initialIndex: _selectedPageIndex,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    /*-------------- Build Tabs here ------------------*/
                    TabBar(
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.green,
                      isScrollable: true,
                      tabs: [
                        Tab(
                            child: Text("To Ship",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Tab(
                            child: Text("Shipping",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Tab(
                            child: Text("Completed",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Tab(
                            child: Text("Cancelled",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Tab(
                            child: Text("Return Refund",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                      ],
                    )
                  ],
                ),
              ),

              /*--------------- Build Tab body here -------------------*/
              body: TabBarView(
                children: <Widget>[
                  getTabContent('2'),
                  getTabContent('3'),
                  getTabContent('4'),
                  getTabContent('5'),
                  getTabContent('6'),
                ],
              ),
            ),
          ),
        ));
  }

  Widget getTabContent(String text) {
    User user = _auth.currentUser!;
    var to_ship = [];
    var to_receive = [];
    var completed = [];
    var cancel = [];
    var refund = [];

    return Scaffold(
      backgroundColor: Colors.white,
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
            to_ship = [];
            to_receive = [];
            completed = [];
            cancel = [];
            refund = [];
            print("DDDDDDDDDDDDDDDDDDDDDDD");
            print(widget._shop_id);
            print("DDDDDDDDDDDDDDDDDDDDDDD");
            documents.forEach((doc) {
              print("IIIIIIIIIIIIIIIIIIII");
              print(doc["shop_id"]);
              print("IIIIIIIIIIIIIIIIIIII");
              if (doc["shop_id"] == widget._shop_id &&
                  doc["status"] == "To Ship") {
                print("TRUEEEEEEEEEEEEEEEE");
                print(doc["price"]);
                // _name = doc["name"];
                // _email = doc["email"];
                to_ship.add([
                  doc["id"],
                  doc["user_id"],
                  doc["shop_id"],
                  doc["price"], //3
                  doc["imageUrl"],
                  doc["quantity"], //5
                  doc["status"],
                  doc["order_time"],
                  doc["ship_time"],
                  doc["completed_time"],
                  doc["rated"],
                  doc["name"],
                ]);
              }

              if (doc["shop_id"] == widget._shop_id &&
                  doc["status"] == "To Receive") {
                print("TRUEEEEEEEEEEEEEEEE");
                print(doc["price"]);
                // _name = doc["name"];
                // _email = doc["email"];
                to_receive.add([
                  doc["id"],
                  doc["user_id"],
                  doc["shop_id"],
                  doc["price"], //3
                  doc["imageUrl"],
                  doc["quantity"], //5
                  doc["status"],
                  doc["order_time"],
                  doc["ship_time"],
                  doc["completed_time"],
                  doc["rated"],
                  doc["name"],
                ]);
              }

              if (doc["shop_id"] == widget._shop_id &&
                  doc["status"] == "Completed") {
                print("TRUEEEEEEEEEEEEEEEE");
                print(doc["price"]);
                // _name = doc["name"];
                // _email = doc["email"];
                completed.add([
                  doc["id"],
                  doc["user_id"],
                  doc["shop_id"],
                  doc["price"], //3
                  doc["imageUrl"],
                  doc["quantity"], //5
                  doc["status"],
                  doc["order_time"],
                  doc["ship_time"],
                  doc["completed_time"],
                  doc["rated"],
                  doc["name"],
                ]);
              }

              if (doc["shop_id"] == widget._shop_id &&
                  doc["status"] == "Cancel") {
                print("TRUEEEEEEEEEEEEEEEE");
                print(doc["price"]);
                // _name = doc["name"];
                // _email = doc["email"];
                cancel.add([
                  doc["id"],
                  doc["user_id"],
                  doc["shop_id"],
                  doc["price"], //3
                  doc["imageUrl"],
                  doc["quantity"], //5
                  doc["status"],
                  doc["order_time"],
                  doc["ship_time"],
                  doc["completed_time"],
                  doc["rated"],
                  doc["name"],
                ]);
              }

              if (doc["shop_id"] == widget._shop_id &&
                  doc["status"] == "Refund") {
                print("TRUEEEEEEEEEEEEEEEE");
                print(doc["price"]);
                // _name = doc["name"];
                // _email = doc["email"];
                refund.add([
                  doc["id"],
                  doc["user_id"],
                  doc["shop_id"],
                  doc["price"], //3
                  doc["imageUrl"],
                  doc["quantity"], //5
                  doc["status"],
                  doc["order_time"],
                  doc["ship_time"],
                  doc["completed_time"],
                  doc["rated"],
                  doc["name"],
                ]);
              }
              //   print("ZZZZZZZZZZ");
              //   print(doc);
              print("ZZZZZZZZZZ");
              print(to_ship);
              print("ZZZZZZZZZZ");
            });

            print(documents);
            // return Card(
            //   child: Container(
            //       height: 200,
            //       child: Column(
            //         children: [Text("data"), Row()],
            //       )),
            // );
            if (text == '2') {
              return to_ship != 0
                  ? ListView.builder(
                      itemCount: to_ship.length,
                      itemBuilder: (ctx, index) => Card(
                            child: Column(
                              children: [
                                //   Text(to_ship.toString())
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    Text("To Ship    ",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))
                                  ],
                                ),
                                productCard(
                                    to_ship[index][4],
                                    to_ship[index][11],
                                    to_ship[index][3],
                                    to_ship[index][5]),
                                SizedBox(
                                  height: 8,
                                ),
                                Divider(
                                  height: 2,
                                  color: Colors.grey[400],
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "Total Payment: ",
                                      //   "Amount Payable: ",
                                    ),
                                    Text(
                                        "₱" +
                                            (to_ship[index][3] *
                                                    to_ship[index][5])
                                                .toString() +
                                            "    ",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))
                                  ],
                                ),
                                Divider(
                                  height: 2,
                                  color: Colors.grey[400],
                                ),

                                Row(
                                  children: [
                                    Spacer(),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff41a58d)
                                            // padding: EdgeInsets.symmetric(
                                            //     horizontal: 50, vertical: 20),
                                            // textStyle: TextStyle(
                                            //     fontSize: 30,
                                            //     fontWeight: FontWeight.bold
                                            ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArrangeShipmentPage(
                                                      toship: to_ship[index],
                                                    )),
                                          );
                                        },
                                        child: Text("Arrange Shipment"))
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
                                            to_ship[index][0]
                                                .toString()
                                                .substring(0, 13)
                                                .toUpperCase() +
                                            "    ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600
                                            // color: Colors.green,
                                            ))
                                  ],
                                ),
                              ],
                            ),
                          )

                      //   Container(
                      //         padding: const EdgeInsets.all(8),
                      //         child: Text(to_ship[index][0]),
                      //       )

                      )
                  : Center(
                      child: Text('No Orders Yet',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff5d5f60),
                          )),
                    );
              ;
            }

            if (text == '3') {
              return ListView.builder(
                  itemCount: to_receive.length,
                  itemBuilder: (ctx, index) => Card(
                        child: Column(
                          children: [
                            //   Text(to_ship.toString())
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text("To Ship    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(
                                to_receive[index][4],
                                to_receive[index][11],
                                to_receive[index][3],
                                to_receive[index][5]),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Total Payment: ",
                                  //   "Amount Payable: ",
                                ),
                                Text(
                                    "₱" +
                                        (to_receive[index][3] *
                                                to_receive[index][5])
                                            .toString() +
                                        "    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),

                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                    onPressed: null,
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ArrangeShipmentPage(
                                    //               toship: to_receive[index],
                                    //             )),
                                    //   );
                                    // },
                                    child: Text("Out for Delivery"))
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
                                        to_receive[index][0]
                                            .toString()
                                            .substring(0, 13)
                                            .toUpperCase() +
                                        "    ",
                                    style: TextStyle(fontWeight: FontWeight.w600
                                        // color: Colors.green,
                                        ))
                              ],
                            ),
                          ],
                        ),
                      )

                  //   Container(
                  //         padding: const EdgeInsets.all(8),
                  //         child: Text(to_ship[index][0]),
                  //       )

                  );
            }

            if (text == '4') {
              return ListView.builder(
                  itemCount: completed.length,
                  itemBuilder: (ctx, index) => Card(
                        child: Column(
                          children: [
                            //   Text(to_ship.toString())
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text("Completed    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(
                                completed[index][4],
                                completed[index][11],
                                completed[index][3],
                                completed[index][5]),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Total Payment: ",
                                  //   "Amount Payable: ",
                                ),
                                Text(
                                    "₱" +
                                        (completed[index][3] *
                                                completed[index][5])
                                            .toString() +
                                        "    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),

                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                    onPressed: null,
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ArrangeShipmentPage(
                                    //               toship: to_receive[index],
                                    //             )),
                                    //   );
                                    // },
                                    child: Text("Order Received"))
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
                                        completed[index][0]
                                            .toString()
                                            .substring(0, 13)
                                            .toUpperCase() +
                                        "    ",
                                    style: TextStyle(fontWeight: FontWeight.w600
                                        // color: Colors.green,
                                        ))
                              ],
                            ),
                          ],
                        ),
                      )

                  //   Container(
                  //         padding: const EdgeInsets.all(8),
                  //         child: Text(to_ship[index][0]),
                  //       )

                  );
            }

            if (text == '5') {
              return ListView.builder(
                  itemCount: cancel.length,
                  itemBuilder: (ctx, index) => Card(
                        child: Column(
                          children: [
                            //   Text(to_ship.toString())
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text("Cancelled    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(cancel[index][4], cancel[index][11],
                                cancel[index][3], cancel[index][5]),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
                            // Row(
                            //   children: [
                            //     Spacer(),
                            //     Text(
                            //       "Total Payment: ",
                            //       //   "Amount Payable: ",
                            //     ),
                            //     Text(
                            //         "₱" +
                            //             (cancel[index][3] * cancel[index][5])
                            //                 .toString() +
                            //             "    ",
                            //         style: TextStyle(
                            //           color: Colors.green,
                            //         ))
                            //   ],
                            // ),
                            // Divider(
                            //   height: 2,
                            //   color: Colors.grey[400],
                            // ),

                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                    onPressed: null,
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ArrangeShipmentPage(
                                    //               toship: to_receive[index],
                                    //             )),
                                    //   );
                                    // },
                                    child: Text("Order Cancelled"))
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
                                        cancel[index][0]
                                            .toString()
                                            .substring(0, 13)
                                            .toUpperCase() +
                                        "    ",
                                    style: TextStyle(fontWeight: FontWeight.w600
                                        // color: Colors.green,
                                        ))
                              ],
                            ),
                          ],
                        ),
                      )

                  //   Container(
                  //         padding: const EdgeInsets.all(8),
                  //         child: Text(to_ship[index][0]),
                  //       )

                  );
            }

            if (text == '6') {
              return ListView.builder(
                  itemCount: refund.length,
                  itemBuilder: (ctx, index) => Card(
                        child: Column(
                          children: [
                            //   Text(to_ship.toString())
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text("Return/Refund    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(refund[index][4], refund[index][11],
                                refund[index][3], refund[index][5]),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
                            // Row(
                            //   children: [
                            //     Spacer(),
                            //     Text(
                            //       "Total Payment: ",
                            //       //   "Amount Payable: ",
                            //     ),
                            //     Text(
                            //         "₱" +
                            //             (cancel[index][3] * cancel[index][5])
                            //                 .toString() +
                            //             "    ",
                            //         style: TextStyle(
                            //           color: Colors.green,
                            //         ))
                            //   ],
                            // ),
                            // Divider(
                            //   height: 2,
                            //   color: Colors.grey[400],
                            // ),

                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                    onPressed: null,
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ArrangeShipmentPage(
                                    //               toship: to_receive[index],
                                    //             )),
                                    //   );
                                    // },
                                    child: Text("Order Refund"))
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
                                        refund[index][0]
                                            .toString()
                                            .substring(0, 13)
                                            .toUpperCase() +
                                        "    ",
                                    style: TextStyle(fontWeight: FontWeight.w600
                                        // color: Colors.green,
                                        ))
                              ],
                            ),
                          ],
                        ),
                      )

                  //   Container(
                  //         padding: const EdgeInsets.all(8),
                  //         child: Text(to_ship[index][0]),
                  //       )

                  );
            }

            return Center(
              child: Text('No Orders Yet',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xff5d5f60),
                  )),
            );
          }),
    );
  }

  Widget productCard(
      String imageUrl, String title, double price, int quantity) {
    return Container(
        height: 80,
        //margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(16.0),
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
                  image: NetworkImage(imageUrl),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400, fontSize: 15),
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
                            '₱${price}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,

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
                            "x" + quantity.toString() + "    ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              // color: themeChange.darkTheme
                              // ? Colors.brown.shade900
                              // : Color(0xff41a58d)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
