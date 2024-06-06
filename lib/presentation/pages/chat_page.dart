import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/chat_viewmodel.dart';
import 'package:statsy/presentation/widgets/app_bar_title.dart';
import 'package:statsy/presentation/widgets/app_logo.dart';
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
  bool isButtonActive = false;

  Future<void> _send() async {
    if (controller.text.length > 5000) {
      showMessageSnackBar(
        context: context,
        message: "Sua pergunta deve ter no máximo 5000 caracteres",
      );
      return;
    }

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
  void initState() {
    super.initState();
    controller.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final isNotEmpty = controller.text.isNotEmpty;
    if (isNotEmpty != isButtonActive) {
      setState(() => isButtonActive = isNotEmpty);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_updateButtonState);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Chat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              'assets/images/gemini_logo.svg',
              height: 32,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
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
      ),
    );
  }

  Widget _messagesList(BuildContext context) {
    final messages = context.watch<ChatViewmodel>().messages;
    return ListView(
      shrinkWrap: true,
      reverse: true,
      children: [
        const SizedBox(height: 32),
        for (var msg in messages) MessageCard(message: msg)
      ],
    );
  }

  Widget _emptyMessages() {
    return ListView(
      shrinkWrap: true,
      children: [
        const AppLogo(size: 64),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Align(
            alignment: Alignment.center,
            child: AppBarTitle(text: "Como posso te ajudar?"),
          ),
        ),
        _hintItem("Me explique permutação."),
        _hintItem("O que é arranjo simples e composto?"),
        _hintItem("Qual a diferença de combinação e permutação?"),
      ],
    );
  }

  Widget _textField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.newline,
            maxLines: 5,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.black
                  : AppColors.grey5,
              hintText: 'Digite uma pergunta',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        _sendButton(),
      ],
    );
  }

  Widget _sendButton() {
    return IconButton(
      onPressed: context.watch<ChatViewmodel>().isLoading ||
              context.watch<ChatViewmodel>().isTipping
          ? null
          : () async => await _send(),
      icon: Icon(
        Icons.send_rounded,
        color: context.watch<ChatViewmodel>().isLoading ||
                context.watch<ChatViewmodel>().isTipping ||
                !isButtonActive
            ? AppColors.grey3
            : AppColors.orange,
      ),
    );
  }

  Widget _hintItem(String text) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(text),
        onTap: () async {
          await context.read<ChatViewmodel>().ask(text);
        },
      ),
    );
  }
}
