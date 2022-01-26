// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'message_bubble.dart';

// class Messages extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     final User? user = _auth.currentUser;
//     return FutureBuilder(
//       //future: user,
//       builder: (ctx, futureSnapshot) {
//         if (futureSnapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('chat')
//                 .orderBy(
//                   'createdAt',
//                   descending: true,
//                 )
//                 .snapshots(),
//             builder: (ctx, chatSnapshot) {
//               if (chatSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               final chatDocs = chatSnapshot.data.documents;
//               return ListView.builder(
//                 reverse: true,
//                 itemCount: chatDocs.length,
//                 itemBuilder: (ctx, index) => MessageBubble(
//                   chatDocs[index]['text'],
//                   chatDocs[index]['username'],
//                   chatDocs[index]['userImage'],
//                   chatDocs[index]['userId'] == futureSnapshot.data.uid,
//                   key: ValueKey(chatDocs[index].documentID),
//                 ),
//               );
//             });
//       },
//     );
//   }
// }
