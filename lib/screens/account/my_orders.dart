import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/rate_product.dart';
import 'package:luntian_shop_flutter_next/screens/account/order_detail.dart';
import 'package:luntian_shop_flutter_next/screens/bottom_bar.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen(
      {Key? key, required int page_no}) //required String shop_id,
      : _page_no = page_no, //_shop_id = shop_id,
        super(key: key);

//   final String _shop_id;
  final int _page_no;
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    getData();

    super.initState();
  }

  void getData() async {
    setState(() {
      _selectedPageIndex = widget._page_no;
    });

    // final DocumentSnapshot userDoc =
    //     await FirebaseFirestore.instance.collection('users').get();

    print("LLLLLLLLLLLLLLLLLLLLL");
  }

  void _tryCancel(String order_id) async {
    try {} catch (e) {}

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

    print("AHKJFHDKJFHDSKJFHSDKF");

    FirebaseFirestore.instance.collection('order').doc(order_id).update({
      "status": "Cancel",
    });

    showSnackBar(context, "Order cancellation sucessful", Colors.green, 3000);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyOrderScreen(
                page_no: 3,
              )),
    );
  }

  void _tryReceive(String order_id) async {
    try {} catch (e) {}

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

    print("AHKJFHDKJFHDSKJFHSDKF");

    FirebaseFirestore.instance.collection('order').doc(order_id).update({
      "status": "Completed",
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyOrderScreen(
                page_no: 2,
              )),
    );
    showSnackBar(context, "Order cancellation sucessful", Colors.green, 3000);
  }

  void _tryComplete(String order_id) async {
    try {} catch (e) {
      print("AHKJFHDKJFHDSKJFHSDKF");

      FirebaseFirestore.instance.collection('order').doc(order_id).update({
        "status": "Completed",
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyOrderScreen(
                  page_no: 2,
                )),
      );
      showSnackBar(context, "Order cancellation sucessful", Colors.green, 3000);
    }
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
              'My Orders',
              style: GoogleFonts.comfortaa(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBarScreen(
                            screenIndex: 4,
                          )),
                );
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
                            child: Text("To Receive",
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

            documents.forEach((doc) {
              if (doc["user_id"] == user.uid && doc["status"] == "To Ship") {
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
                  doc["brand"],
                  doc["product_id"],
                ]);
              }
              if (doc["user_id"] == user.uid && doc["status"] == "To Receive") {
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
                  doc["brand"],
                  doc["product_id"],
                ]);
              }
              if (doc["user_id"] == user.uid && doc["status"] == "Completed") {
                print("WAAAAAAAAAAAAAAAA");
                print(doc["id"]);
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
                  doc["brand"],
                  doc["product_id"],
                ]);
              }
              if (doc["user_id"] == user.uid && doc["status"] == "Cancel") {
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
                  doc["brand"],
                  doc["product_id"],
                ]);
              }

              if (doc["user_id"] == user.uid && doc["status"] == "Refund") {
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
                  doc["brand"],
                  doc["product_id"],
                ]);
              }
              //   print("ZZZZZZZZZZ");
              //   print(doc);
              print("ZZZZZZZZZZ");
              print(to_ship);
              print("ZZZZZZZZZZ");
            });

            print(documents);

            print("SDDDDDDDDDDDDDDDDD");
            print(cancel);
            print("SDDDDDDDDDDDDDDDDD");
            // return Card(
            //   child: Container(
            //       height: 200,
            //       child: Column(
            //         children: [Text("data"), Row()],
            //       )),
            // );
            if (text == '2') {
              return ListView.builder(
                  itemCount: to_ship.length,
                  itemBuilder: (ctx, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails()),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              getShopNameText(
                                to_ship[index][2],
                              ),
                              //   Text(to_ship
                              // .toString())
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                            bottomRight: Radius.circular(4.0),
                                            bottomLeft: Radius.circular(4.0)),
                                        color: Color(0xff41a58d)),
                                    //  color: Color(0xff41a58d),
                                    child: Text(
                                      'Luntian Shop',
                                      style: GoogleFonts.comfortaa(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(to_ship[index][12],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400)),
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
                                to_ship[index][5],
                              ),
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
                                    "Amount Payable: ",
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
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff41a58d)),
                                      ),
                                      onPressed: () => {
                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          'Cancel Order'),
                                                      content: const Text(
                                                          'Do want to cancel your order?, this action cannot be undone'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(), //Navigator.pop(context, 'Cancel'),

                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              _tryCancel(
                                                                  to_ship[index]
                                                                      [0]),
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    ))
                                          },
                                      child: Text("Cancel Order"))
                                ],
                              ),
                              Divider(
                                height: 2,
                                color: Colors.grey[400],
                              ),
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
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600
                                              // color: Colors.green,
                                              ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )

                  //   Container(
                  //         padding: const EdgeInsets.all(8),
                  //         child: Text(to_ship[index][0]),
                  //       )

                  );
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
                            getShopNameText(
                              to_receive[index][2],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)),
                                      color: Color(0xff41a58d)),
                                  //  color: Color(0xff41a58d),
                                  child: Text(
                                    'Luntian Shop',
                                    style: GoogleFonts.comfortaa(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(to_receive[index][12],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                Text("To Receive    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(
                              to_receive[index][4],
                              to_receive[index][11],
                              to_receive[index][3],
                              to_receive[index][5],
                            ),
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
                                  "Amount Payable: ",
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
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff41a58d)),
                                    ),
                                    onPressed: () => {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Confirm Order Received'),
                                                    content: const Text(
                                                        'Confirm that the order was received, order status will be completed'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator
                                                                .of(context)
                                                            .pop(), //Navigator.pop(context, 'Cancel'),

                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            _tryReceive(
                                                                to_receive[
                                                                    index][0]),
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  ))
                                        },
                                    child: Text("Order Received"))
                              ],
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
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
                            getShopNameText(
                              completed[index][2],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)),
                                      color: Color(0xff41a58d)),
                                  //  color: Color(0xff41a58d),
                                  child: Text(
                                    'Luntian Shop',
                                    style: GoogleFonts.comfortaa(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(completed[index][12],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
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
                              completed[index][5],
                            ),
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
                                  "Amount Paid: ",
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
                                completed[index][10] == "1"
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xff41a58d)),
                                        ),
                                        onPressed: null,
                                        child: Text("Rated"))
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xff41a58d)),
                                        ),
                                        onPressed: () => {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RateProduct(
                                                          productId:
                                                              completed[index]
                                                                  [13],
                                                          orderId:
                                                              completed[index]
                                                                  [0],
                                                        )),
                                              )
                                            },
                                        child: Text("Rate Now"))
                              ],
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
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
                            getShopNameText(
                              cancel[index][2],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)),
                                      color: Color(0xff41a58d)),
                                  //  color: Color(0xff41a58d),
                                  child: Text(
                                    'Luntian Shop',
                                    style: GoogleFonts.comfortaa(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(to_ship[index][12],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                Text("Cancelled    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(
                              cancel[index][4],
                              cancel[index][11],
                              cancel[index][3],
                              cancel[index][5],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // Divider(
                            //   height: 2,
                            //   color: Colors.grey[400],
                            // ),
                            // Row(
                            //   children: [
                            //     Spacer(),
                            //     Text(
                            //       "Amount Payable: ",
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
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)),
                                      color: Color(0xff41a58d)),
                                  //  color: Color(0xff41a58d),
                                  child: Text(
                                    'Luntian Shop',
                                    style: GoogleFonts.comfortaa(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(cancel[index][12],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff41a58d)),
                                    ),
                                    onPressed: null,
                                    child: Text("Order Cancelled"))
                              ],
                            ),

                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
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
                            getShopNameText(
                              refund[index][2],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)),
                                      color: Color(0xff41a58d)),
                                  //  color: Color(0xff41a58d),
                                  child: Text(
                                    'Luntian Shop',
                                    style: GoogleFonts.comfortaa(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(refund[index][12],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                Text("Return/Refund    ",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                            productCard(
                              refund[index][4],
                              refund[index][11],
                              refund[index][3],
                              refund[index][5],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // Divider(
                            //   height: 2,
                            //   color: Colors.grey[400],
                            // ),
                            // Row(
                            //   children: [
                            //     Spacer(),
                            //     Text(
                            //       "Amount Payable: ",
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
                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)),
                                      color: Color(0xff41a58d)),
                                  //  color: Color(0xff41a58d),
                                  child: Text(
                                    'Luntian Shop',
                                    style: GoogleFonts.comfortaa(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(refund[index][12],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff41a58d)),
                                    ),
                                    onPressed: null,
                                    child: Text("Order Refund"))
                              ],
                            ),

                            Divider(
                              height: 2,
                              color: Colors.grey[400],
                            ),
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

  Widget getShopNameText(
    String shop_id,
  ) {
    var name = '';
    var Name = getShopName(shop_id);
    Name.then((val) {
      print(val);
      name = val;
      return Text(val);
    });

    print("AHKJFHDKJFHDSKFHSDK");

    print("NAME");
    print(name);
    print("NAME");
    return Container();
  }

  Future<String> getShopName(
    String shop_id,
  ) async {
    print("HAAAAAAAAAAAAAAAAAAAAAAAAAA");
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('shops')
        .doc(
          shop_id,
        )
        .get();
    print("YYYYYYYYYYYYYYYYYYYYYYYYY");
    print(userDoc["shop_name"]);
    print("YYYYYYYYYYYYYYYYYYYYYYYYY");
    return userDoc["shop_name"];
    // if (userDoc == null) {
    //   return;
    // } else {
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
}
