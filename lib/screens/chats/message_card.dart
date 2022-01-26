import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/chats/chatting_page.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List chats = [];
    List temp = [];
    List title = [];
    List unfilterChats = [];
    List filterChats = [];
    List hehe = [];
    List hihi = [];
    User user = _auth.currentUser!;
    print("USERRRRRRRRRRRRRRRRRRR");
    print(user.uid);
    print("USERRRRRRRRRRRRRRRRRRR");
    return Container(
      height: 400,

      // child: Scaffold(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("messages")
              .doc(user.uid)
              .collection(user.uid)
              .orderBy(
                'timestamp',
                descending: true,
              )
              .snapshots(),
          builder: (ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  streamSnapshots) {
            if (streamSnapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshots.data!.docs;

            print("DOCCCCCCCCCCCCC");
            print(documents);
            print("DOCCCCCCCCCCCCC");

            chats = [];
            title = [];
            temp = [];
            unfilterChats = [];
            filterChats = [];
            hehe = [];
            hihi = [];

            documents.forEach((doc) {
              hehe.add([
                doc.data()["idFrom"], //0
                doc.data()["idTo"], //1
                doc.data()["timestamp"], //2
                doc.data()["content"], //3
                doc.data()["type"], //4
                doc.data()["senders_name"], //5
                doc.data()["senders_image"], //6
                doc.data()["receiver_name"], //7
                doc.data()["receiver_image"], //8
                doc.data()["timePosted"], //9
              ]);
              // }
            });

            if (hehe.length > 0) {
              hehe.forEach((element) {
                // if (element[0] == user.uid) {
                //   print("hehe");
                // } else {
                temp.add(element);
                //}
              });

              //   if (temp[0][0] == user.uid) {
              //     chats.add(temp[1]);
              //     title.add(temp[1][0]);
              //     title.add(user.uid);
              //   } else {
              chats.add(temp[0]);
              title.add(temp[0][0]);
              title.add(user.uid);
              // }

              print("HHHHHHHHHHHHHHHHHHHHH");
              print(chats[chats.length - 1][0]);
              print("HHHHHHHHHHHHHHHHHHHHH");

              print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");

              temp.forEach((element) {
                if (title.contains(element[0])) {
                  print("Same");
                } else {
                  title.add(element[0]);
                  chats.add(element);
                }
              });

              print("KKKKKKKKKKKKKKKK");
              print(chats);
              print("KKKKKKKKKKKKKKKK");
            }
            return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) => InkWell(
                      // onTap: () {},

                      onTap: () {
                        print("hahha");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChattingPage(
                                      receiverId: chats[index][0] == user.uid
                                          ? chats[index][1].toString()
                                          : chats[index][0].toString(),
                                      receiverName: chats[index][0] == user.uid
                                          ? chats[index][7].toString()
                                          : chats[index][5].toString(),
                                    )));
                      },
                      child: chats[index][0].toString == user.uid
                          ? Container()
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      //   color: Color(0xffb6b3b3),
                                      ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        child: ClipOval(
                                            child: Material(
                                                color: Colors.blue,
                                                child:

                                                    // chats[index][6]
                                                    //             .toString() !=
                                                    //         ''
                                                    //     ? Image.network(
                                                    //         chats[index][0] ==
                                                    //                 user.uid
                                                    //             ? (chats[index][8])
                                                    //             : chats[index][6]
                                                    //                 .toString(),
                                                    //         fit: BoxFit.fitHeight,
                                                    //       )
                                                    //     :

                                                    Center(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 36,
                                                        vertical: 26),
                                                    child: Text(
                                                        chats[index][0] ==
                                                                user.uid
                                                            ? chats[index][7]
                                                                .toString()[0]
                                                            : chats[index][5]
                                                                    .toString()[
                                                                0], //userInfos[0].email[0] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ))),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          chats[index][0] == user.uid
                                              ? chats[index][7].toString()
                                              : chats[index][5].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            border: Border.all(
                                              color: Color(0xffb6b3b3),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  // Text('Sent:',
                                                  //     style: TextStyle(
                                                  //       fontSize: 12,
                                                  //       fontWeight:
                                                  //           FontWeight.w700,
                                                  //     )),
                                                  Container(
                                                    height: 100,
                                                    width: 200,
                                                    //child: Flexible(
                                                    child: new Container(
                                                      padding:
                                                          new EdgeInsets.only(
                                                              right: 13.0),
                                                      child: new Text(
                                                        "Sent: " +
                                                            chats[index][3]
                                                                .toString(),
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: new TextStyle(
                                                          fontSize: 13.0,
                                                          fontFamily: 'Roboto',
                                                          color: new Color(
                                                              0xFF212121),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    //),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                          width: 240,
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              Text(chats[index][9].toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          Color(0xff757575))),
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
                              )),
                    ));
          }),
      // ),
    );
  }
}
