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
import 'package:luntian_shop_flutter_next/screens/search.dart';
import 'package:luntian_shop_flutter_next/utils/src/feather.dart';
import 'package:luntian_shop_flutter_next/widget/feeds_products.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ViewProductsPage extends StatefulWidget {
  const ViewProductsPage({Key? key, required String shop_id})
      : _shop_id = shop_id,
        super(key: key);

  final String _shop_id;

  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController _searchTextController = TextEditingController();

    final FocusNode _node = FocusNode();
    void initState() {
      super.initState();
      _searchTextController = TextEditingController();
      _searchTextController.addListener(() {
        setState(() {});
      });
    }

    @override
    void dispose() {
      super.dispose();
      _node.dispose();
      _searchTextController.dispose();
    }

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
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.all(2),
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchTextController,
          minLines: 1,
          focusNode: _node,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xff5d5f60),
            ),
            hintText: 'Search in Shop',
            filled: true,
            fillColor: Theme.of(context).cardColor,
            suffixIcon: IconButton(
              onPressed: _searchTextController.text.isEmpty
                  ? null
                  : () {
                      _searchTextController.clear();
                      _node.unfocus();
                    },
              icon: Icon(Feather.x,
                  color: _searchTextController.text.isNotEmpty
                      ? Colors.red
                      : Colors.grey),
            ),
          ),
          onChanged: (value) {
            _searchTextController.text.toLowerCase();
            setState(() {
              productsList = productsProvider.searchQuery(value);
            });
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return SortBottomSheet();
                    });
              },
              child: Container(
                margin: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(48),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  MdiIcons.swapVertical,
                  color: Color(0xff41a58d),
                  size: 22,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          )
          //   Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: InkWell(
          //       onTap: () {
          //         _scaffoldKey.currentState!.openEndDrawer();
          //       },
          //       child: Container(
          //         margin: EdgeInsets.only(left: 16),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.all(Radius.circular(16)),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withAlpha(48),
          //               blurRadius: 3,
          //               offset: Offset(0, 1),
          //             )
          //           ],
          //         ),
          //         padding: EdgeInsets.all(12),
          //         child: Icon(
          //           MdiIcons.tune,
          //           color: Color(0xff41a58d), //Color(0xff41a58d),
          //           size: 22,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
      //   appBar: AppBar(
      //     //automaticallyImplyLeading: false,
      //     backgroundColor: Colors.white,
      //     title: Text(
      //       'My Products',
      //       style: GoogleFonts.comfortaa(
      //           color: Colors.black, fontWeight: FontWeight.w700),
      //     ),
      //     leading: InkWell(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Container(
      //           margin: EdgeInsets.only(left: 5),
      //           padding: EdgeInsets.all(2),
      //           child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
      //     ),
      //   ),
      body: Column(children: [
        Container(
          color: Color(0xff41a58d),
          padding: EdgeInsets.symmetric(vertical: 8),
          //color: Colors.white,
          child: Container(
            //   color: Color(0xff41a58d),
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Center(
                  child: ClipOval(
                      child: Material(
                          color: Colors.blue,
                          child: Container(
                            height: 75,
                            width: 75,
                            child: Image.network(
                              _shopLogo,
                              fit: BoxFit.fitHeight,
                            ),
                          ))),
                ),
                const SizedBox(
                  width: 12,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _shopName,
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        //   Container(
                        //     child: Text(
                        //       // userInfos[0].email != '' ? userInfos[0].email : '',
                        //       _email,
                        //       //                  userInfos[0].email ?? '',
                        //       style: GoogleFonts.roboto(
                        //           color: Colors.grey[600], fontWeight: FontWeight.w400),
                        //     ),
                        //   ),
                        Column(
                          children: [
                            Text(
                              "Shop Rating: 4.5 / 5.0",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        TextButton(
                            child: Text("Chat Now".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(8)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side:
                                            BorderSide(color: Colors.white)))),
                            onPressed: () => null),
                      ],
                    ),
                    //Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Expanded(
          child: GridView.count(
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
        ),
      ]),
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
