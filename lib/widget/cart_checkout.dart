import './buildRatingStars.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/colors.dart';
import '../inner_screens/product_details.dart';
import '../models/cart_attr.dart';
import '../provider/cart_provider.dart';
import '../provider/dark_theme_provider.dart';
import '../services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class CartCheckout extends StatefulWidget {
  final String productId;

  const CartCheckout({required this.productId});

  // final String id;
  // final String productId;
  // final double price;
  // final int quatity;
  // final String title;
  // final String imageUrl;

  // const CartCheckout(
  //     {@required this.id,
  //     @required this.productId,
  //     @required this.price,
  //     @required this.quatity,
  //     @required this.title,
  //     @required this.imageUrl});
  @override
  _CartCheckoutState createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final cartAttr = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartAttr.price * cartAttr.quantity;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: widget.productId),
      child: Container(
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
                  image: NetworkImage(cartAttr.imageUrl),
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
                            cartAttr.title,
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
                            '₱${cartAttr.price}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              // color: themeChange.darkTheme
                              //     ? Colors.brown.shade900
                              //     : Color(0xff41a58d)
                            ),
                          ),
                        ),
                        Spacer(),
                        FittedBox(
                          child: Text(
                            "x" + cartAttr.quantity.toString() + "    ",
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
        ),
      ),
    );
  }
}
