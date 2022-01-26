import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';
import '../widget/popular_products.dart';
import 'package:flutter/cupertino.dart';

class Products with ChangeNotifier {
//   List<Product> _products = [
//     Product(
//         id: 'WATERMELON1',
//         title: 'WATERMELON CHAMPION',
//         description:
//             'Champion watermelons are highly valued for their size, packing in a lot of juice and flavor that will leave your mouth watering. Watermelons are loaded in antioxidants and vitamins that are sure to keep your body young and healthy!',
//         price: 300.00,
//         imageUrl:
//             'https://www.freshproduce.com.ph/409-thickbox_default/watermelon-champion.jpg',
//         brand: 'Reyyan Farm Shop',
//         productCategoryName: 'Fruits',
//         quantity: 65,
//         isPopular: true,
//         isFavorite: false),
//     Product(
//         id: 'POMELO1',
//         title: 'POMELO',
//         description:
//             'On a hot summer day, it’s hard to imagine anything as refreshing as a pomelo! This fruit is valued for its health benefits. It’s rich in Vitamin C and aids digestion, lowers blood pressure, and can aid in weight loss.',
//         price: 40.00,
//         imageUrl:
//             'https://www.freshproduce.com.ph/407-thickbox_default/Pomelo.jpg',
//         brand: 'Reyyan Farm Shop',
//         productCategoryName: 'Fruits',
//         quantity: 65,
//         isPopular: true,
//         isFavorite: false),
//     Product(
//         id: 'PAPAYA GREEN1',
//         title: 'PAPAYA GREEN',
//         description:
//             'Papayas are some of the most delicious and nutritious fruits you can find anywhere. Green papaya is loaded with vitamins, nutrients, and amino acids. Whether it’s eaten on its own or paired with salad, green papayas stimulate digestion, eases constipation, and ease nausea.',
//         price: 40.00,
//         imageUrl:
//             'https://www.freshproduce.com.ph/400-thickbox_default/papaya-green.jpg',
//         brand: 'Reyyan Farm Shop',
//         productCategoryName: 'Fruits',
//         quantity: 65,
//         isPopular: true,
//         isFavorite: false),
//     Product(
//         id: 'APPLE1',
//         title: 'APPLE FUJI',
//         description:
//             'There’s nothing more alluring that the sight of a nice, plump Fuji apple. Each apple is rich in Vitamin C, fiber and bipflavonoids that protect your body from sickness and disease.',
//         price: 40.00,
//         imageUrl:
//             'https://www.freshproduce.com.ph/628-thickbox_default/apple-fuji-size-88.jpg',
//         brand: 'Reyyan Farm Shop',
//         productCategoryName: 'Fruits',
//         quantity: 65,
//         isPopular: true,
//         isFavorite: false),
//   ];

  List<Product> _products = [];
  List<Product> _myproducts = [];

  Future<void> fetchProducts() async {
    print('Fetch method is called');
    await FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((QuerySnapshot productsSnapshot) {
      _products = [];
      productsSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        _products.insert(
          0,
          Product(
              id: element.get('id'),
              title: element.get('name'),
              description: element.get('description'),
              price: double.parse(
                element.get('price'),
              ),
              imageUrl: element.get('image_url'),
              brand: element.get('brand'),
              productCategoryName: element.get('category'),
              quantity: int.parse(
                element.get('quantity'),
              ),
              shop_id: element.get('shop_id'),
              isPopular: true,
              isFavorite: false),
        );
      });
    });

    print("AAAAAAAAAAAAA" + _products.toString());
  }

//   Future<void> fetchMyProducts(uid) async {
//     await FirebaseFirestore.instance
//         .collection('product')
//         .doc(uid)
//         .get()
//         .then((DocumentSnapshot UserSnapshot) {
//       //   UserSnapshot.data() as Map {
//       // print('element.get(productBrand), ${element.get('productBrand')}');
//       print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
//       print(UserSnapshot.get('id'));

