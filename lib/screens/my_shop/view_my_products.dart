import 'package:luntian_shop_flutter_next/inner_screens/product_details.dart';
import 'package:luntian_shop_flutter_next/models/product.dart';
import 'package:luntian_shop_flutter_next/provider/cart_provider.dart';
import 'package:luntian_shop_flutter_next/provider/products.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/edit_my_products.dart';
import 'package:luntian_shop_flutter_next/widget/buildRatingStars.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class ViewMyProducts extends StatefulWidget {
  @override
  _ViewMyProductsState createState() => _ViewMyProductsState();
}

class _ViewMyProductsState extends State<ViewMyProducts> {
  @override
  Widget build(BuildContext context) {
    final productsAttributes = Provider.of<Product>(context);
    final productsData = Provider.of<Products>(context, listen: false);
    final prodAttr = productsData.findById(productsAttributes.id);
    final cartProvider = Provider.of<CartProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: productsAttributes.id),
        child: Card(
          child: Container(
            //   width: 250,
            //   height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 1,
                //     blurRadius: 7,
                //     offset: Offset(0, 3), // changes position of shadow
                //   ),
              ],
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.19),
                            child: Image.network(
                              productsAttributes.imageUrl,
                              //   fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        //   Positioned(
                        //     // bottom: 0,
                        //     // right: 5,
                        //     // top: 5,
                        //     child: Badge(
                        //       alignment: Alignment.center,
                        //       toAnimate: true,
                        //       shape: BadgeShape.square,
                        //       badgeColor: Colors.pink,
                        //       borderRadius: BorderRadius.only(
                        //           bottomRight: Radius.circular(8)),
                        //       badgeContent: Text('New',
                        //           style: TextStyle(color: Colors.white)),
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(left: 5, bottom: 2, right: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: Text(
                          productsAttributes.title.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            'PHP ${productsAttributes.price}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff41a58d),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(children: [
                        // Text(
                        //   "4.5",
                        //   style: TextStyle(fontSize: 15),
                        // ),
                        // SizedBox(
                        //   width: 4,
                        // ),
                        //   Container(
                        //     //margin: EdgeInsets.only(top: size16!),

                        //     child:
                        //         buildRatingStar(rating: 4.5, spacing: 4, size: 18),
                        //   )
                      ]),
                      Center(
                        child: Container(
                          height: 50,
                          child: RaisedButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape:
                                RoundedRectangleBorder(side: BorderSide.none),
                            color: Color(0xff41a58d),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProductForm(
                                          product_id: productsAttributes.id,
                                          shop_id: productsAttributes.shop_id,
                                        )),
                              );
                            },
                            // cartProvider.getCartItems
                            //         .containsKey(productsAttributes.id)
                            //     ? () {}
                            //     : () {
                            //         cartProvider.addProductToCart(
                            //             productsAttributes.id,
                            //             prodAttr.price,
                            //             prodAttr.title,
                            //             prodAttr.imageUrl,
                            //             prodAttr.shop_id,
                            //             prodAttr.brand);
                            //       },
                            child: Text(
                              "Edit Product".toUpperCase(),
                              //   cartProvider.getCartItems.containsKey(
                              //     productsAttributes.id,
                              //   )
                              //       ? 'In cart'.toUpperCase()
                              //       : 'Add to Cart'.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'qty: ${productsAttributes.quantity}',
                      //         style: TextStyle(
                      //             fontSize: 12,
                      //             color: Colors.grey,
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //       Material(
                      //         color: Colors.transparent,
                      //         child: InkWell(
                      //             onTap: () async {
                      //               showDialog(
                      //                 context: context,
                      //                 builder: (BuildContext context) =>
                      //                     FeedDialog(
                      //                   productId: productsAttributes.id,
                      //                 ),
                      //               );
                      //             },
                      //             borderRadius: BorderRadius.circular(18.0),
                      //             child: Icon(
                      //               Icons.more_horiz,
                      //               color: Colors.grey,
                      //             )),
                      //       )
                      //     ],
                      //   ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
