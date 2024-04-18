import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statsy/presentation/widgets/question_image.dart';
import 'package:statsy/utils/app_colors.dart';

Future<void> showCorrectAnswer(
  BuildContext context,
  String message,
  String questionId,
) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: double.infinity,
      child: CorrectAnswer(
        message: message,
        questionId: questionId,
      ),
    ),
  );
}

class CorrectAnswer extends StatefulWidget {
  const CorrectAnswer({
    super.key,
    required this.message,
    required this.questionId,
  });

  final String message;
  final String questionId;

  @override
  State<CorrectAnswer> createState() => _CorrectAnswerState();
}

class _CorrectAnswerState extends State<CorrectAnswer> {
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
                children: [QuestionImage(image: image)],
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
        color: AppColors.green,
      ),
      title: Text(
        widget.message,
        style: const TextStyle(
          color: AppColors.green,
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
        color: AppColors.green,
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
