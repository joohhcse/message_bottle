class ChatDto {
  ChatDto(this.id, this.name, this.text);
  final String id;
  final String name;
  final String text;

  factory ChatDto.fromJson(Map<String, dynamic> json) =>
      ChatDto(json['id'], json['name'], json['text']);

  Map<String, dynamic> get toJson =>
      <String, dynamic>{'id': id, 'name': name, 'text': text};
}