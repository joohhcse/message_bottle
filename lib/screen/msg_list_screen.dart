import 'package:flutter/material.dart';
import 'package:message_bottle/screen/msg_view_screen.dart';
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
        title: Text('Message List'),
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
                  builder: (context) => MsgViewScreen(message: messages[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
