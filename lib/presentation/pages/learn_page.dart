import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/presentation/widgets/lesson_list_tile.dart';
import 'package:statsy/utils/app_colors.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  List<LessonModel>? lessons;
  UserDataModel? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _load();
    });
  }

  Future<void> _load() async {
    final lViewmodel = context.read<LessonViewmodel>();
    final udViewmodel = context.read<UserDataViewmodel>();

    final list = await lViewmodel.listLessons();
    final ud = await udViewmodel.getUserData();

    setState(() {
      lessons = list;
      userData = ud;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.black,
        backgroundColor: AppColors.orange,
        title: const Text("Aprender"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => loading = true);
          await _load();
        },
        child: SafeArea(
          child: _lessons(),
        ),
      ),
    );
  }

  Widget _lessons() {
    if (loading || userData == null || lessons == null) {
      return const LinearProgressIndicator();
    }

    return ListView.builder(
      itemCount: lessons!.length,
      itemBuilder: (context, index) => LessonListTile(
        lesson: lessons![index],
        userData: userData!,
      ),
    );
  }
}