//       print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
//       _myproducts.insert(
//         0,
//         Product(
//             // id: UserSnapshot.get('id'),
//             // name: UserSnapshot.get('name'),
//             // email: UserSnapshot.get('email'),
//             // password: UserSnapshot.get('password'),
//             // phone: UserSnapshot.get('phone'),
//             // address: UserSnapshot.get('address'),
//             // image_url: UserSnapshot.get('image_url'),
//             // shop_name: UserSnapshot.get('shop_name'),
//             // shop_id: UserSnapshot.get('shop_id'),
//             id: UserSnapshot.get('id'),
//             title: UserSnapshot.get('name'),
//             description: UserSnapshot.get('description'),
//             price: double.parse(
//               UserSnapshot.get('price'),
//             ),
//             imageUrl: UserSnapshot.get('image_url'),
//             brand: UserSnapshot.get('brand'),
//             productCategoryName: UserSnapshot.get('category'),
//             quantity: int.parse(
//               // element.get('quantity'),
//               UserSnapshot.get('quantity'),
//             ),
//             shop_id: UserSnapshot.get('shop_id'), //element.get('shop_id'),
//             isPopular: false,
//             isFavorite: false),
//       );
//     });

//     print("AAAAAAAAAAAAA" + _products.toString());
//   }

  List<Product> get products {
    return [..._products];
  }

//   List<Product> get myproducts {
//     //  return [..._myproducts];

//     return _products.where((element) => element.brand == ).toList();
//   }

  List<Product> get popularProducts {
    return _products.where((element) => element.isPopular).toList();
  }

  Product findById(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String categoryName) {
    List<Product> _categoryList = _products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<Product> findByBrand(String brandName) {
    List<Product> _categoryList = _products
        .where((element) =>
            element.brand.toLowerCase().contains(brandName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<Product> searchQuery(String searchText) {
    List<Product> _searchList = _products
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:luntian_shop_flutter_next/models/product.dart';

// class Products with ChangeNotifier {
//   List<Product> _products = [];
//   List<Product> get products {
//     return [..._products];
//   }

//   Future<void> fetchProducts() async {
//     await FirebaseFirestore.instance
//         .collection('products')
//         .get()
//         .then((QuerySnapshot productsSnapshot) {
//       _products = [];
//       for (var element in productsSnapshot.docs) {
//         _products.insert(
//           0,
//           Product(
//               id: element.get('productId'),
//               title: element.get('productTitle'),
//               description: element.get('productDescription'),
//               price: double.parse(
//                 element.get('price'),
//               ),
//               imageUrl: element.get('productImage'),
//               brand: element.get('productBrand'),
//               productCategoryName: element.get('productQuantity'),
//               quantity: int.parse(
//                 element.get('price'),
//               ),
//               isPopular: true,
//               isFavorite: true),
//         );
//       }
//     });
//   }

//   List<Product> get popularProducts {
//     return _products.where((element) => element.isPopular).toList();
//   }

//   Product findById(String productId) {
//     return _products.firstWhere((element) => element.id == productId);
//   }

//   List<Product> findByCategory(String categoryName) {
//     List<Product> _categoryList = _products
//         .where((element) => element.productCategoryName
//             .toLowerCase()
//             .contains(categoryName.toLowerCase()))
//         .toList();
//     return _categoryList;
//   }

//   List<Product> findByBrand(String brandName) {
//     List<Product> _categoryList = _products
//         .where((element) =>
//             element.brand.toLowerCase().contains(brandName.toLowerCase()))
//         .toList();
//     return _categoryList;
//   }

//   List<Product> searchQuery(String searchText) {
//     List<Product> _searchList = _products
//         .where((element) =>
//             element.title.toLowerCase().contains(searchText.toLowerCase()))
//         .toList();
//     return _searchList;
//   }
// }
