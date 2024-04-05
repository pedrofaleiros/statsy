// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/chat_viewmodel.dart';
import 'package:statsy/presentation/widgets/aura_widget.dart';
import 'package:statsy/presentation/widgets/message_card.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: context.watch<ChatViewmodel>().messages.isEmpty
                  ? _emptyMessages()
                  : _messagesList(context),
            ),
            _textField(),
          ],
        ),
      ),
    );
  }

  Widget _messagesList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: context.watch<ChatViewmodel>().messages.length,
      itemBuilder: (context, index) => MessageCard(
        message: context.watch<ChatViewmodel>().messages[index],
      ),
    );
  }

  Widget _emptyMessages() {
    return ListView(
      shrinkWrap: true,
      children: [
        AuraWidget(size: 96),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Como posso te ajudar?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 16),
        _hintItem("Me explique permutação."),
        _hintItem("O que é arranjo simples e composto?"),
        _hintItem("Qual a diferença de combinação e permutação?"),
      ],
    );
  }

  Widget _textField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      // margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.newline,
              // onSubmitted: (value) async => await _send(),
              // maxLines: 3,
              keyboardType: TextInputType.multiline,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Faça sua pergunta...',
                border: InputBorder.none,
              ),
            ),
          ),
          _sendButton(),
        ],
      ),
    );
  }

  Widget _sendButton() {
    return Card(
      child: IconButton(
        onPressed: context.watch<ChatViewmodel>().isLoading ||
                context.watch<ChatViewmodel>().isTipping
            ? null
            : () async => await _send(),
        icon: const Icon(Icons.send),
      ),
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
