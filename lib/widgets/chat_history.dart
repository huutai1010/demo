import '../models/conversation.dart';
import 'chat_item.dart';
import 'package:flutter/material.dart';

class ChatHistory extends StatelessWidget {
  final List<Conversation> conversations;
  const ChatHistory({
    super.key,
    required this.conversations,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => ChatItem(
        receiver: conversations[index].receiver,
        convData: conversations[index].convData,
      ),
      itemCount: conversations.length,
    );
  }
}
