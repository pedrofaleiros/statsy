enum Role { user, chat }

class MessageModel {
  MessageModel({
    required this.id,
    required this.role,
    required this.content,
  });

  final String id;
  final Role role;
  final String content;

  MessageModel copyWith({
    String? id,
    Role? role,
    String? content,
  }) {
    return MessageModel(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }
}
