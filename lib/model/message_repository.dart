import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:message_bottle/model/message.dart';

class MessageRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<Message>> getAllMessage() {
    final messages =
    _client.from('messages').stream(primaryKey: ['message_id']).map((event) {
      return event.map((e) {
        return Message.fromJson(e);
      }).toList();
    });
    return messages;
  }

  Stream<List<Message>> getMyMessage(String myId) {
    final messages = _client.from('messages')
        .stream(primaryKey: ['message_id'])
        .eq('recipient_id', myId)
        .order('time')
        .map((event) {
      return event.map((e) {
        return Message.fromJson(e);
      }).toList();
    });
    return messages;
  }

  Stream<List<Message>> getMyMessage2(String myId) {
    final messages = _client.from('messages')
        .stream(primaryKey: ['message_id'])
        .eq('recipient_id', myId)
        .distinct()
        .map((event) {
      return event.map((e) {
        return Message.fromJson(e);
      }).toList();
    });
    return messages;
  }

  Future<void> addMessage(Message message) async {
    await _client.from('messages').insert(message);
  }

  Future deleteMessage(String uuid) async {
    return await _client.from('messages').delete().eq('message_id', uuid);
  }


}