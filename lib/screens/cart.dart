import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/checkout/checkout_page.dart';

import '../consts/colors.dart';
import '../consts/my_icons.dart';
import '../provider/cart_provider.dart';
import '../services/global_method.dart';
import '../widget/cart_empty.dart';
import '../widget/cart_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? const Scaffold(body: CartEmpty())
        : Scaffold(
            backgroundColor: Colors.white,
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                'Cart (${cartProvider.getCartItems.length})',
                style: GoogleFonts.comfortaa(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ),
              //   leading: InkWell(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Container(
              //         margin: EdgeInsets.only(left: 5),
              //         padding: EdgeInsets.all(2),
              //         child: Icon(Icons.arrow_back_ios_rounded,
              //             color: Colors.black)),
              //   ),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Clear cart!',
                        'Your cart will be cleared!',
                        () => cartProvider.clearCart(),
                        context);
                    // cartProvider.clearCart();
                  },
                  icon: Icon(
                    MyAppIcons.trash,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            body: Container(
              //color: Color(0xfff3f4fd),
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItems.values.toList()[index],
                      child: Card(
                        child: CartFull(
                          productId:
                              cartProvider.getCartItems.keys.toList()[index],
                          // id:  cartProvider.getCartItems.values.toList()[index].id,
                          // productId: cartProvider.getCartItems.keys.toList()[index],
                          // price: cartProvider.getCartItems.values.toList()[index].price,
                          // title: cartProvider.getCartItems.values.toList()[index].title,
                          // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                          // quatity: cartProvider.getCartItems.values.toList()[index].quantity,
                        ),
                      ),
                    );
                  }),
            ),
          );
  }

  Widget checkoutSection(BuildContext ctx, double subtotal) {
    return Container(
        margin: EdgeInsets.all(8.0),
        // decoration: BoxDecoration(
        //   border: Border(
        //     top: BorderSide(color: Colors.grey, width: 0.5),
        //   ),
        // ),
        //     child: Padding(
        //   padding: EdgeInsets.all(8.0),
        child: Row(
          /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   'Total:',
            //   style: GoogleFonts.openSans(
            //       color: Colors.grey[600],
            //       fontSize: 18,
            //       fontWeight: FontWeight.w600),
            // ),
            Text(
              'Total:',
              style: GoogleFonts.openSans(
                  //color: Colors.grey[800],
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              ' ₱${subtotal.toStringAsFixed(2)}',
              //textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  color: Color(0xff41a58d),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Container(
                //padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0xff41a58d),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                            builder: (context) => CheckoutScreen()),
                      );
                    },
                    splashColor: Theme.of(ctx).splashColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Check Out',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // ),
        ));
  }
}
