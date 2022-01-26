import 'package:badges/badges.dart';
import 'package:luntian_shop_flutter_next/screens/bottom_bar.dart';
import '../consts/my_icons.dart';
import '../provider/cart_provider.dart';
import '../screens/cart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/colors.dart';
import '../provider/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Wishlist',
          style: GoogleFonts.comfortaa(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: Color(0xff41a58d),
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                cart.getCartItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  MyAppIcons.cart,
                  color: Color(0xff5d5f60),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //margin: EdgeInsets.only(top: 80),
              width: MediaQuery.of(context).size.height * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/new_empty-wishlist.png'),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              'Your Wishlist is Empty',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Add favorites to save for later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeChange.darkTheme
                      ? Theme.of(context).disabledColor
                      : ColorsConsts.subTitle,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.07,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomBarScreen(screenIndex: 0,)),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Color(0xff41a58d)),
                ),
                color: Color(0xff41a58d),
                child: Text(
                  'Continue Shopping',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
