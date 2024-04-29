import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:message_bottle/model/bad_users.dart';

class BadUsersRepository {
  final SupabaseClient _client = Supabase.instance.client;



  Future<void> addBadUser(BadUsers badUsers) async {
    await _client.from('bad_users').insert(badUsers);
  }

  // for block bad user
  Future<BadUsers> getBadUser(String username) async {
    // await _client.from('bad_users').insert(badUsers);
    final badUser = await _client
        .from('bad_users')
        .select()
        .eq('username', username) //where
        .single();

    return BadUsers.fromJson(badUser);
  }

  Stream<List<BadUsers>> getMyBadUsers(String myId) {
    final badUsers = _client.from('bad_users')
        .stream(primaryKey: ['message_id'])
        .eq('reporter', myId)
        .map((event) {
      return event.map((e) {
        return BadUsers.fromJson(e);
      }).toList();
    });
    return badUsers;
  }

  // Future<List<BadUsers>> getMyBadUsers(String myId) async {
  //   final badUsers = await _client
  //       .from('bad_users')
  //       .select()
  //       .eq('reporter', myId);
  //
  //   final List<BadUsers> badUsersList = badUsers.map((e) => BadUsers.fromJson(e)).toList();
  //
  //   return badUsersList;
  // }


}