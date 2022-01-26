import 'dart:ui';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:luntian_shop_flutter_next/screens/chats/chatting_page.dart';
import 'package:luntian_shop_flutter_next/view_products_page.dart';
import 'package:luntian_shop_flutter_next/widget/buildRatingStars.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../consts/colors.dart';
import '../consts/my_icons.dart';
import '../provider/cart_provider.dart';
import '../provider/dark_theme_provider.dart';
import '../provider/favs_provider.dart';
import '../provider/products.dart';
import '../screens/cart.dart';
import '../screens/wishlist.dart';
import '../widget/feeds_products.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  GlobalKey previewContainer = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final productsData = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);
    print('productId $productId');
    final prodAttr = productsData.findById(productId);
    final productsList = productsData.products;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Image.network(
              prodAttr.imageUrl,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //   Material(
                      //     color: Colors.transparent,
                      //     child: InkWell(
                      //       splashColor: Colors.purple.shade200,
                      //       onTap: () {},
                      //       borderRadius: BorderRadius.circular(30),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Icon(
                      //           Icons.save,
                      //           size: 23,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   DELETED
                      //     Material(
                      //       color: Colors.transparent,
                      //       child: InkWell(
                      //         splashColor: Colors.purple.shade200,
                      //         onTap: () {},
                      //         borderRadius: BorderRadius.circular(30),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Icon(
                      //             Icons.share,
                      //             size: 23,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  //padding: const EdgeInsets.all(16.0),
                  //  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //   decoration: BoxDecoration(
                              //       border: Border(
                              //           bottom: BorderSide(
                              //     color: Colors.amber,
                              //     width: 1.0, // Underline thickness
                              //   ))),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                prodAttr.title.toUpperCase(),
                                maxLines: 2,
                                style: TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // Padding(
                            //   // padding: const EdgeInsets.all(16.0),
                            //   child:

                            Text(
                              prodAttr.description,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                color: themeState.darkTheme
                                    ? Theme.of(context).disabledColor
                                    : ColorsConsts.subTitle,
                              ),
                            ),
                            //),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'PHP ${prodAttr.price}',
                              style: TextStyle(
                                  color: themeState.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : Color(0xff41a58d),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24.0),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(top: size16!),
                                  child: buildRatingStar(
                                      rating: 4.5, spacing: 4, size: 24),
                                ),
                                Spacer(),
                                InkWell(
                                  splashColor: ColorsConsts.favColor,
                                  onTap: () {
                                    favsProvider.addAndRemoveFromFav(
                                        productId,
                                        prodAttr.price,
                                        prodAttr.title,
                                        prodAttr.imageUrl);
                                  },
                                  child: Center(
                                    child: Icon(
                                        favsProvider.getFavsItems
                                                .containsKey(productId)
                                            ? Icons.favorite
                                            : MyAppIcons.wishlist,
                                        color: favsProvider.getFavsItems
                                                .containsKey(productId)
                                            ? Colors.red
                                            : Colors.grey[600]),
                                  ),
                                ),
                                // InkWell(
                                //   splashColor: Colors.purple.shade200,
                                //   onTap: () {},
                                //   borderRadius: BorderRadius.circular(30),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Icon(
                                //       MdiIcons.shareOutline,
                                //       size: 30,
                                //       color: Colors.grey,
                                //     ),
                                //   ),
                                // ),
                              ],
                            )
                          ],
                        ),
                      ),

                      //const SizedBox(height: 3.0),
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //     child: Divider(
                      //       thickness: 1,
                      //       color: Colors.grey,
                      //       height: 1,
                      //     ),
                      //   ),
                      const SizedBox(height: 12.0),
                      //   Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: Text(
                      //       prodAttr.description,
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w400,
                      //         fontSize: 16.0,
                      //         color: themeState.darkTheme
                      //             ? Theme.of(context).disabledColor
                      //             : ColorsConsts.subTitle,
                      //       ),
                      //     ),
                      //   ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                          height: 1,
                        ),
                      ),
                      _details(
                          themeState.darkTheme, 'Availability: ', 'In Stock'),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProductsPage(
                                        shop_id: prodAttr.shop_id,
                                      )),
                            );
                          },
                          child: _details(
                              themeState.darkTheme, 'Shop: ', prodAttr.brand)),
                      //   _details(themeState.darkTheme, 'Quantity: ',
                      //       '${prodAttr.quantity}'),
                      _details(themeState.darkTheme, 'Category: ',
                          prodAttr.productCategoryName),
                      _details(themeState.darkTheme, 'Popularity: ',
                          prodAttr.isPopular ? 'Barely known' : 'Popular'),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                        height: 1,
                      ),

                      // const SizedBox(height: 15.0),
                      //DELETED
                      //   Container(
                      //     color: Colors.grey[100],
                      //     width: double.infinity,
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         const SizedBox(height: 10.0),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'No reviews yet',
                      //             style: TextStyle(
                      //                 color: Theme.of(context).textSelectionColor,
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 21.0),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(2.0),
                      //           child: Text(
                      //             'Be the first review!',
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w400,
                      //               fontSize: 20.0,
                      //               color: themeState.darkTheme
                      //                   ? Theme.of(context).disabledColor
                      //                   : ColorsConsts.subTitle,
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 70,
                      //         ),
                      //         Divider(
                      //           thickness: 1,
                      //           color: Colors.grey,
                      //           height: 1,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //DELETED
                    ],
                  ),
                ),
                // const SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  //color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    'Suggested products:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  height: 340,
                  child: ListView.builder(
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                          value: productsList[index], child: FeedProducts());
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 5),
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.black)),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                // title: Text(
                //   "DETAIL",
                //   style:
                //       TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                // ),
                actions: <Widget>[
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
                          color: Color(0xff5d5f60),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(WishlistScreen.routeName);
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
                ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Color(0xffeef8f0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChattingPage(
                                    receiverId: prodAttr.shop_id,
                                    receiverName: prodAttr.brand,
                                  )),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            FontAwesome.commenting_o,
                            color: Color(0xff565c84),
                            size: 19,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Chat Now'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 9, color: Color(0xff565c84)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Color(0xffeef8f0),
                      onPressed:
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartScreen()));
                                }
                              : () {
                                  cartProvider.addProductToCart(
                                      productId,
                                      prodAttr.price,
                                      prodAttr.title,
                                      prodAttr.imageUrl,
                                      prodAttr.shop_id,
                                      prodAttr.brand);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartScreen()));
                                },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.payment,
                            color: Color(0xff565c84),
                            size: 19,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Buy now'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 9, color: Color(0xff565c84)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Color(0xff41a58d),
                      onPressed:
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {}
                              : () {
                                  cartProvider.addProductToCart(
                                      productId,
                                      prodAttr.price,
                                      prodAttr.title,
                                      prodAttr.imageUrl,
                                      prodAttr.shop_id,
                                      prodAttr.brand);
                                },
                      child: Text(
                        cartProvider.getCartItems.containsKey(productId)
                            ? 'In cart'
                            : 'Add to Cart'.toUpperCase(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]))
        ],
      ),
    );
  }

  Widget _details(bool themeState, String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Color(0xff5d5f60),
                //color: Theme.of(context).textSelectionColor,
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
          ),
          Text(
            info,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              color: themeState
                  ? Theme.of(context).disabledColor
                  : Color(0xff41a58d),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:ui';
// import '../consts/colors.dart';
// import '../consts/my_icons.dart';
// import '../provider/cart_provider.dart';
// import '../provider/dark_theme_provider.dart';
// import '../provider/favs_provider.dart';
// import '../provider/products.dart';
// import '../screens/cart.dart';
// import '../screens/wishlist.dart';
// import '../widget/feeds_products.dart';
// import 'package:badges/badges.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProductDetails extends StatefulWidget {
//   static const routeName = '/ProductDetails';

//   @override
//   _ProductDetailsState createState() => _ProductDetailsState();
// }

// class _ProductDetailsState extends State<ProductDetails> {
//   GlobalKey previewContainer = new GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     final themeState = Provider.of<DarkThemeProvider>(context);
//     final productsData = Provider.of<Products>(context, listen: false);
//     final productId = ModalRoute.of(context)!.settings.arguments as String;
//     final cartProvider = Provider.of<CartProvider>(context);

//     final favsProvider = Provider.of<FavsProvider>(context);
//     print('productId $productId');
//     final prodAttr = productsData.findById(productId);
//     final productsList = productsData.products;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Container(
//             foregroundDecoration: BoxDecoration(color: Colors.black12),
//             height: MediaQuery.of(context).size.height * 0.45,
//             width: double.infinity,
//             child: Image.network(
//               prodAttr.imageUrl,
//             ),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 const SizedBox(height: 250),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           splashColor: Colors.purple.shade200,
//                           onTap: () {},
//                           borderRadius: BorderRadius.circular(30),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.save,
//                               size: 23,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           splashColor: Colors.purple.shade200,
//                           onTap: () {},
//                           borderRadius: BorderRadius.circular(30),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.share,
//                               size: 23,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   //padding: const EdgeInsets.all(16.0),
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.9,
//                               child: Text(
//                                 prodAttr.title,
//                                 maxLines: 2,
//                                 style: TextStyle(
//                                   // color: Theme.of(context).textSelectionColor,
//                                   fontSize: 28.0,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Text(
//                               'US \$ ${prodAttr.price}',
//                               style: TextStyle(
//                                   color: themeState.darkTheme
//                                       ? Theme.of(context).disabledColor
//                                       : ColorsConsts.subTitle,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 21.0),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 3.0),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Divider(
//                           thickness: 1,
//                           color: Colors.grey,
//                           height: 1,
//                         ),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           prodAttr.description,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 21.0,
//                             color: themeState.darkTheme
//                                 ? Theme.of(context).disabledColor
//                                 : ColorsConsts.subTitle,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Divider(
//                           thickness: 1,
//                           color: Colors.grey,
//                           height: 1,
//                         ),
//                       ),
//                       _details(themeState.darkTheme, 'Brand: ', prodAttr.brand),
//                       _details(themeState.darkTheme, 'Quantity: ',
//                           '${prodAttr.quantity}'),
//                       _details(themeState.darkTheme, 'Category: ',
//                           prodAttr.productCategoryName),
//                       _details(themeState.darkTheme, 'Popularity: ',
//                           prodAttr.isPopular ? 'Popular' : 'Barely known'),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Divider(
//                         thickness: 1,
//                         color: Colors.grey,
//                         height: 1,
//                       ),

//                       // const SizedBox(height: 15.0),
//                       Container(
//                         color: Theme.of(context).backgroundColor,
//                         width: double.infinity,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const SizedBox(height: 10.0),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'No reviews yet',
//                                 style: TextStyle(
//                                     color: Theme.of(context).textSelectionColor,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 21.0),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(2.0),
//                               child: Text(
//                                 'Be the first review!',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 20.0,
//                                   color: themeState.darkTheme
//                                       ? Theme.of(context).disabledColor
//                                       : ColorsConsts.subTitle,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 70,
//                             ),
//                             Divider(
//                               thickness: 1,
//                               color: Colors.grey,
//                               height: 1,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // const SizedBox(height: 15.0),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(8.0),
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   child: Text(
//                     'Suggested products:',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(bottom: 30),
//                   width: double.infinity,
//                   height: 340,
//                   child: ListView.builder(
//                     itemCount: 7,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (BuildContext ctx, int index) {
//                       return ChangeNotifierProvider.value(
//                           value: productsList[index], child: FeedProducts());
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: AppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 centerTitle: true,
//                 title: Text(
//                   "DETAIL",
//                   style:
//                       TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
//                 ),
//                 actions: <Widget>[
//                   Consumer<FavsProvider>(
//                     builder: (_, favs, ch) => Badge(
//                       badgeColor: ColorsConsts.cartBadgeColor,
//                       animationType: BadgeAnimationType.slide,
//                       toAnimate: true,
//                       position: BadgePosition.topEnd(top: 5, end: 7),
//                       badgeContent: Text(
//                         favs.getFavsItems.length.toString(),
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           MyAppIcons.wishlist,
//                           color: ColorsConsts.favColor,
//                         ),
//                         onPressed: () {
//                           Navigator.of(context)
//                               .pushNamed(WishlistScreen.routeName);
//                         },
//                       ),
//                     ),
//                   ),
//                   Consumer<CartProvider>(
//                     builder: (_, cart, ch) => Badge(
//                       badgeColor: ColorsConsts.cartBadgeColor,
//                       animationType: BadgeAnimationType.slide,
//                       toAnimate: true,
//                       position: BadgePosition.topEnd(top: 5, end: 7),
//                       badgeContent: Text(
//                         cart.getCartItems.length.toString(),
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           MyAppIcons.cart,
//                           color: ColorsConsts.cartColor,
//                         ),
//                         onPressed: () {
//                           Navigator.of(context).pushNamed(CartScreen.routeName);
//                         },
//                       ),
//                     ),
//                   ),
//                 ]),
//           ),
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Row(children: [
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     height: 50,
//                     child: RaisedButton(
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       shape: RoundedRectangleBorder(side: BorderSide.none),
//                       color: Colors.redAccent.shade400,
//                       onPressed:
//                           cartProvider.getCartItems.containsKey(productId)
//                               ? () {}
//                               : () {
//                                   cartProvider.addProductToCart(
//                                       productId,
//                                       prodAttr.price,
//                                       prodAttr.title,
//                                       prodAttr.imageUrl);
//                                 },
//                       child: Text(
//                         cartProvider.getCartItems.containsKey(productId)
//                             ? 'In cart'
//                             : 'Add to Cart'.toUpperCase(),
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: 50,
//                     child: RaisedButton(
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       shape: RoundedRectangleBorder(side: BorderSide.none),
//                       color: Theme.of(context).backgroundColor,
//                       onPressed: () {},
//                       child: Row(
//                         children: [
//                           Text(
//                             'Buy now'.toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 color: Theme.of(context).textSelectionColor),
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Icon(
//                             Icons.payment,
//                             color: Colors.green.shade700,
//                             size: 19,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     color: themeState.darkTheme
//                         ? Theme.of(context).disabledColor
//                         : ColorsConsts.subTitle,
//                     height: 50,
//                     child: InkWell(
//                       splashColor: ColorsConsts.favColor,
//                       onTap: () {
//                         favsProvider.addAndRemoveFromFav(productId,
//                             prodAttr.price, prodAttr.title, prodAttr.imageUrl);
//                       },
//                       child: Center(
//                         child: Icon(
//                           favsProvider.getFavsItems.containsKey(productId)
//                               ? Icons.favorite
//                               : MyAppIcons.wishlist,
//                           color:
//                               favsProvider.getFavsItems.containsKey(productId)
//                                   ? Colors.red
//                                   : ColorsConsts.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ]))
//         ],
//       ),
//     );
//   }

//   Widget _details(bool themeState, String title, String info) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
//       child: Row(
//         //  mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//                 color: Theme.of(context).textSelectionColor,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 21.0),
//           ),
//           Text(
//             info,
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontSize: 20.0,
//               color: themeState
//                   ? Theme.of(context).disabledColor
//                   : ColorsConsts.subTitle,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
