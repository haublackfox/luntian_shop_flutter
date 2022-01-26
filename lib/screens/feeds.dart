import 'package:google_fonts/google_fonts.dart';

import '../consts/colors.dart';
import '../consts/my_icons.dart';
import '../models/product.dart';
import '../provider/cart_provider.dart';
import '../provider/favs_provider.dart';
import '../provider/products.dart';
import '../screens/wishlist.dart';
import '../widget/feeds_products.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class Feeds extends StatelessWidget {
  static const routeName = '/Feeds';
  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as String;

    final productsProvider = Provider.of<Products>(context);
    List<Product> productsList = productsProvider.products;

    print("PROOOOOOOOOOO");
    print(productsList.map((e) => print(e.brand)));
    print("PROOOOOOOOOOO");
    if (popular == 'popular') {
      productsList = productsProvider.popularProducts;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: popular == 'popular' ? true : false,
        backgroundColor: Colors.white,
        title: Text(
          popular == 'popular' ? "Popular Products" : 'Feed',
          style: GoogleFonts.comfortaa(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          Consumer<FavsProvider>(
            builder: (_, favs, ch) => Badge(
              badgeColor: Color(0xff41a58d),
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                favs.getFavsItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  MyAppIcons.wishlist,
                  //color: ColorsConsts.favColor,
                  color: Color(0xff5d5f60),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(WishlistScreen.routeName);
                },
              ),
            ),
          ),
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
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 250 / 420, //300 / 420
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(productsList.length, (index) {
          return ChangeNotifierProvider.value(
            value: productsList[index],
            child: FeedProducts(),
          );
        }),
      ),
//         StaggeredGridView.countBuilder(
//           padding: ,
//   crossAxisCount: 6,
//   itemCount: 8,
//   itemBuilder: (BuildContext context, int index) =>FeedProducts(),
//   staggeredTileBuilder: (int index) =>
//       new StaggeredTile.count(3, index.isEven ? 4 : 5),
//   mainAxisSpacing: 8.0,
//   crossAxisSpacing: 6.0,
// ),
    );
  }
}
