// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/chat_model.dart';
import 'package:statsy/presentation/viewmodel/chat_viewmodel.dart';
import 'package:statsy/presentation/widgets/aura_widget.dart';
import 'package:statsy/presentation/widgets/chat_message.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/presentation/widgets/user_message.dart';
import 'package:statsy/utils/app_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  Future<void> _send() async {
    final viewmodel = context.read<ChatViewmodel>();

    viewmodel.onError = (String? message) {
      showMessageSnackBar(context: context, message: message ?? "");
    };

    final prompt = controller.text;
    FocusScope.of(context).unfocus();
    controller.clear();
    await viewmodel.ask(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _messagesList(context),
              // const Divider(height: 16, thickness: 2),
              Container(height: 16),
              _textField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      // margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(left: 16),
      child: TextField(
        textInputAction: TextInputAction.newline,
        // onSubmitted: (value) async => await _send(),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: context.watch<ChatViewmodel>().isLoading ||
                    context.watch<ChatViewmodel>().isTipping
                ? null
                : () async => await _send(),
            icon: const Icon(Icons.send),
          ),
          hintText: 'Faça sua pergunta...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _messagesList(BuildContext context) {
    return Expanded(
      child: context.watch<ChatViewmodel>().messages.isEmpty
          ? _emptyMessages()
          : ListView.builder(
              reverse: true,
              itemCount: context.watch<ChatViewmodel>().messages.length,
              itemBuilder: (context, index) => MessageCard(
                message: context.watch<ChatViewmodel>().messages[index],
              ),
            ),
    );
  }

  Widget _emptyMessages() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AuraWidget(size: 128),
        SizedBox(height: 16),
        Text(
          'Como posso te ajudar?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _hintItem("Me explique permutação."),
              _hintItem("O que é arranjo simples e composto?"),
              _hintItem("Qual a diferença de combinação e permutação?"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hintItem(String text) {
    return Card(
      child: ListTile(
        title: Text(text),
        onTap: () async {
          await context.read<ChatViewmodel>().ask(text);
        },
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final ChatModel message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserMessage(content: message.userText),
        ChatMessage(content: message.chatText),
      ],
    );
  }
}
