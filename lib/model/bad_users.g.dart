// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bad_users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadUsers _$BadUsersFromJson(Map<String, dynamic> json) => BadUsers(
  // json['message_id'] as String,
  json['user_id'] as String,
  json['username'] as String,
  json['report'] as String,
  json['time'] as String,
);

Map<String, dynamic> _$BadUsersToJson(BadUsers instance) => <String, dynamic>{
  'user_id': instance.user_id,
  'username': instance.username,
  'report': instance.report,
  'time': instance.time,
};