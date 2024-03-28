import 'package:flutter/material.dart';
import 'package:message_bottle/model/msg_model.dart';

class MsgViewScreen extends StatelessWidget {
  final Message message;

  MsgViewScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${message.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Content: ${message.content}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

}
