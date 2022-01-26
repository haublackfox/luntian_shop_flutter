import 'package:google_fonts/google_fonts.dart';

import '../consts/my_icons.dart';
import '../provider/favs_provider.dart';
import '../services/global_method.dart';
import '../widget/cart_empty.dart';

import '../widget/wishlist_empty.dart';
import '../widget/wishlist_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final favsProvider = Provider.of<FavsProvider>(context);
    return favsProvider.getFavsItems.isEmpty
        ? Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Wishlist (${favsProvider.getFavsItems.length})',
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
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.black)),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Clear wishlist!',
                        'Your wishlist will be cleared!',
                        () => favsProvider.clearFavs(),
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
            body: ListView.builder(
              itemCount: favsProvider.getFavsItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ChangeNotifierProvider.value(
                    value: favsProvider.getFavsItems.values.toList()[index],
                    child: WishlistFull(
                      productId: favsProvider.getFavsItems.keys.toList()[index],
                    ));
              },
            ),
          );
  }
}


// appBar: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: Colors.white,
//               elevation: 0,
// //backgroundColor: Theme.of(context).backgroundColor,
//               title: Text(
//                 'Cart (${cartProvider.getCartItems.length})',
//                 style: GoogleFonts.comfortaa(
//                     color: Colors.black, fontWeight: FontWeight.w700),
//               ),
//               //   leading: InkWell(
//               //     onTap: () {
//               //       Navigator.pop(context);
//               //     },
//               //     child: Container(
//               //         margin: EdgeInsets.only(left: 5),
//               //         padding: EdgeInsets.all(2),
//               //         child: Icon(Icons.arrow_back_ios_rounded,
//               //             color: Colors.black)),
//               //   ),
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     globalMethods.showDialogg(
//                         'Clear cart!',
//                         'Your cart will be cleared!',
//                         () => cartProvider.clearCart(),
//                         context);
//                     // cartProvider.clearCart();
//                   },
//                   icon: Icon(
//                     MyAppIcons.trash,
//                     color: Colors.green,
//                   ),
//                 )
//               ],
//             ),