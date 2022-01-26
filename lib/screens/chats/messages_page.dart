import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luntian_shop_flutter_next/screens/chats/message_card.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chats',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   Text("Message Thread",
          //       style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.w700,
          //       )),
          //   SizedBox(
          //     height: 16,
          //   ),
          MessageCard()
        ],
      ),
    );
  }
}
