import 'package:flutter/material.dart';
import 'package:message_bottle/screen/chatting_screen.dart';
import 'package:message_bottle/screen/send_msg_screen.dart';
import 'package:message_bottle/model/msg_model.dart';

class MsgListScreen extends StatelessWidget {

  final List<Message> messages = [
    Message(id: '1', title: 'Message 1', content: 'Content of Message 1'),
    Message(id: '2', title: 'Message 2', content: 'Content of Message 2'),
    Message(id: '3', title: 'Message 3', content: 'Content of Message 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 2 - Msg List'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => SendMsgScreen(message: messages[index]),
                  builder: (context) => ChattingScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
