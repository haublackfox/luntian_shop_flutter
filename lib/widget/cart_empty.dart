import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/bottom_bar.dart';

import '../consts/colors.dart';
import '../provider/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Cart',
          style: GoogleFonts.comfortaa(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Container(
        //       margin: const EdgeInsets.only(left: 5),
        //       padding: const EdgeInsets.all(2),
        //       child: const Icon(Icons.arrow_back_ios_rounded,
        //           color: Colors.black)),
        // ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //margin: EdgeInsets.only(top: 8),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/new_emptycart.png'),
              ),
            ),
          ),
          Text(
            'Your Cart is Empty',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'Add items you want to shop.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: themeChange.darkTheme
                    ? Theme.of(context).disabledColor
                    : ColorsConsts.subTitle,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 60,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.07,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBarScreen(
                            screenIndex: 0,
                          )),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Color(0xff41a58d)),
              ),
              color: const Color(0xff41a58d),
              child: Text(
                'Start Shopping',
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
    );
  }
}
