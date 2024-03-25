import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/presentation/viewmodel/alternative_viewmodel.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';

class QuestionAlternativeListTile extends StatefulWidget {
  const QuestionAlternativeListTile({
    super.key,
    required this.alternative,
  });

  final AlternativeModel alternative;

  @override
  State<QuestionAlternativeListTile> createState() =>
      _QuestionAlternativeListTileState();
}

class _QuestionAlternativeListTileState
    extends State<QuestionAlternativeListTile> {
  Future<void> _delete(BuildContext context) async {
    final viewmodel = context.read<AlternativeViewmodel>();

    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Deletado com sucesso');
    };

    await viewmodel.delete(widget.alternative.id);
  }

  Future<void> _save(BuildContext context) async {
    final viewmodel = context.read<AlternativeViewmodel>();

    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Salvo com sucesso');
    };

    final saveAlt = widget.alternative.copyWith(
      text: controller.text,
      isCorrect: isCorrect,
    );

    await viewmodel.save(saveAlt);
  }

  final controller = TextEditingController();
  late bool isCorrect;
  @override
  void initState() {
    super.initState();
    isCorrect = widget.alternative.isCorrect;
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget.alternative.text;

    return Dismissible(
      background: _background(),
      key: Key(widget.alternative.id),
      onDismissed: (_) async => await _delete(context),
      direction: DismissDirection.endToStart,
      child: ListTile(
        title: TextField(
          textInputAction: TextInputAction.done,
          onSubmitted: (_) async => await _save(context),
          maxLines: 2,
          controller: controller,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        trailing: IconButton(
          onPressed: () async => await _save(context),
          icon: const Icon(Icons.save_outlined),
        ),
        leading: IconButton(
          onPressed: () => setState(() => isCorrect = !isCorrect),
          icon: isCorrect
              ? const Icon(Icons.radio_button_checked)
              : const Icon(Icons.radio_button_off),
        ),
      ),
    );
  }

  Widget _background() {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      color: AppColors.red.withOpacity(0.25),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.delete),
        ],
      ),
    );
  }
}
