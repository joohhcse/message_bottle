import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:message_bottle/banner_ad_widget.dart';

class SendMsgScreen extends StatefulWidget {
  const SendMsgScreen({super.key});

  @override
  State<SendMsgScreen> createState() => _SendMsgScreenState();
}

class _SendMsgScreenState extends State<SendMsgScreen> {
  String? _radioValue = 'Option 1';
  TextEditingController _textEditingController = TextEditingController();
  late SharedPreferences _prefs;
  late String _myUserId;

  Future<void> _handleSubmit() async {

    if(_textEditingController.text.length < 5) {
      showToast(AppLocalizations.of(context)!.toast_plz_enter_content); //내용을 입력하세요.(5글자 이상)
      return;
    }
    
    insertMessage(_myUserId, _textEditingController.text).then((value) {
      _textEditingController.clear();
      showToast(AppLocalizations.of(context)!.toast_sent_msg);  //쪽지를 전송했습니다.
    }).catchError((e){
      print(' _handleSubmit error => ' + e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs.getString('userId');

    if(userId == null) {
      print('sendMsgScreen > _loadUserId error >>> userId is null!!');
    }
    else {
      print('sendMsgScreen > _loadUserId : useId >>>' + userId);
      _myUserId = userId;
    }
  }

  Future<void> insertMessage(String senderId, String content) async {
    try{
      // var response1 = await Supabase.instance.client
      //     .from('users')
      //     .select('user_id')
      //     .order('RANDOM()')
      //     .limit(1);

      var countResponse = await Supabase.instance.client
          .from('users')
          .count(); // select count(*) from users
      int rowCount = int.parse(countResponse.toString());
      if(rowCount == 0) return;
      int randomIndex = Random().nextInt(rowCount);
      var response1 = await Supabase.instance.client
          .from('users')
          .select('username')
          .limit(1)
          .range(randomIndex, randomIndex);

      if(senderId == response1[0]['username'].toString()) {
        showToast(AppLocalizations.of(context)!.toast_plz_resend); //쪽지를 다시 전송해주세요.
        return;
      }

      final response2 = await Supabase.instance.client
          .from('messages')
          .insert({'sender_id': senderId, 'recipient_id':response1[0]['username'].toString(), 'content': content});
    } on AuthException catch (error) {
      print(' insertMessage 3 => ' + error.message);
    } on Exception catch (error) {
      print(' insertMessage 4 => ' + error.toString());
    } finally {
      showToast(AppLocalizations.of(context)!.toast_sent_msg);
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 38, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerAdWidget(), //admop
            Text(
            AppLocalizations.of(context)!.compose_new_msg, //'새로운 메시지 작성',
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            // Row(
            //   children: [
            //     Radio(
            //       value: 'Option 1',
            //       groupValue: _radioValue,
            //       onChanged: (value) {
            //         setState(() {
            //           _radioValue = value;
            //         });
            //       },
            //     ),
            //     Text('Option 1'),
            //     Radio(
            //       value: 'Option 2',
            //       groupValue: _radioValue,
            //       onChanged: (value) {
            //         setState(() {
            //           _radioValue = value;
            //         });
            //       },
            //     ),
            //     Text('Option 2'),
            //
            //     // ElevatedButton( //test
            //     //     onPressed: () {
            //     //       _showUsernameInputDialog(context);
            //     //     },
            //     //     child: Text('BTN'),
            //     // )
            //   ],
            // ),
            SizedBox(height: 20),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.hint_compose_msg, //'hint compose msg',
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
                onPressed: _handleSubmit,
                child: Text(AppLocalizations.of(context)!.send),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  //not used // alert example
  Future<void> _showUsernameInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Username'),
          content: TextField(
            // onChanged: (value) {
            //   usernameModel.updateUsername(value);
            // },
            decoration: InputDecoration(hintText: 'Username'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}

