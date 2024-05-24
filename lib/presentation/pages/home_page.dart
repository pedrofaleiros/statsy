import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/pages/chat_page.dart';
import 'package:statsy/presentation/pages/learn_page.dart';
import 'package:statsy/presentation/pages/profile_page.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewmodel = context.read<UserDataViewmodel>();
      final userData = await viewmodel.getUserData();
      if (userData == null) await viewmodel.createUserData();
    });
  }

  int _index = 0;

  final tabs = [
    const LearnPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  final colors = [
    AppColors.orange,
    AppColors.mint,
    AppColors.cyan,
  ];

  final items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.school_rounded),
      label: "Aprender",
    ),
    BottomNavigationBarItem(
      icon: SizedBox(
        height: 32,
        width: 32,
        child: FlareActor('assets/animations/ia.flr'),
      ),
      activeIcon: SizedBox(
        height: 48,
        width: 48,
        child: FlareActor('assets/animations/ia.flr'),
      ),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      label: "Perfil",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        selectedFontSize: 12,
        showUnselectedLabels: false,
        selectedItemColor: colors[_index],
        unselectedItemColor: AppColors.grey,
        onTap: (value) => setState(() => _index = value),
        currentIndex: _index,
        items: items,
      ),
      body: tabs[_index],
    );
  }
}
