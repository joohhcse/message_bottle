import 'package:flutter/material.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {

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
        title: Text('Flutter Demo'),
      ),
      body: Padding(
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
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: '텍스트를 입력하세요',
                border: OutlineInputBorder(),
              ),
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
