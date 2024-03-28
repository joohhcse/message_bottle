import 'package:flutter/material.dart';
import 'package:message_bottle/screen/send_screen.dart';
import 'package:message_bottle/screen/msg_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: SendScreen(),
      home: MsgListScreen(),
    );
  }
}
