import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:message_bottle/model/msg_model.dart';

class SendMsgScreen extends StatefulWidget {
  const SendMsgScreen({super.key});

  @override
  State<SendMsgScreen> createState() => _SendMsgScreenState();
}

class _SendMsgScreenState extends State<SendMsgScreen> {
  String? _radioValue = 'Option 1';
  TextEditingController _textEditingController = TextEditingController();

  void _handleSubmit() {
    // 전송 버튼 클릭 시 수행할 작업을 여기에 추가합니다.
    print('전송 버튼이 클릭되었습니다.');
    print('라디오 버튼 선택: $_radioValue');
    print('텍스트 입력: ${_textEditingController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('라디오 버튼 선택:'),
            Row(
              children: [
                Radio(
                  value: 'Option 1',
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                    });
                  },
                ),
                Text('Option 1'),
                Radio(
                  value: 'Option 2',
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                    });
                  },
                ),
                Text('Option 2'),
              ],
            ),
            SizedBox(height: 20),
            Text('텍스트 입력:'),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: '텍스트를 입력하세요',
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
                  RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣0-9\s]*$'),
                  allow: true,
                )
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('전송'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

