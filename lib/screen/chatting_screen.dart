import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:message_bottle/model/message.dart';
import 'package:message_bottle/model/message_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ChattingScreen extends StatefulWidget {
  final String message_id;
  final String sender_id;
  final String recipient_id;
  final String content;
  final String time;
  final bool is_read;
  final bool is_delete;

  const ChattingScreen({
    Key? key,
    required this.message_id,
    required this.sender_id,
    required this.recipient_id,
    required this.content,
    required this.time,
    required this.is_read,
    required this.is_delete,
  }) : super(key: key);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final MessageRepository _repository = MessageRepository();
  late String messageId;
  late String senderId;
  late String recipientId;
  late String content;
  late String time;
  late bool isRead;
  late bool isDelete;
  TextEditingController _returnTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageId = widget.message_id;
    senderId = widget.sender_id;
    recipientId = widget.recipient_id;
    content = widget.content;
    time = widget.time;
    isRead = widget.is_read;
    isDelete = widget.is_delete;
  }

  Future<void> _returnSubmit() async {

    if(_returnTextController.text.length < 5) {
      showToast(AppLocalizations.of(context)!.toast_plz_enter_content);  //내용을 입력하세요.(5글자 이상)

      return;
    }

    var uuid = Uuid();
    Message msg = Message(uuid.v4(), recipientId, senderId, _returnTextController.text, DateTime.now().toString(), false, false);
    _repository.addMessage(msg).then((value) {
      _returnTextController.clear();
      showToast(AppLocalizations.of(context)!.toast_sent_msg);  //쪽지를 전송했습니다.
    }).catchError((e){
      print(' _returnSubmit error => ' + e.toString());
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reply),  //답장하기
      ),
      // body: Text('ddd : $senderId'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.sender + ' : $senderId',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              // TextField(
              //   readOnly: true,
              //   maxLines: null,
              //   decoration: InputDecoration(
              //     labelText: '$content',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              Text(
                AppLocalizations.of(context)!.received_content + ' : ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                // width: 350,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                          text: TextSpan(
                            text: '$content',
                            style: TextStyle(
                              color: Colors.black,
                              height: 2,
                              fontSize: 18.0,
                            )
                          ),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                '답장보내기 :',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _returnTextController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.hint_compose_msg,
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                maxLength: 120,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣0-9\s~!@#$%^&*()\[\]\-=_+\\;,./<>?:"{}|]*$'),
                    allow: true,
                  )
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _returnSubmit,
                  child: Text(AppLocalizations.of(context)!.send),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyanAccent,
                  ),
                ),
              ),


            ],
        )
      )

    );
  }
}
