import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:luntian_shop_flutter_next/models/cart_attr.dart';
import 'package:luntian_shop_flutter_next/provider/cart_provider.dart';
import 'package:luntian_shop_flutter_next/screens/account/my_orders.dart';
import 'package:luntian_shop_flutter_next/screens/address/address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/checkout/payment_page.dart';
import 'package:luntian_shop_flutter_next/widget/cart_checkout.dart';
import 'package:luntian_shop_flutter_next/widget/cart_full.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// import './ShoppingPaymentScreen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var fullName = '';
  var phone = '';
  var address1 = '';
  var postal_code = '';
  var address2 = '';
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  var uuid = const Uuid();
  bool isLoading = false;
  int _selectedMethod = 0;
  DateTime now = DateTime.now();
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

    // setState(() {
    //   fullName = userDoc.get('name');
    //   address1 = userDoc.get('address1');
    //   address2 = userDoc.get('address2');
    //   phone = userDoc.get('phone');
    //   postal_code = userDoc.get('postal_code');
    // });

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

    // _nameCtrl.text = fullName;
    // _addr1Ctrl.text = address1;
    // _addr2Ctrl.text = address2;
    // _phoneCtrl.text = phone;
    // _postalCtrl.text = postal_code;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //  bottomSheet: //checkoutSection(context, cartProvider.totalAmount),
          //   Container(
          //       margin: EdgeInsets.all(8.0),
          //       // decoration: BoxDecoration(
          //       //   border: Border(
          //       //     top: BorderSide(color: Colors.grey, width: 0.5),
          //       //   ),
          //       // ),
          //       //     child: Padding(
          //       //   padding: EdgeInsets.all(8.0),
          //       child: Row(
          //         /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Total Payment:',
          //             style: GoogleFonts.openSans(
          //                 //color: Colors.grey[800],
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w600),
          //           ),
          //           Text(
          //             ' ₱${cartProvider.totalAmount.toStringAsFixed(2)}',
          //             //textAlign: TextAlign.center,
          //             style: GoogleFonts.roboto(
          //                 color: Color(0xff41a58d),
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           Spacer(),
          //           Expanded(
          //             flex: 2,
          //             child: Container(
          //               //padding: EdgeInsets.symmetric(horizontal: 8),
          //               decoration: BoxDecoration(
          //                 color: Color(0xff41a58d),
          //                 borderRadius: BorderRadius.circular(30),
          //               ),
          //               child: Material(
          //                 color: Colors.transparent,
          //                 child: InkWell(
          //                   borderRadius: BorderRadius.circular(30),
          //                   onTap: () => {
          //                     showDialog<String>(
          //                         context: context,
          //                         builder: (BuildContext context) =>
          //                             AlertDialog(
          //                               title: const Text('Place Order'),
          //                               content: const Text(
          //                                   'Do want to place your order?'),
          //                               actions: <Widget>[
          //                                 TextButton(
          //                                   onPressed: () => Navigator.of(
          //                                           context)
          //                                       .pop(), //Navigator.pop(context, 'Cancel'),

          //                                   child: const Text(
          //                                     'No',
          //                                     style: TextStyle(
          //                                         color: Colors.red),
          //                                   ),
          //                                 ),
          //                                 TextButton(
          //                                   onPressed: () async {
          //                                     //   Navigator.push(
          //                                     //     ctx,
          //                                     //     MaterialPageRoute(
          //                                     //         builder: (context) => CheckoutScreen()),
          //                                     //   );

          //                                     // onTap:
          //                                     // () async {
          //                                     // double amountInCents = subtotal * 1000;
          //                                     // int intengerAmount = (amountInCents / 10).ceil();
          //                                     // await payWithCard(amount: intengerAmount);
          //                                     // if (response.success == true) {
          //                                     User? user = _auth.currentUser;
          //                                     final _uid = user!.uid;
          //                                     cartProvider.getCartItems
          //                                         .forEach((key,
          //                                             orderValue) async {
          //                                       final orderId = uuid.v4();
          //                                       try {
          //                                         // print("WAWAWAWAWAWAWAWAWAWWA");
          //                                         // print(orderValue.id);
          //                                         // print(orderValue.title);
          //                                         // print(orderValue.price);
          //                                         // print(orderValue.id);
          //                                         // print(orderValue.id);
          //                                         // print(Timestamp.now());
          //                                         // print(now);
          //                                         // print("WAWAWAWAWAWAWAWAWAWWA");

          //                                         await FirebaseFirestore
          //                                             .instance
          //                                             .collection('order')
          //                                             .doc(orderId)
          //                                             .set({
          //                                           'id': orderId,
          //                                           'user_id': _uid,
          //                                           'product_id':
          //                                               orderValue.id,
          //                                           'shop_id':
          //                                               orderValue.shop_id,
          //                                           'name': orderValue.title,
          //                                           'price': orderValue.price,
          //                                           'imageUrl':
          //                                               orderValue.imageUrl,
          //                                           'quantity':
          //                                               orderValue.quantity,
          //                                           'brand': orderValue.brand,
          //                                           'status': 'To Ship',
          //                                           'order_time': now,
          //                                           'ship_time': '',
          //                                           'completed_time': '',
          //                                           'rated': '0'
          //                                         });
          //                                         showSnackBar(
          //                                             context,
          //                                             "Order placed sucessfully",
          //                                             Colors.green,
          //                                             3000);
          //                                         Navigator.push(
          //                                           context,
          //                                           MaterialPageRoute(
          //                                               builder: (context) =>
          //                                                   MyOrderScreen(
          //                                                     page_no: 0,
          //                                                   )),
          //                                         );
          //                                       } catch (err) {
          //                                         print('error occured $err');
          //                                       }
          //                                     });
          //                                   },
          //                                   child: const Text('Yes'),
          //                                 ),
          //                               ],
          //                             ))
          //                   },
          //                   splashColor: Theme.of(context).splashColor,
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text(
          //                       'Place Order',
          //                       textAlign: TextAlign.center,
          //                       style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 18,
          //                           fontWeight: FontWeight.w600),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //         // ),
          //       )),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              'Checkout',
              style: GoogleFonts.comfortaa(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.black)),
            ),
          ),
          body: //Center(
              //child:
              ListView(
            shrinkWrap: true,
            children: <Widget>[
              Card(
                elevation: 0.5,
                child: ListTile(
                  trailing: InkWell(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressScreen()),
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
                            Text("Delivery Address"),
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
              Container(
                height: 300,
                color: Color(0xfff3f4fd),
                // margin: EdgeInsets.only(bottom: 60),
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartProvider.getCartItems.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                          value:
                              cartProvider.getCartItems.values.toList()[index],
                          child: Column(children: [
                            CartCheckout(
                              productId: cartProvider.getCartItems.keys
                                  .toList()[index],
                              // id:  cartProvider.getCartItems.values.toList()[index].id,
                              // productId: cartProvider.getCartItems.keys.toList()[index],
                              // price: cartProvider.getCartItems.values.toList()[index].price,
                              // title: cartProvider.getCartItems.values.toList()[index].title,
                              // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                              // quatity: cartProvider.getCartItems.values.toList()[index].quantity,
                            ),
                            Container(height: 1, color: Colors.grey[100])
                          ]),
                        );
                      }),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Text(
                    "PAYMENT METHOD",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      //color: Colors.grey[800]
                    ),
                  )),
              Container(
                // height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMethod = 0;
                        });
                      },
                      child: OptionWidget(
                        iconData: MdiIcons.cashMarker,
                        text: "COD",
                        isSelected: _selectedMethod == 0,
                        imageUrl: '',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMethod = 1;
                        });
                      },
                      child: OptionWidget(
                        iconData: MdiIcons.bankOutline,
                        text: "GCash",
                        isSelected: _selectedMethod == 1,
                        imageUrl: './assets/images/gcash_logo.png',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMethod = 2;
                        });
                      },
                      child: OptionWidget(
                        iconData: MdiIcons.cashMarker,
                        text: "Paymaya",
                        isSelected: _selectedMethod == 2,
                        imageUrl: './assets/images/paymaya.png',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //)
        ));
  }

