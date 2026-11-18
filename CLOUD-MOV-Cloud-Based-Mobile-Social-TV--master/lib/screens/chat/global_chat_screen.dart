import 'package:flutter/material.dart';
import '../../services/chat_service.dart';
import '../../models/chat_model.dart';
import 'chat_message_widget.dart';
import 'chat_input_widget.dart';

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({super.key});

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final ChatService _chatService = ChatService();
  final String _userId = DateTime.now().millisecondsSinceEpoch.toString(); // anonymous session ID
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Global Chat"),
        backgroundColor: const Color(0xFF141414),
      ),
      backgroundColor: const Color(0xFF141414),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessagesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                // Scroll to bottom whenever new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ChatMessageWidget(
                      message: msg,
                      isMe: msg.userId == _userId,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputWidget(
            onSend: (text) {
              if (text.trim().isEmpty) return;
              _chatService.sendMessage(_userId, text.trim());
            },
          ),
        ],
      ),
    );
  }
}
