import 'package:badges/badges.dart';
import 'package:luntian_shop_flutter_next/provider/user.dart';
import '/consts/my_icons.dart';
import '/provider/cart_provider.dart';
import '/provider/favs_provider.dart';
import '/screens/wishlist.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/colors.dart';
import '../inner_screens/brands_navigation_rail.dart';
import '../provider/products.dart';
import '../screens/feeds.dart';
import '../widget/backlayer.dart';
import '../widget/category.dart';
import '../widget/popular_products.dart';
import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _carouselImages = [
    'assets/images/beta.png',
    'assets/images/beta.png',
    'assets/images/beta.png',
    'assets/images/beta.png',
  ];

  List _brandImages = [
    'assets/images/vegetables.jpg',
    'assets/images/fruits.jpg',
    'assets/images/meat.jpg',
    'assets/images/dairyy.png',
  ];
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    productsData.fetchProducts();

    final userData = Provider.of<Users>(context);
    userData.fetchUser();

    final popularItems = productsData.popularProducts;
    print('popularItems length ${popularItems.length}');
    return Scaffold(
      body: BackdropScaffold(
        frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerHeight: MediaQuery.of(context).size.height * 0.25,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Home',
            style: GoogleFonts.comfortaa(
                color: Colors.black, fontWeight: FontWeight.w700),
          ),
          //   leading: BackdropToggleButton(
          //       icon: AnimatedIcons.home_menu, color: Color(0xff5d5f60)),
          flexibleSpace: Container(
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(colors: [
              //   ColorsConsts.starterColor,
              //   ColorsConsts.endColor
              // ])),
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
          //   actions: <Widget>[
          //     IconButton(
          //       iconSize: 15,
          //       padding: const EdgeInsets.all(10),
          //       icon: CircleAvatar(
          //         radius: 15,
          //         backgroundColor: Colors.white,
          //         child: CircleAvatar(
          //           radius: 13,
          //           backgroundImage: NetworkImage(
          //               'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
          //         ),
          //       ),
          //       onPressed: () {},
          //     )
          //   ],
        ),
        backLayer: BackLayerMenu(),
        frontLayer: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 190.0,
                width: double.infinity,
                child: Carousel(
                  boxFit: BoxFit.fill,
                  autoplay: true,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 5.0,
                  dotIncreasedColor: Color(0xff41a58d),
                  dotBgColor: Colors.black.withOpacity(0.2),
                  dotPosition: DotPosition.bottomCenter,
                  showIndicator: true,
                  indicatorBgPadding: 5.0,
                  images: [
                    ExactAssetImage(_carouselImages[0]),
                    ExactAssetImage(_carouselImages[1]),
                    ExactAssetImage(_carouselImages[2]),
                    ExactAssetImage(_carouselImages[3]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.grey[800]),
                ),
              ),
              Container(
                width: double.infinity,
                height: 120,
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, int index) {
                    return CategoryWidget(
                      index: index,
                    );
                  },
                ),
              ),
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       children: [
              //         Text(
              //           'Popular Shops',
              //           style: TextStyle(
              //               fontWeight: FontWeight.w600,
              //               fontSize: 18,
              //               color: Colors.grey[800]),
              //         ),
              //         Spacer(),
              //         FlatButton(
              //           onPressed: () {
              //             Navigator.of(context).pushNamed(
              //               BrandNavigationRailScreen.routeName,
              //               arguments: {
              //                 7,
              //               },
              //             );
              //           },
              //           child: Text(
              //             'View all...',
              //             style: TextStyle(
              //               fontWeight: FontWeight.w800,
              //               fontSize: 15,
              //               color: Color(0xff41a58d),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              //   Container(
              //     height: 210,
              //     width: MediaQuery.of(context).size.width * 0.95,
              //     child: Swiper(
              //       itemCount: _brandImages.length,
              //       autoplay: true,
              //       viewportFraction: 0.8,
              //       scale: 0.9,
              //       onTap: (index) {
              //         Navigator.of(context).pushNamed(
              //           BrandNavigationRailScreen.routeName,
              //           arguments: {
              //             index,
              //           },
              //         );
              //       },
              //       itemBuilder: (BuildContext ctx, int index) {
              //         return ClipRRect(
              //           borderRadius: BorderRadius.circular(10),
              //           child: Container(
              //             color: Colors.blueGrey,
              //             child: Image.asset(
              //               _brandImages[index],
              //               fit: BoxFit.fill,
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Products',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.grey[800]),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Feeds.routeName, arguments: 'popular');
                      },
                      child: Text(
                        'View all...',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Color(0xff41a58d)),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 285,
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularItems.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: popularItems[index],
                        child: PopularProducts(
                            // imageUrl: popularItems[index].imageUrl,
                            // title: popularItems[index].title,
                            // description: popularItems[index].description,
                            // price: popularItems[index].price,
                            ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
