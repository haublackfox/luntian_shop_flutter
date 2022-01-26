import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget buildRatingStar(
    {double rating = 5,
    Color activeColor = const Color(0xfffdd835),
    Color inactiveColor = Colors.black,
    double size = 16,
    double spacing = 0,
    bool inactiveStarFilled = false,
    bool showInactive = true}) {
  int ratingCount = rating.floor();
  bool isHalf = (ratingCount != rating);
  List<Widget> _stars = [];
  for (int i = 0; i < 5; i++) {
    if (i < ratingCount) {
      _stars.add(Icon(
        MdiIcons.star,
        color: activeColor,
        size: size,
      ));

      _stars.add(SizedBox(width: spacing));
    } else {
      if (isHalf) {
        isHalf = false;
        _stars.add(Icon(
          MdiIcons.starHalfFull,
          color: activeColor,
          size: size,
        ));
      } else if (showInactive) {
        _stars.add(Icon(
          inactiveStarFilled ? MdiIcons.star : MdiIcons.starOutline,
          color: inactiveColor,
          size: size,
        ));
      }
      _stars.add(SizedBox(width: spacing));
    }
  }
  return Row(mainAxisSize: MainAxisSize.min, children: _stars);
}
