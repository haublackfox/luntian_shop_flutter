import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

import 'package:flutter/cupertino.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Users with ChangeNotifier {
  List<UserData> _users = [];

  Future<void> fetchUser() async {
    final User user = _auth.currentUser!;
    final _uid = user.uid;
    print('Fetch method is called');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .get()
        .then((DocumentSnapshot UserSnapshot) {
      //   UserSnapshot.data() as Map {
      // print('element.get(productBrand), ${element.get('productBrand')}');
      print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
      print(UserSnapshot.get('id'));

      print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
      _users.insert(
        0,
        UserData(
          id: UserSnapshot.get('id'),
          name: UserSnapshot.get('name'),
          email: UserSnapshot.get('email'),
          password: UserSnapshot.get('password'),
          phone: UserSnapshot.get('phone'),
          address: UserSnapshot.get('address'),
          image_url: UserSnapshot.get('image_url'),
          shop_name: UserSnapshot.get('shop_name'),
          shop_id: UserSnapshot.get('shop_id'),
        ),
      );
    });

//        GivitUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
//         var snapshotData = snapshot.data() as Map;
//         return GivitUser(
//            uid: uid,
//            email: snapshotData['Email'],
//            fullName: snapshotData['Full Name'],
//            phoneNumber: snapshotData['Phone Number'],
//         );
//    }
//     });

//   Future<void> fetchUser() async {
//     print('Fetch method is called');
//     await FirebaseFirestore.instance
//         .collection('users')
//         .get()
//         .then((QuerySnapshot UserSnapshot) {
//       _users = [];
//       UserSnapshot.docs.forEach((element) {
//         // print('element.get(productBrand), ${element.get('productBrand')}');
//         _users.insert(
//           0,
//           UserData(
//             id: element.get('id'),
//             name: element.get('name'),
//             email: element.get('email'),
//             password: element.get('password'),
//             phone: element.get('phone'),
//             address: element.get('address'),
//             image_url: element.get('image_url'),
//             shop_name: element.get('shop_name'),
//             shop_id: element.get('shop_id'),
//           ),
//         );
//       });
    // });

    print("AAAAAAAAAAAAA" + _users.toString());
  }

  //}

  List<UserData> get users {
    return [..._users];
  }
}
