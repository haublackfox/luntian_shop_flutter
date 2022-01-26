import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:luntian_shop_flutter_next/provider/user.dart';
import 'package:luntian_shop_flutter_next/screens/orders/order.dart';

import '../consts/theme_data.dart';
import '../inner_screens/product_details.dart';
import '../provider/dark_theme_provider.dart';
import '../provider/products.dart';
import '../screens/wishlist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'inner_screens/brands_navigation_rail.dart';
import 'inner_screens/categories_feeds.dart';
import 'screens/my_shop/upload_product_form.dart';
import 'provider/cart_provider.dart';
import 'provider/favs_provider.dart';
import 'screens/auth/login.dart';
import 'screens/auth/sign_up.dart';
import 'screens/bottom_bar.dart';
import 'screens/cart.dart';
import 'screens/feeds.dart';
import 'screens/landing_page.dart';
import 'screens/main_screen.dart';
import 'screens/user_state.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//   await FirebaseAppCheck.instance
//       .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    print('called ,mmmmm');
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvider;
          }),
          ChangeNotifierProvider(
            create: (_) => Products(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => FavsProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => Users(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          home: AnimatedSplashScreen(
            duration: 3000,
            splash: 'assets/images/luntian_splash.png',
            nextScreen: UserState(), //LoginScreenAuth(), //NewApp(),
            splashTransition: SplashTransition.fadeTransition,
            //pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.green,
            splashIconSize: 300,
          ),
          routes: {
            // '/': (ctx) => LandingPage(),
            BrandNavigationRailScreen.routeName: (ctx) =>
                BrandNavigationRailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            Feeds.routeName: (ctx) => Feeds(),
            WishlistScreen.routeName: (ctx) => WishlistScreen(),
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            BottomBarScreen.routeName: (ctx) => BottomBarScreen(
                  screenIndex: 0,
                ),
            UploadProductForm.routeName: (ctx) => UploadProductForm(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
          },
        ));
    //});
  }
}