//   Widget checkoutSection(BuildContext ctx, double subtotal) {
//     return Container(
//         margin: EdgeInsets.all(8.0),
//         // decoration: BoxDecoration(
//         //   border: Border(
//         //     top: BorderSide(color: Colors.grey, width: 0.5),
//         //   ),
//         // ),
//         //     child: Padding(
//         //   padding: EdgeInsets.all(8.0),
//         child: Row(
//           /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Total Payment:',
//               style: GoogleFonts.openSans(
//                   //color: Colors.grey[800],
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600),
//             ),
//             Text(
//               ' ₱${subtotal.toStringAsFixed(2)}',
//               //textAlign: TextAlign.center,
//               style: GoogleFonts.roboto(
//                   color: Color(0xff41a58d),
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500),
//             ),
//             Spacer(),
//             Expanded(
//               flex: 2,
//               child: Container(
//                 //padding: EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Color(0xff41a58d),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(30),
//                     onTap: () {
//                       //   Navigator.push(
//                       //     ctx,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => CheckoutScreen()),
//                       //   );

//                       onTap:
//                       () async {
//                         // double amountInCents = subtotal * 1000;
//                         // int intengerAmount = (amountInCents / 10).ceil();
//                         // await payWithCard(amount: intengerAmount);
//                         // if (response.success == true) {
//                         User user = _auth.currentUser;
//                         final _uid = user.uid;
//                         cartProvider.getCartItems
//                             .forEach((key, orderValue) async {
//                           final orderId = uuid.v4();
//                           try {
//                             await FirebaseFirestore.instance
//                                 .collection('order')
//                                 .doc(orderId)
//                                 .set({
//                               'orderId': orderId,
//                               'userId': _uid,
//                               'productId': orderValue.productId,
//                               'title': orderValue.title,
//                               'price': orderValue.price * orderValue.quantity,
//                               'imageUrl': orderValue.imageUrl,
//                               'quantity': orderValue.quantity,
//                               'orderDate': Timestamp.now(),
//                             });
//                           } catch (err) {
//                             print('error occured $err');
//                           }
//                         });
//                         // } else {
//                         //   //   globalMethods.authErrorHandle(
//                         //   //       'Please enter your true information', context);
//                         // }
//                       };
//                     },
//                     splashColor: Theme.of(ctx).splashColor,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Place Order',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//           // ),
//         ));
//   }
}

class OptionWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool isSelected;
  final String imageUrl;

  OptionWidget(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.imageUrl,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xff41a58d) : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(24),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        children: <Widget>[
          imageUrl != ''
              ? Image(
                  image: AssetImage(imageUrl),
                  width: 30,
                  height: 24,
                  color: isSelected ? Colors.white : null)
              : Icon(iconData,
                  color: isSelected ? Colors.white : Color(0xff41a58d)),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: TextStyle(
                  // themeData.textTheme.caption,
                  //fontWeight: 600,
                  color: isSelected ? Colors.white : Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

// AlertDialog imageSaved(context, String message, int pageIndex) {
//   return AlertDialog(
//     titlePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//     title: Text(message),
//     actions: [
//       ElevatedButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       HomeScreen(user: widget.user, screenIndex: pageIndex)));
//         },
//         child: Text('Ok'),
//       ),
//     ],
//   );
// }
