import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:statsy/presentation/pages/chat_page.dart';
import 'package:statsy/presentation/pages/learn_page.dart';
import 'package:statsy/presentation/pages/profile_page.dart';
import 'package:statsy/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 2;

  final tabs = [
    const ProfilePage(),
    const ChatPage(),
    const LearnPage(),
  ];

  final colors = [
    AppColors.orange,
    AppColors.cyan,
    AppColors.red,
    AppColors.blue,
  ];

  final items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Perfil",
    ),
    BottomNavigationBarItem(
      // icon: Icon(Icons.chat),
      icon: SizedBox(
        height: 32,
        width: 32,
        child: FlareActor(
          'assets/animations/ia.flr',
        ),
      ),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: "Aprender",
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
