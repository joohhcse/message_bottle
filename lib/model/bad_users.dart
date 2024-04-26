part 'bad_users.g.dart';

class BadUsers {
  final String user_id;
  final String username;
  final String report;
  final String time;

  BadUsers(
      this.user_id,
      this.username,
      this.report,
      this.time,
      );

  factory BadUsers.fromJson(Map<String,dynamic> json) => _$BadUsersFromJson(json);
  Map<String,dynamic> toJson() => _$BadUsersToJson(this);

}