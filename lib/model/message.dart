// import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

class Message {
  // final String message_id;
  final String sender_id;
  final String recipient_id;
  final String content;
  final String time;
  final bool is_read;

  // remove
  // Message(
  //     {required this.message_id,
  //     required this.sender_id,
  //     required this.recipient_id,
  //     required this.content,
  //     required this.time,
  //     required this.is_read});

  Message(
      // this.message_id,
      this.sender_id,
      this.recipient_id,
      this.content,
      this.time,
      this.is_read);

  factory Message.fromJson(Map<String,dynamic> json) => _$MessageFromJson(json);
  Map<String,dynamic> toJson() => _$MessageToJson(this);

}