import 'package:classified_flutter/components/z_image_display.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/chat_details_page.dart';
import 'package:classified_flutter/pages/app/guest_sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var globlekey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return authProvider.isAnonymous
        ? GuestSignInPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Chats'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.streamChats.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        isThreeLine: true,
                        onTap: () {
                          // if (userProvider
                          //         .streamChats[index].messages[0].uuid !=
                          //     userProvider.authUser.id) {
                          //   userProvider.changeChatReaded(
                          //       chats: userProvider.streamChats[index]);
                          // }

                          userProvider.setSelectedChat =
                              userProvider.streamChats[index].id;

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ChatDetailsPage(
                                key: ObjectKey(
                                    userProvider.streamChats[index].id),
                                index: index,
                                // chats: userProvider.streamChats[index],
                              );
                            },
                          ));
                        },
                        leading: Container(
                          width: 60,
                          height: 60,
                          child: ZImageDisplay(
                            height: 120,
                            width: 120,
                            borderRadius: BorderRadius.circular(100),
                            imageUrl:
                                userProvider.streamChats[index].productImgUrl,
                          ),
                        ),
                        title: Text(
                          userProvider.streamChats[index].senderUuid ==
                                  authProvider.authUser.id
                              ? userProvider.streamChats[index].reciverName
                              : userProvider.streamChats[index].senderName,
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${userProvider.streamChats[index].productTitle}',
                                ),
                                Spacer(),
                                if (authProvider.authUser.id !=
                                    userProvider
                                        .streamChats[index].messages[0].uuid)
                                  if (!userProvider
                                      .streamChats[index].messages[0].isReaded)
                                    Container(
                                      alignment: Alignment.center,
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).buttonColor,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Text('1'),
                                    )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    width: 150,
                                    child: Text(
                                      userProvider.streamChats[index]
                                          .messages[0].message,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  userProvider
                                      .streamChats[index].timestampUpdetedStr,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
