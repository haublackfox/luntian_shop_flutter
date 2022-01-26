import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/authentication/authentication.dart';
import 'package:luntian_shop_flutter_next/widget/snackbar.dart';

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

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  String _salutation =
      "Mr."; //This is the selection value. It is also present in my array.
  final _salutations = [
    "Mr.",
    "Mrs.",
    "Master",
    "Mistress"
  ]; //This is the array for dropdown

//   String _uid = '';
  String _name = '';
  String _email = '';
  String _joinedAt = '';
  String _userImageUrl = '';
  String _phoneNumber = '';

  String _shopId = '';
  String _shopName = '';

  var _productTitle = '';
  var _productPrice = '';
  var _productCategory = '';
//   var _productBrand = '';
  var _productDescription = '';
  var _productQuantity = '';
  String dropdownvalue = 'Apple';
  var items = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'watermelon',
    'Pineapple'
  ];
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _categoryValue = '';
  String _brandValue = '';
  String _productWeight = '';
  GlobalMethods _globalMethods = GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String url = '';
  var uuid = const Uuid();
  DateTime now = DateTime.now();

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
    final User user = _auth.currentUser!;
    final _uid = user.uid;
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      print(_productTitle);
      print(_productPrice);
      print(_productCategory);
      //  print(_productBrand);
      print(_productDescription);
      print(_productQuantity);
      // Use those values to send our request ...
    }
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
          final User user = _auth.currentUser!;
          final _uid = user.uid;
          final productId = uuid.v4();
          final ref = FirebaseStorage.instance
              .ref()
              .child('productsImages')
              .child(productId + now.toString() + '.jpg');

          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('product')
              .doc(productId)
              .set({
            'id': productId,
            'shop_id': _shopId,
            'name': _productTitle,
            'price': _productPrice,
            'image_url': url,
            'category': _productCategory,
            'brand': _shopName,
            'description': _productDescription,
            'quantity': _productQuantity,
            // 'sellerId': _uid,
            'createdAt': Timestamp.now(),
          });
          showSnackBar(context, "Product has been successfully added to Shop.",
              Colors.green, 3000);
          Navigator.canPop(context) ? Navigator.pop(context) : null;
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

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget divider() {
    return Container(
      height: 1,
      color: Colors.grey[300],
    );
  }

  getUser() async {
    final User user = _auth.currentUser!;
    final _uid = user.uid;
    // setState(() {
    //   isLoading = true;
    // });
    // DocumentSnapshot doc = await usersRef.doc(_uid).get();
    // user = User.from(doc);
    // displayNameController.text = user.username;
    // bioController.text = user.bio;
    // setState(() {
    //   isLoading = false;
    // });

    print("WHOOOOOOOOOOOOOOOOOO");

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    // if (userDoc == null) {
    //   return;
    // } else {
    print(userDoc);
    _shopName = userDoc.get('shop_name');
    _shopId = userDoc.get('shop_id');

    print(_shopName);
    print(_shopId);
    setState(() {
      //user.email.toString();
      //   _joinedAt = userDoc.get('joinedAt');
      //   _phoneNumber = userDoc.get('phone');
      //   _userImageUrl = userDoc.get(
      //       'image_url'); //user.photoURL.toString(); //userDoc.get('imageUrl');
      //   _userImageUrl = userDoc.get('image_url');
    });
    //}
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile!;
    });
    // widget.imagePickFn(pickedImageFile);
  }

