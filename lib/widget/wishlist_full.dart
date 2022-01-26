import './buildRatingStars.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/colors.dart';
import '../models/favs_attr.dart';
import '../models/product.dart';
import '../provider/favs_provider.dart';
import '../services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistFull extends StatefulWidget {
  final String productId;

  const WishlistFull({required this.productId});
  @override
  _WishlistFullState createState() => _WishlistFullState();
}

class _WishlistFullState extends State<WishlistFull> {
  @override
  Widget build(BuildContext context) {
    final favsAttr = Provider.of<FavsAttr>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 10.0, right: 30.0, bottom: 10.0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 2.0,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Image.network(favsAttr.imageUrl),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            favsAttr.title,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "PHP ${favsAttr.price}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xff41a58d),
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Row(children: [
                            const Text(
                              "4.5",
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Container(
                              //margin: EdgeInsets.only(top: size16!),

                              child: buildRatingStar(
                                  rating: 4.5, spacing: 4, size: 18),
                            )
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        positionedRemove(widget.productId),
      ],
    );
  }

  Widget positionedRemove(String productId) {
    final favsProvider = Provider.of<FavsProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();
    return Positioned(
      top: 20,
      right: 15,
      child: Container(
        height: 30,
        width: 30,
        child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(0.0),
            color: ColorsConsts.favColor,
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => {
                  globalMethods.showDialogg(
                      'Remove wish!',
                      'This product will be removed from your wishlist!',
                      () => favsProvider.removeItem(productId),
                      context),
                }),
      ),
    );
  }
}
