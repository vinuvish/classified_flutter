import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChatDetailsPage extends StatefulWidget {
  // final Chats chats;
  final int index;
  ChatDetailsPage({Key key, this.index}) : super(key: key);

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final textController = TextEditingController();

  String newMessage = '';
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            userProvider.selectedChat.senderUuid == authProvider.authUser.id
                ? userProvider.selectedChat.reciverName
                : userProvider.selectedChat.senderName,
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              reverse: true,
              itemCount: userProvider.selectedChat.messages.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          userProvider.selectedChat.messages[index].uuid ==
                                  authProvider.authUser.id
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(3),
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                              color: userProvider
                                          .selectedChat.messages[index].uuid ==
                                      authProvider.authUser.id
                                  ? Theme.of(context).buttonColor
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            userProvider.selectedChat.messages[index].message,
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ));
              },
            )),
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: themeProvider.isLightTheme
                    ? Colors.grey[400]
                    : Colors.blueGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type something...",
                        hintStyle: TextStyle(),
                      ),
                      onChanged: (value) {
                        newMessage = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed: () {
                      userProvider.sendRealTimeMessage(
                          chats: userProvider.selectedChat,
                          newMessage: newMessage);
                      textController.clear();
                      // userProvider.fetchStreamChats();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        // bottomNavigationBar: _buildInput(),
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   final authProvider = Provider.of<AuthProvider>(context);
//   final userProvider = Provider.of<UserProvider>(context);
//   final themeProvider = Provider.of<ThemeProvider>(context);

//   return GestureDetector(
//     onTap: () {
//       FocusScope.of(context).requestFocus(new FocusNode());
//     },
//     child: Scaffold(
//       appBar: AppBar(
//         title: Text(
//           userProvider.streamChats[widget.index].senderUuid ==
//                   authProvider.authUser.id
//               ? userProvider.streamChats[widget.index].reciverName
//               : userProvider.streamChats[widget.index].senderName,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: ListView.builder(
//             reverse: true,
//             itemCount: userProvider.streamChats[widget.index].messages.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 6,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: userProvider.streamChats[widget.index]
//                                 .messages[index].uuid ==
//                             authProvider.authUser.id
//                         ? MainAxisAlignment.end
//                         : MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.all(3),
//                         width: MediaQuery.of(context).size.width / 2,
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 15,
//                         ),
//                         decoration: BoxDecoration(
//                             color: userProvider.streamChats[widget.index]
//                                         .messages[index].uuid ==
//                                     authProvider.authUser.id
//                                 ? Theme.of(context).buttonColor
//                                 : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Text(
//                           userProvider.streamChats[widget.index].messages[index]
//                               .message,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       )
//                     ],
//                   ));
//             },
//           )),
//           Container(
//             margin: EdgeInsets.all(15),
//             padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             decoration: BoxDecoration(
//               color: themeProvider.isLightTheme
//                   ? Colors.grey[400]
//                   : Colors.blueGrey,
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10),
//               ),
//             ),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: textController,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "Type something...",
//                       hintStyle: TextStyle(),
//                     ),
//                     onChanged: (value) {
//                       newMessage = value;
//                     },
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.send,
//                   ),
//                   onPressed: () {
//                     userProvider.sendRealTimeMessage(
//                         chats: widget.chats, newMessage: newMessage);
//                     textController.clear();
//                   },
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       // bottomNavigationBar: _buildInput(),
//     ),
//   );
// }
