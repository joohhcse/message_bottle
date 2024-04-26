import 'package:flutter/material.dart';
import 'package:message_bottle/screen/chatting_screen.dart';
import 'package:message_bottle/screen/send_msg_screen.dart';
import 'package:message_bottle/model/message.dart';
import 'package:message_bottle/model/message_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MsgListScreen extends StatefulWidget {
  const MsgListScreen({super.key});

  @override
  State<MsgListScreen> createState() => _MsgListScreenState();
}

class _MsgListScreenState extends State<MsgListScreen> {
  final MessageRepository _repository = MessageRepository();
  late SharedPreferences _prefs;
  List<Message> messages = [];
  String myId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }


  Future<String?> _loadUserId() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs.getString('userId');
    print('userId = ' + userId.toString());

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
          '쪽지 리스트',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _repository.getMyMessage(myId),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            List<Message> messages = snapshot.data ?? [];
            return ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                    return Card(
                      elevation: 4, // 카드의 그림자 효과 설정
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 카드의 외부 여백 설정
                      child: ListTile(
                        // leading: Text(messages[index].sender_id),
                        leading: Text(messages[index].sender_id, style: TextStyle(color: Colors.black38),),
                        title: Text(messages[index].content),
                        minLeadingWidth: 100,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChattingScreen(
                                // message_id: messages[index].message_id,
                                sender_id: messages[index].sender_id,
                                recipient_id: messages[index].recipient_id,
                                content: messages[index].content,
                                time: messages[index].time,
                                is_read: messages[index].is_read,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
            );
          }
          else if(snapshot.hasError) {
            return const Center(child: Text('Something wrong'),);
          }
          return const Center(child: Text('Loading...'),);
        },

      ),

      // remove
      // body: ListView.builder(
      //   padding: const EdgeInsets.fromLTRB(0, 42, 0, 16),
      //   itemCount: messages.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(messages[index].content),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             // builder: (context) => SendMsgScreen(message: messages[index]),
      //             builder: (context) => ChattingScreen(),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
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

}
