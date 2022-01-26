import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/my_shop/sellers_registration.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import 'package:uuid/uuid.dart';

class SellerAddressScreen extends StatefulWidget {
  const SellerAddressScreen({Key? key}) : super(key: key);

  @override
  _SellerAddressScreenState createState() => _SellerAddressScreenState();
}

Widget divider() {
  return Container(
    height: 1,
    color: Colors.grey[300],
  );
}

class _SellerAddressScreenState extends State<SellerAddressScreen> {
  final addressRef = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullName = '';
  var phone = '';
  var address1 = '';
  var postal_code = '';
  var address2 = '';
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  var uuid = const Uuid();
  bool isLoading = false;

  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _addr1Ctrl = TextEditingController();
  TextEditingController _addr2Ctrl = TextEditingController();
  TextEditingController _postalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    User user = _auth.currentUser!;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('shipping_address')
        .doc(user.uid)
        .get();

    try {
      setState(() {
        fullName = userDoc.get('name');
        address1 = userDoc.get('address1');
        address2 = userDoc.get('address2');
        phone = userDoc.get('phone');
        postal_code = userDoc.get('postal_code');
      });

      _nameCtrl.text = fullName;
      _addr1Ctrl.text = address1;
      _addr2Ctrl.text = address2;
      _phoneCtrl.text = phone;
      _postalCtrl.text = postal_code;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      final User user = _auth.currentUser!;
      final _uid = user.uid;
      final custom_id = uuid.v4();

      try {
        await FirebaseFirestore.instance
            .collection('shipping_address')
            .doc(_uid)
            .set({
          'id': custom_id,
          'user_id': _uid,
          'name': fullName,
          'address1': address1,
          'address2': address2,
          'phone': phone,
          'postal_code': postal_code,
        });

        showSnackBar(context, "Address has been successfully updated.",
            Colors.green, 3000);

        // addressRef.doc(_uid).update({
        //   "shop_id": shop_id,
        //   "shop_name": _shopTitle,
        // });
        // Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SellerRegistration()),
        );
      } catch (error) {
        // _globalMethods.authErrorHandle(error.toString(), context);
        // print('error occured ${error.toString()}');
      } finally {
        // setState(() {
        //   _isLoading = false;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Address',
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
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Contact",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: TextFormField(
                      controller: _nameCtrl,
                      enabled: !isEditing,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: ValueKey('Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          // labelText: 'Full Name',
                          hintText: 'Full Name'),
                      onSaved: (value) {
                        fullName = value!;
                      },
                    ),
                  ),
                  divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: TextFormField(
                      controller: _phoneCtrl,
                      enabled: !isEditing,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: ValueKey('Phone'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: 'Phone Number'),
                      onSaved: (value) {
                        phone = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Address",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: TextFormField(
                      controller: _addr1Ctrl,
                      enabled: !isEditing,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: ValueKey('Address1'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the following address details';
                        }
                        return null;
                      },
                      // maxLines: 2,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          // labelText: 'Phone Number',
                          hintText: 'Region, Province, City, Barangay'),
                      onSaved: (value) {
                        address1 = value!;
                      },
                    ),
                  ),
                  divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: TextFormField(
                      controller: _postalCtrl,
                      enabled: !isEditing,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: ValueKey('postal_code'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "City's postal code is required";
                        }
                        if (value.length < 3 || value.length > 5) {
                          return "Please enter a proper postal code";
                        }
                        return null;
                      },
                      // maxLines: 2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          // labelText: 'Phone Number',
                          hintText: 'Postal Code'),
                      onSaved: (value) {
                        postal_code = value!;
                      },
                    ),
                  ),
                  divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: TextFormField(
                      controller: _addr2Ctrl,
                      enabled: !isEditing,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: ValueKey('address2'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the following street name and house no.';
                        }
                        return null;
                      },
                      // maxLines: 2,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          // labelText: 'Phone Number',
                          hintText: 'Street Name, House No.'),
                      onSaved: (value) {
                        address2 = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                        onPressed: _trySubmit, //_submitForm,
                        child: Text("UPDATE ADDRESS",
                            style: GoogleFonts.comfortaa(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          //shape: StadiumBorder(),
                          primary: Color(0xff41a58d),
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