//   void _removeImage() {
//     setState(() {
//       _pickedImage = null;
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
//backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Add Product',
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
        height: kBottomNavigationBarHeight * 1,
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
                  padding: const EdgeInsets.only(right: 0),
                  child: _isLoading
                      ? Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()))
                      : Container(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: _trySubmit,
                              //onPressed: () {}, //_submitForm,
                              child: Row(children: [
                                Text("Publish",
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

                  //   Text('Publish',
                  //       style: TextStyle(fontSize: 16),
                  //       textAlign: TextAlign.center),
                ),
                // GradientIcon(
                //   Feather.upload,
                //   20,
                //   const LinearGradient(
                //     colors: <Color>[
                //       Colors.green,
                //       Colors.yellow,
                //       Colors.deepOrange,
                //       Colors.orange,
                //       Colors.yellow
                //     ],
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  Text(_shopId),
            Center(
              // child: Card(
              //margin: const EdgeInsets.all(15),
              //child: Padding(
              //  padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* Image picker here ***********************************/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          //  flex: 2,
                          child: this._pickedImage == null
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.all(10),
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.only(
                                    //   topLeft: const Radius.circular(40.0),
                                    // ),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  child: Image.file(
                                    this._pickedImage!,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: FlatButton.icon(
                                textColor: Colors.white,
                                onPressed: _pickImageCamera,
                                icon: Icon(
                                  Icons.camera,
                                  color: Color(0xff41a58d),
                                ),
                                label: Text(
                                  'Camera',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textSelectionColor,
                                  ),
                                ),
                              ),
                            ),
                            FittedBox(
                              child: FlatButton.icon(
                                textColor: Colors.white,
                                onPressed: _pickImageGallery,
                                icon: Icon(
                                  Icons.image,
                                  color: Color(0xff41a58d),
                                ),
                                label: Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textSelectionColor,
                                  ),
                                ),
                              ),
                            ),
                            // FittedBox(
                            //   child: FlatButton.icon(
                            //     textColor: Colors.white,
                            //     onPressed: _removeImage,
                            //     icon: Icon(
                            //       Icons.remove_circle_rounded,
                            //       color: Colors.red,
                            //     ),
                            //     label: Text(
                            //       'Remove',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.w500,
                            //         color: Colors.redAccent,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: ValueKey('Title'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Title';
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
                              labelText: 'Product Name',
                              hintText: 'Enter Product Name'),
                          onSaved: (value) {
                            _productTitle = value!;
                          },
                        ),
                      ),
                    ),
                    divider(),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: ValueKey('Product Description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Product Description is required';
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
                              labelText: 'Product Description',
                              hintText: 'Enter Product Description'),
                          onSaved: (value) {
                            _productDescription = value!;
                          },
                        ),
                      ),
                    ),
                    //divider(),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: ValueKey('Price'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Price is missed';
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: 'Price',
                              //  prefixIcon: Icon(Icons.mail),
                              // suffixIcon: Text(
                              //   '\n \n \$',
                              //   textAlign: TextAlign.start,
                              // ),
                            ),
                            //obscureText: true,
                            onSaved: (value) {
                              _productPrice = value!;
                            },
                          ),
                        ),
                      ),
                    ),
                    divider(),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          key: ValueKey('Quantity'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Quantity is missed';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            labelText: 'Quantity',
                          ),
                          onSaved: (value) {
                            _productQuantity = value!;
                          },
                        ),
                      ),
                    ),
                    divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // flex: 3,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _categoryController,

                                  key: ValueKey('Category'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a Category';
                                    }
                                    return null;
                                  },
                                  //keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    labelText: 'Category',
                                  ),
                                  onSaved: (value) {
                                    _productCategory = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        // DropdownButton(
                        //   value: dropdownvalue,
                        //   icon: Icon(Icons.keyboard_arrow_down),
                        //   items: items.map((String items) {
                        //     return DropdownMenuItem(
                        //         value: items, child: Text(items));
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _brandValue = value.toString();
                        //       _brandController.text = value.toString();
                        //       print(_productBrand);
                        //     });
                        //   },
                        //   hint: Text('Select a Brand'),
                        //   //value: _brandValue,
                        // ),
                        // DropdownButton(
                        //   value: _brandValue,
                        //   icon: Icon(Icons.keyboard_arrow_down),
                        //   items: items.map((String items) {
                        //     return DropdownMenuItem(
                        //         value: items, child: Text(items));
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _brandValue = value.toString();
                        //       _brandController.text = value.toString();
                        //       print(_productBrand);
                        //     });
                        //   },
                        //   hint: Text('Select a Brand'),
                        // ),
                        // DropdownButton<String>(
                        //   items: [
                        //     DropdownMenuItem<String>(
                        //       child: Text('Phones'),
                        //       value: 'Phones',
                        //     ),
                        //     DropdownMenuItem<String>(
                        //       child: Text('Clothes'),
                        //       value: 'Clothes',
                        //     ),
                        //     DropdownMenuItem<String>(
                        //       child: Text('Beauty & health'),
                        //       value: 'Beauty',
                        //     ),
                        //     DropdownMenuItem<String>(
                        //       child: Text('Shoes'),
                        //       value: 'Shoes',
                        //     ),
                        //     DropdownMenuItem<String>(
                        //       child: Text('Funiture'),
                        //       value: 'Funiture',
                        //     ),
                        //     DropdownMenuItem<String>(
                        //       child: Text('Watches'),
                        //       value: 'Watches',
                        //     ),
                        //   ],
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _categoryValue = value!.toString();
                        //       _categoryController.text = value;
                        //       //_controller.text= _productCategory;
                        //       print(_productCategory);
                        //     });
                        //   },
                        //   hint: Text('Select a Category'),
                        //   value: _categoryValue,
                        // ),
                      ],
                    ),
                    divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // flex: 3,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _weightController,

                                  key: ValueKey('Weight (kg)'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter weight kg';
                                    }
                                    return null;
                                  },
                                  //keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    labelText: 'Weight (kg)',
                                  ),
                                  onSaved: (value) {
                                    _productWeight = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(right: 9),
                    //         child: Container(
                    //           child: TextFormField(
                    //             controller: _brandController,

                    //             key: ValueKey('Brand'),
                    //             validator: (value) {
                    //               if (value!.isEmpty) {
                    //                 return 'Brand is missed';
                    //               }
                    //               return null;
                    //             },
                    //             //keyboardType: TextInputType.emailAddress,
                    //             decoration: InputDecoration(
                    //               labelText: 'Brand',
                    //             ),
                    //             onSaved: (value) {
                    //               _productBrand = value!;
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     DropdownButton<String>(
                    //       items: [
                    //         DropdownMenuItem<String>(
                    //           child: Text('Brandless'),
                    //           value: 'Brandless',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('Addidas'),
                    //           value: 'Addidas',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('Apple'),
                    //           value: 'Apple',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('Dell'),
                    //           value: 'Dell',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('H&M'),
                    //           value: 'H&M',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('Nike'),
                    //           value: 'Nike',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('Samsung'),
                    //           value: 'Samsung',
                    //         ),
                    //         DropdownMenuItem<String>(
                    //           child: Text('Huawei'),
                    //           value: 'Huawei',
                    //         ),
                    //       ],
                    //       onChanged: (value) {
                    //         setState(() {
                    //           _brandValue = value.toString();
                    //           _brandController.text = value.toString();
                    //           print(_productBrand);
                    //         });
                    //       },
                    //       hint: Text('Select a Brand'),
                    //       value: _brandValue,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 15),

                    //    SizedBox(height: 10),
                  ],
                ),
              ),
              //),
              //),
            ),
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
