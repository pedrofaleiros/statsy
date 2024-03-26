import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/message_model.dart';
import 'package:statsy/presentation/viewmodel/chat_viewmodel.dart';
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
        border: Border.all(color: AppColors.green),
        borderRadius: BorderRadius.circular(32),
      ),
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onSubmitted: (value) async => await _send(),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: context.watch<ChatViewmodel>().isLoading
                ? null
                : () async => await _send(),
            child: const Icon(Icons.send),
          ),
          hintText: 'Faça sua pergunta...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _messagesList(BuildContext context) {
    return Expanded(
      child: ListView(
        reverse: true,
        children: [
          if (context.watch<ChatViewmodel>().isLoading) _loading(),
          ...context.watch<ChatViewmodel>().messages.map(
                (e) => MessageCard(message: e),
              ),
        ],
      ),
    );
  }

  Widget _loading() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: Center(
        child: SizedBox(
          height: 96,
          width: 96,
          child: FlareActor(
            'assets/animations/ia.flr',
            animation: "Aura",
          ),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return message.role == Role.chat
        ? ChatMessage(content: message.content)
        : UserMessage(content: message.content);
  }
}
