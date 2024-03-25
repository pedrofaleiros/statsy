import 'package:flutter/material.dart';
import 'package:statsy/presentation/pages/profile_page.dart';
import 'package:statsy/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 3;

  final tabs = [
    Placeholder(),
    Placeholder(),
    Placeholder(),
    const ProfilePage(),
  ];

  final colors = [
    AppColors.orange,
    AppColors.green,
    AppColors.red,
    AppColors.blue,
  ];

  final items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: "Aprender",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_sharp),
      label: "Progresso",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Perfil",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
