import 'package:flutter/material.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {

  String _selectedRadio = '';
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('새 쪽지 작성')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Option:'),
            Row(
              children: [
                Radio(
                  value: 'Option 1',
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      _selectedRadio = value;
                    });
                  },
                ),
                Text('Option 1'),
                Radio(
                  value: 'Option 2',
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      _selectedRadio = value;
                    });
                  },
                ),
                Text('Option 2'),
              ],
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter your text here',
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: () {
                // Handle your submit logic here
                String selectedOption = _selectedRadio;
                String enteredText = _textController.text;
                print('Selected Option: $selectedOption');
                print('Entered Text: $enteredText');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

}
