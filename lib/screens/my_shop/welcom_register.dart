import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/address/address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/address/seller_address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/address/shipping_address_screen.dart';
import 'package:luntian_shop_flutter_next/screens/bottom_bar.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';
import 'package:luntian_shop_flutter_next/widget/verify_screen.dart';

import '../../consts/colors.dart';
import '../../services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SellerRegistration extends StatefulWidget {
  static const routeName = '/SellerRegistration';

  @override
  _SellerRegistrationState createState() => _SellerRegistrationState();
}

class _SellerRegistrationState extends State<SellerRegistration> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? selectedImage;

  final _formKey = GlobalKey<FormState>();

  var _shopTitle = '';
  var _shopEmail = '';
  var _shopPhone = '';
  var _shopAddress = '';
  var _shopPostalCode = '';
//   var _productQuantity = '';

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  String _categoryValue = '';
  String _brandValue = '';
  GlobalMethods _globalMethods = GlobalMethods();
  DateTime now = DateTime.now();

  File? _pickedImage;
  bool _isLoading = false;
  String url = '';
  var uuid = const Uuid();
  var fullName = '';
  var phone = '';
  var address1 = '';
  var postal_code = '';
  var address2 = '';
  bool isLoading = false;
  bool hasAddress = true;

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

    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
    print(userDoc);
    print(userDoc != null);
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");

    try {
      setState(() {
        fullName = userDoc.get('name');
        address1 = userDoc.get('address1');
        address2 = userDoc.get('address2');
        phone = userDoc.get('phone');
        postal_code = userDoc.get('postal_code');
      });
    } catch (e) {
      print("ERROR");
      setState(() {
        hasAddress = false;
      });
    }

    // print("CCCCCCCCCCCC");
    // print(fullName);
    // print("CCCCCCCCCCCC");

    // _nameCtrl.text = fullName;
    // _addr1Ctrl.text = address1;
    // _addr2Ctrl.text = address2;
    // _phoneCtrl.text = phone;
    // _postalCtrl.text = postal_code;
    isLoading = false;
  }

  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    final isValid = _formKey.currentState!.validate() && hasAddress;
    FocusScope.of(context).unfocus();

    // if (isValid) {
    //   _formKey.currentState?.save();
    //   print(_shopTitle);
    //   //   print(_productPrice);
    //   //   print(_productCategory);
    //   //   print(_productBrand);
    //   //   print(_productDescription);
    //   //   print(_productQuantity);
    //   // Use those values to send our request ...
    // }
    if (isValid) {
      _formKey.currentState?.save();
      final User user = _auth.currentUser!;
      final _uid = user.uid;
      final shop_id = uuid.v4();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('shopImages')
              .child(_shopTitle + now.toString() + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('shops')
              .doc(shop_id)
              .set({
            'id': shop_id,
            'user_id': _uid,
            'shop_name': _shopTitle,
            'shop_logo': url,
            'cover_photo': '',
            'createdAt': Timestamp.now(),
            'isVerified': false
          });

          usersRef.doc(_uid).update({
            "shop_id": shop_id,
            "shop_name": _shopTitle,
          });

          showSnackBar(
              context,
              "Shop has been successfully registered, you can now acces 'My Shop'.",
              Colors.green,
              3000);

          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BottomBarScreen(
          //               screenIndex: 4,
          //             )),
          //   );

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyScreen(
                    //screenIndex: 4,
                    )),
          );
          //   Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

//   void _pickImageCamera() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(
//       source: ImageSource.camera,
//       imageQuality: 40,
//     );
//     final pickedImageFile = File(pickedImage!.path);
//     setState(() {
//       _pickedImage = pickedImageFile;
//     });
//     // widget.imagePickFn(pickedImageFile);
//   }

//   void _pickImageGallery() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

//     setState(() {
//       _pickedImage = pickedImageFile!;
//     });
//     // widget.imagePickFn(pickedImageFile);
//   }
  getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    _pickedImage = File(pickedImage!.path);
    // imgSize = ImageSizeGetter.getSize(FileInput(selectedImage!));

    // var fileSize = await selectedImage!.length();

    // imgFileSize = getFileSize(fileSize);
    // imgResolution = getImageResolution(imgSize.toString());
    setState(() {});
  }

  getImageFromCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    _pickedImage = File(pickedImage!.path);

    //imgSize = ImageSizeGetter.getSize(FileInput(selectedImage!));

    //var fileSize = await selectedImage!.length();

    //imgFileSize = getFileSize(fileSize);
    //imgResolution = getImageResolution(imgSize.toString());
    setState(() {});
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Choose image by:"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  await getImageFromCamera();
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                child: Text("Image from Gallery",
                    style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  await getImageFromGallery();
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

//   void _removeImage() {
//     setState(() {
//       _pickedImage = null;
//     });
//   }

//   Widget shopRegisterScreen() {}

  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser!;
    final _uid = user.uid;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      //   appBar: AppBar(
      //     backgroundColor: Color(0xff41a58d),
      //     title: Text("Seller Registration"),
      //     centerTitle: true,
      //   ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Welcome To Luntian!',
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
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConsts.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: _trySubmit,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()))
                      : Container(
                          //width: 100,
                          child: ElevatedButton(
                              onPressed: _trySubmit,
                              //onPressed: () {}, //_submitForm,
                              child: Row(children: [
                                Text("Register Shop",
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              style: ElevatedButton.styleFrom(
                                //shape: StadiumBorder(),
                                primary: Color(0xff41a58d),
                              )),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text(_uid),
            // Text(user.email!),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                this._pickedImage == null
                    ? Container(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: ClipOval(
                              child: Material(
                                  color: Colors.blue,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 26),
                                    child: Text(user.email![0], //"1",
                                        style: const TextStyle(
                                            fontSize: 32, color: Colors.white)),
                                  ))),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //   topLeft: const Radius.circular(40.0),
                            // ),
                            //color: Theme.of(context).backgroundColor,
                            ),
                        child: Center(
                          child: ClipOval(
                            child: Image.file(
                              this._pickedImage!,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            InkWell(
              onTap: () {
                selectImage(context);
              }, //getImag
              child: Text("Edit Shop Image",
                  style: TextStyle(
                      color: Color(0xff41a58d),
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              //   child: Card(
              //     //margin: const EdgeInsets.all(15),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* Image picker here ***********************************/

                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          key: ValueKey('ShopName'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a shop name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Shop Name',
                              hintText: 'Enter Shop Name'),
                          onSaved: (value) {
                            _shopTitle = value!;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          key: ValueKey('PhoneNumber'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone Number is required';
                            }
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: 'Phone Number',
                              hintText: 'Enter Phone Number'
                              //  prefixIcon: Icon(Icons.mail),
                              // suffixIcon: Text(
                              //   '\n \n \$',
                              //   textAlign: TextAlign.start,
                              // ),
                              ),
                          //obscureText: true,
                          onSaved: (value) {
                            _shopPhone = value!;
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      height: 1,
                    ),

                    // Container(
                    //   color: Colors.white,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 8),
                    //     child: TextFormField(
                    //       key: ValueKey('Address'),
                    //       validator: (value) {
                    //         if (value!.isEmpty) {
                    //           return 'Address is required';
                    //         }
                    //         return null;
                    //       },
                    //       keyboardType: TextInputType.emailAddress,
                    //       decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           focusedBorder: InputBorder.none,
                    //           enabledBorder: InputBorder.none,
                    //           errorBorder: InputBorder.none,
                    //           disabledBorder: InputBorder.none,
                    //           hintStyle: TextStyle(color: Colors.grey),
                    //           labelText: 'Pickup Address',
                    //           hintText: 'Enter adress'),
                    //       onSaved: (value) {
                    //         _shopAddress = value!;
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 0.5,
                      child: ListTile(
                        trailing: InkWell(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SellerAddressScreen()),
                                ),
                            child: Icon(Icons.edit)),
                        title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.pin_drop,
                                color: Color(0xff41a58d),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delivery Address"),
                                  SizedBox(height: 4),
                                  !hasAddress
                                      ? Text(
                                          "Please set you Address ->",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Container(),
                                  Text(
                                    fullName + " | " + phone,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    address2,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    address1,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    postal_code,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),

                    // TextFormField(
                    //   key: ValueKey('Address'),
                    //   keyboardType: TextInputType.text,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Address is required';
                    //     }
                    //     return null;
                    //   },
                    //   inputFormatters: <TextInputFormatter>[
                    //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    //   ],
                    //   decoration: InputDecoration(
                    //     labelText: 'Pickup Address',
                    //     //  prefixIcon: Icon(Icons.mail),
                    //     // suffixIcon: Text(
                    //     //   '\n \n \$',
                    //     //   textAlign: TextAlign.start,
                    //     // ),
                    //   ),
                    //   //obscureText: true,
                    //   onSaved: (value) {
                    //     _shopAddress = value!;
                    //   },
                    // ),
                    // TextFormField(
                    //   key: ValueKey('Postal Code'),
                    //   keyboardType: TextInputType.number,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Postal Code is required';
                    //     }
                    //     return null;
                    //   },
                    //   inputFormatters: <TextInputFormatter>[
                    //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    //   ],
                    //   decoration: InputDecoration(
                    //     labelText: 'Postal Code',
                    //     //  prefixIcon: Icon(Icons.mail),
                    //     // suffixIcon: Text(
                    //     //   '\n \n \$',
                    //     //   textAlign: TextAlign.start,
                    //     // ),
                    //   ),
                    //   //obscureText: true,
                    //   onSaved: (value) {
                    //     _shopPostalCode = value!;
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            //),
            //),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
