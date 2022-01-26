// import 'package:UIKit/screens/shopping/ShoppingRatingScreen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final int _numPages = 3;
  int _currentPage = 0;

  int _selectedMethod = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.black.withAlpha(30),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                'Payment',
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
            ),
            //backgroundColor: themeData.backgroundColor,
            body: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                // Container(
                //   height: 240,
                //   decoration: BoxDecoration(
                //       //color: themeData.backgroundColor,
                //       shape: BoxShape.rectangle,
                //       borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(16),
                //           topRight: Radius.circular(16))),
                //   child:
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: _buildPageIndicator(),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "METHODS",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 600,
                            //       color: themeData.colorScheme.onBackground
                            //           .withAlpha(220))
                          )),
                      Divider(
                        //color: themeData.dividerColor,
                        thickness: 0.3,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Image(
                                image: AssetImage(
                                    './assets/images/gcash_logo.png'),
                                width: 30,
                                height: 30),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "GCash",
                                  // style: AppTheme.getTextStyle(
                                  //     themeData.textTheme.subtitle1,
                                  //     fontWeight: 600)
                                ),
                              ),
                            ),
                            Icon(
                              MdiIcons.check,
                              color: Colors.blue,
                              //color: themeData.colorScheme.onBackground,
                            )
                          ],
                        ),
                      ),
                      Divider(
                        //color: themeData.dividerColor,
                        thickness: 0.3,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Image(
                                image:
                                    AssetImage('./assets/images/paymaya.png'),
                                width: 30,
                                height: 30),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "Paymaya",
                                  // style: AppTheme.getTextStyle(
                                  //     themeData.textTheme.subtitle1,
                                  //     fontWeight: 600)
                                ),
                              ),
                            ),
                            // Icon(
                            //   MdiIcons.check,
                            //   //color: themeData.colorScheme.onBackground,
                            // )
                          ],
                        ),
                      ),
                      Divider(
                        //color: themeData.dividerColor,
                        thickness: 0.3,
                      ),
                      Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(top: 16),
                          child: Text(
                            "OTHER",
                            //   style: AppTheme.getTextStyle(
                            //       themeData.textTheme.subtitle2,
                            //       fontWeight: 600,
                            //       color: themeData.colorScheme.onBackground
                            //           .withAlpha(220))
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       _selectedMethod = 0;
                            //     });
                            //   },
                            //   child: OptionWidget(
                            //     iconData: MdiIcons.history,
                            //     text: "On EMI",
                            //     isSelected: _selectedMethod == 0,
                            //   ),
                            // ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       _selectedMethod = 1;
                            //     });
                            //   },
                            //   child: OptionWidget(
                            //     iconData: MdiIcons.bankOutline,
                            //     text: "Bank",
                            //     isSelected: _selectedMethod == 1,
                            //   ),
                            // ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedMethod = 2;
                                });
                              },
                              child: OptionWidget(
                                iconData: MdiIcons.cashMarker,
                                text: "COD",
                                isSelected: _selectedMethod == 2,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(28),
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff41a58d))),
                        onPressed: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               ShoppingRatingScreen())

                          //               );
                        },
                        child: Text(
                          "PAY WITH SECURE",
                          // style: AppTheme.getTextStyle(
                          //     themeData.textTheme.bodyText2,
                          //     fontWeight: 600,
                          //     color: themeData.colorScheme.onPrimary,
                          //     letterSpacing: 0.3)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

class OptionWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool isSelected;

  OptionWidget(
      {required this.iconData, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? themeData.colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(24),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        children: <Widget>[
          Icon(
            iconData,
            color: isSelected ? Colors.white : Colors.grey[700],
            size: 30,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            child: Text(
              text,
              style: TextStyle(
                //themeData.textTheme.caption,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          )
        ],
      ),
    );
  }
}
