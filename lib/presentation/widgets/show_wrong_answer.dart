import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statsy/presentation/widgets/question_image.dart';
import 'package:statsy/utils/app_colors.dart';

Future<void> showWrongAnswer(
  BuildContext context,
  String message,
  String alt,
  String questionId,
) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: double.infinity,
      child: WrongAnswer(
        message: message,
        questionId: questionId,
        alt: alt,
      ),
    ),
  );
}

class WrongAnswer extends StatefulWidget {
  const WrongAnswer({
    super.key,
    required this.message,
    required this.alt,
    required this.questionId,
  });

  final String message;
  final String questionId;
  final String alt;

  @override
  State<WrongAnswer> createState() => _WrongAnswerState();
}

class _WrongAnswerState extends State<WrongAnswer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _load(widget.questionId),
    );
  }

  void _load(String id) async {
    try {
      final storage = FirebaseStorage.instance.ref();
      final pathReference = storage.child("resolution/res$id.png");
      final data = await pathReference.getDownloadURL();
      setState(() => image = data);
    } catch (e) {
      return;
    }
  }

  String? image;

  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _listTile(),
        if (show)
          Expanded(
            child: Card(
              elevation: 12,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Resposta: ${widget.alt}"),
                  ),
                  QuestionImage(image: image),
                ],
              ),
            ),
          ),
        _button(),
      ],
    );
  }

  ListTile _listTile() {
    return ListTile(
      trailing: show
          ? null
          : TextButton(
              onPressed: () => setState(() => show = true),
              child: const Text('Ver resolução'),
            ),
      leading: const Icon(
        Icons.check_box,
        color: AppColors.red,
      ),
      title: Text(
        widget.message,
        style: const TextStyle(
          color: AppColors.red,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _button() {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: CupertinoButton(
        color: AppColors.red,
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Próximo',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
