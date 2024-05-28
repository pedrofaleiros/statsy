import 'package:flutter/material.dart';
import 'package:statsy/presentation/pages/chat_page.dart';
import 'package:statsy/presentation/pages/learn_page.dart';
import 'package:statsy/presentation/pages/profile_page.dart';
import 'package:statsy/presentation/widgets/app_logo.dart';
import 'package:statsy/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 1;

  final tabs = [
    const LearnPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  final items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.school_rounded),
      label: "Aprender",
    ),
    BottomNavigationBarItem(
      icon: AppLogoGray(size: 24),
      activeIcon: AppLogo(size: 24),
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
        selectedFontSize: 12,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: AppColors.grey,
        onTap: (value) => setState(() => _index = value),
        currentIndex: _index,
        items: items,
      ),
      body: tabs[_index],
    );
  }
}
