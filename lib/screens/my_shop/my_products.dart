import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/consts/my_icons.dart';
import 'package:luntian_shop_flutter_next/models/product.dart';
import 'package:luntian_shop_flutter_next/provider/cart_provider.dart';
import 'package:luntian_shop_flutter_next/provider/favs_provider.dart';
import 'package:luntian_shop_flutter_next/provider/products.dart';
import 'package:luntian_shop_flutter_next/screens/cart.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/view_my_products.dart';
import 'package:luntian_shop_flutter_next/widget/feeds_products.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../wishlist.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key, required String shop_id})
      : _shop_id = shop_id,
        super(key: key);

  final String _shop_id;
  static const routeName = '/Feeds';

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _shopName = '';

  String _shopLogo = '';

  @override
  void initState() {
    // super.initState();
    // _scrollController = ScrollController();
    // _scrollController.addListener(() {
    //   setState(() {});
    // });
    getData();
  }

  void getData() async {
    User user = _auth.currentUser!;

    final DocumentSnapshot shopDoc = await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget._shop_id)
        .get();

    setState(() {
      _shopName = shopDoc.get('shop_name');
      _shopLogo = shopDoc.get('shop_logo');
    });

    print(_shopName);
    print(_shopLogo);
    //}

    // print("name $_name");
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as String;

    final productsProvider = Provider.of<Products>(context);
    List<Product> unfilterdProductsList = productsProvider.products;

    List<Product> productsList = [];

    // print("PROOOOOOOOOOO");
    // print(productsList.map((e) => print(e.brand)));
    // print("PROOOOOOOOOOO");
    if (popular == 'popular') {
      productsList = productsProvider.popularProducts;
    }

    unfilterdProductsList.forEach((e) =>
        e.shop_id == widget._shop_id ? productsList.add(e) : print("hehe"));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'My Products',
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
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        ),
        // actions: [
        //   Consumer<FavsProvider>(
        //     builder: (_, favs, ch) => Badge(
        //       badgeColor: Color(0xff41a58d),
        //       animationType: BadgeAnimationType.slide,
        //       toAnimate: true,
        //       position: BadgePosition.topEnd(top: 5, end: 7),
        //       badgeContent: Text(
        //         favs.getFavsItems.length.toString(),
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       child: IconButton(
        //         icon: Icon(
        //           MyAppIcons.wishlist,
        //           //color: ColorsConsts.favColor,
        //           color: Color(0xff5d5f60),
        //         ),
        //         onPressed: () {
        //           Navigator.of(context).pushNamed(WishlistScreen.routeName);
        //         },
        //       ),
        //     ),
        //   ),
        //   Consumer<CartProvider>(
        //     builder: (_, cart, ch) => Badge(
        //       badgeColor: Color(0xff41a58d),
        //       animationType: BadgeAnimationType.slide,
        //       toAnimate: true,
        //       position: BadgePosition.topEnd(top: 5, end: 7),
        //       badgeContent: Text(
        //         cart.getCartItems.length.toString(),
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       child: IconButton(
        //         icon: Icon(
        //           MyAppIcons.cart,
        //           color: Color(0xff5d5f60),
        //         ),
        //         onPressed: () {
        //           Navigator.of(context).pushNamed(CartScreen.routeName);
        //         },
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 250 / 420,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(productsList.length, (index) {
          return ChangeNotifierProvider.value(
            value: productsList[index],
            child: ViewMyProducts(),
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
