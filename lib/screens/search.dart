import 'package:badges/badges.dart';
import '../consts/my_icons.dart';
import '../provider/cart_provider.dart';
import '../screens/cart.dart';
import '../screens/wishlist.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../consts/colors.dart';
import '../models/product.dart';
import '../provider/products.dart';
import '../widget/feeds_products.dart';
import '../widget/searchby_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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

  List<Product> _searchList = [];
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productsList = productsData.products;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      endDrawer: _EndDrawer(
        scaffoldKey: _scaffoldKey,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
            hintText: 'Search',
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
              _searchList = productsData.searchQuery(value);
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _searchTextController.text.isNotEmpty && _searchList.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Icon(
                        Feather.search,
                        size: 60,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'No results found',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ],
                  )
                : GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 240 / 420,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: List.generate(
                        _searchTextController.text.isEmpty
                            ? productsList.length
                            : _searchList.length, (index) {
                      return ChangeNotifierProvider.value(
                        value: _searchTextController.text.isEmpty
                            ? productsList[index]
                            : _searchList[index],
                        child: FeedProducts(),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    //ThemeData themeData = Theme.of(context);
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Padding(
          padding: EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radioValue = 0;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (dynamic value) {
                              setState(() {
                                _radioValue = 0;
                              });
                            },
                            groupValue: _radioValue,
                            value: 0,
                            visualDensity: VisualDensity.compact,
                            //activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Price - ",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 600)
                          ),
                          Text(
                            "High to Low",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 500)
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radioValue = 1;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (dynamic value) {
                              setState(() {
                                _radioValue = 1;
                              });
                            },
                            groupValue: _radioValue,
                            value: 1,
                            visualDensity: VisualDensity.compact,
                            //activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Price - ",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 600)
                          ),
                          Text(
                            "Low to High",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 500)
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radioValue = 2;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (dynamic value) {
                              setState(() {
                                _radioValue = 2;
                              });
                            },
                            groupValue: _radioValue,
                            value: 2,
                            visualDensity: VisualDensity.compact,
                            //activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Name - ",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 600)
                          ),
                          Text(
                            "A to Z",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 500)
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radioValue = 3;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (dynamic value) {
                              setState(() {
                                _radioValue = 3;
                              });
                            },
                            groupValue: _radioValue,
                            value: 3,
                            visualDensity: VisualDensity.compact,
                            //activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Name - ",
                            // style: AppTheme.getTextStyle(
                            //     themeData.textTheme.subtitle2,
                            //     fontWeight: 600)
                          ),
                          Text(
                            "Z to A",
                            // style: AppTheme.getTextStyle(
                            //     themeData.textTheme.subtitle2,
                            //     fontWeight: 500)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EndDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _EndDrawer({required this.scaffoldKey}); //: super(key: key);

  @override
  __EndDrawerState createState() => __EndDrawerState();
}

class __EndDrawerState extends State<_EndDrawer> {
  @override
  Widget build(BuildContext context) {
    //  themeData = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 24),
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "FILTER",
                  //   style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                  //       fontWeight: 700, color: themeData.colorScheme.primary),
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Rating",
                  //   style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  //       fontWeight: 600, letterSpacing: 0),
                ),
              ),
              //   Container(
              //       padding: EdgeInsets.only(
              //           left: 16,
              //           right: 16,
              //           top: 8),
              //       child: _RatingDrawerWidget()),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Price Range",
                  //   style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  //       fontWeight: 600, letterSpacing: 0),
                ),
              ),
              //   Container(
              //     padding: EdgeInsets.only(
              //         left: 16, right: 16, top: 0),
              //     child: _PriceRangeDrawerWidget(),
              //   ),
              Container(
                margin: EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        // color: themeData.colorScheme.primary.withAlpha(24),
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "APPLY",
                      //   style: AppTheme.getTextStyle(
                      //       themeData.textTheme.bodyText2,
                      //       fontWeight: 600,
                      //       color: themeData.colorScheme.onPrimary,
                      //       letterSpacing: 0.3),
                    ),
                    // style: ButtonStyle(
                    //     padding: MaterialStateProperty.all(Spacing.xy(16, 0))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
