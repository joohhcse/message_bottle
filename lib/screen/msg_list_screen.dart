import 'package:flutter/material.dart';
import 'package:message_bottle/screen/chatting_screen.dart';
import 'package:message_bottle/screen/send_msg_screen.dart';
import 'package:message_bottle/model/message.dart';
import 'package:message_bottle/model/message_repository.dart';
import 'package:message_bottle/model/bad_users.dart';
import 'package:message_bottle/model/bad_users_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MsgListScreen extends StatefulWidget {
  const MsgListScreen({super.key});

  @override
  State<MsgListScreen> createState() => _MsgListScreenState();
}

class _MsgListScreenState extends State<MsgListScreen> {
  final MessageRepository _repository = MessageRepository();
  final BadUsersRepository _badUsersRepository = BadUsersRepository();
  late SharedPreferences _prefs;
  List<Message> messages = [];
  String myId = '';
  List<BadUsers> badUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }


  Future<String?> _loadUserId() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs.getString('userId');

    if(userId == null) {
      return null;
    }
    else {
      setState(() {
        myId = userId;
      });
      return userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.msg_list,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _repository.getMyMessage(myId),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            // List<Message> messages = snapshot.data ?? [];
            List<Message> messages = snapshot.data!.where((message) => !message.is_delete).toList();

            return StreamBuilder<List<BadUsers>> (
              stream: _badUsersRepository.getMyBadUsers(myId),
              builder: (context, badUsersSnapshot) {
                if(badUsersSnapshot.hasData) {
                  List<String> listBadUsername = badUsersSnapshot.data!.map((badUsers) => badUsers.username).toList();

                  List<Message> filteredMessages = snapshot.data!
                      .where((message) =>
                  !message.is_delete &&
                      !listBadUsername.contains(message.sender_id))
                      .toList();

                  if(filteredMessages.length == 0) {
                    return const Center(child: Text('empty message list!'),);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4, // 카드의 그림자 효과 설정
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 카드의 외부 여백 설정
                        child: ListTile(
                          // leading: Text(messages[index].sender_id),
                          leading: Text(filteredMessages[index].sender_id, style: TextStyle(color: Colors.black38),),
                          title: Text(filteredMessages[index].content),
                          minLeadingWidth: 100,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChattingScreen(
                                  message_id: filteredMessages[index].message_id,
                                  sender_id: filteredMessages[index].sender_id,
                                  recipient_id: filteredMessages[index].recipient_id,
                                  content: filteredMessages[index].content,
                                  time: filteredMessages[index].time,
                                  is_read: filteredMessages[index].is_read,
                                  is_delete: filteredMessages[index].is_delete,
                                ),
                              ),
                            );
                          },
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(AppLocalizations.of(context)!.report),
                                value: 'report',
                              ),
                              PopupMenuItem(
                                child: Text(AppLocalizations.of(context)!.delete),
                                value: 'delete',
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'report') {
                                var uuid = Uuid();

                                BadUsers badUser = BadUsers(
                                  uuid.v4(),
                                  filteredMessages[index].sender_id,
                                  'clicked report button',
                                  DateTime.now().toString(),
                                  filteredMessages[index].recipient_id
                                );

                                _badUsersRepository.addBadUser(badUser).then((value) {
                                  showToast(AppLocalizations.of(context)!.toast_user_report);
                                }).catchError((e){
                                  print(' reportMessage error => ' + e.toString());
                                });

                              } else if (value == 'delete') {
                                _repository.deleteMessage(filteredMessages[index].message_id!).then((value){
                                  showToast(AppLocalizations.of(context)!.toast_msg_delete);
                                }).catchError((e) {
                                  print(' deleteMessage error => ' + e.toString());
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                else if (badUsersSnapshot.hasError) {
                  return Text('Error: List<BadUsers>');
                }
                else if (badUsersSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return const Center(child: Text('Loading...'),);
              }
            );


          }
          else if(snapshot.hasError) {
            return const Center(child: Text('Something wrong'),);
          }
          else if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return const Center(child: Text('Loading...'),);
        },
      ),
    );
  }


  //not used
  Future<List<Message>> selectAndAddMessages(String userId) async {
    try {
      var response = await Supabase.instance.client
          .from('messages')
          .select()
          .eq('recipient_id', userId);

      final List<Map<String, dynamic>> data = response;
      data.forEach((rowData) {
        // messages.add(Message(
        //   message_id: rowData['message_id'].toString(),
        //   sender_id: rowData['sender_id'].toString(),
        //   recipient_id: rowData['recipient_id'].toString(),
        //   content: rowData['content'].toString(),
        //   time: rowData['time'].toString(),
        //   is_read: rowData['is_read'],
        // ));
      });
    } on AuthException catch (error) {
      print('selectAndAddMessages => ' + error.message);
    } on Exception catch (error) {
      print('selectAndAddMessages => ' + error.toString());
    }

    return messages;
  }

  //toast message
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
