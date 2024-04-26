// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  // json['message_id'] as String,
  json['sender_id'] as String,
  json['recipient_id'] as String,
  json['content'] as String,
  json['time'] as String,
  json['is_read'] as bool,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  // 'message_id': instance.message_id,
  'sender_id': instance.sender_id,
  'recipient_id': instance.recipient_id,
  'content': instance.content,
  'time': instance.time,
  'is_read': instance.is_read,
};