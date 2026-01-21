import 'package:flutter/material.dart';
import 'package:example/styling.dart';
import 'package:example/widgets/button.dart';
import 'package:example/widgets/nav_bar.dart';
import 'package:example/pages/button_page.dart';
import 'package:example/pages/spinner_page.dart';
import 'package:example/pages/nav_bar_page.dart';

final _brightnessNotifier = ValueNotifier(Brightness.light);

void main() {
  runApp(const OrientUIPlayground());
}

class OrientUIPlayground extends StatelessWidget {
  const OrientUIPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: _brightnessNotifier,
      builder: (context, brightness, _) {
        final isDark = brightness == Brightness.dark;

        return Styling(
          brightness: brightness,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Orient UI',
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF09090B),
            ),
            home: const PlaygroundShell(),
          ),
        );
      },
    );
  }
}

class PlaygroundShell extends StatefulWidget {
  const PlaygroundShell({super.key});

  @override
  State<PlaygroundShell> createState() => _PlaygroundShellState();
}

class _PlaygroundShellState extends State<PlaygroundShell> {
  int _currentIndex = 0;

  static const _pages = [
    _PageInfo(
      title: 'Button',
      icon: Icons.smart_button_outlined,
      page: ButtonPage(),
    ),
    _PageInfo(title: 'Spinner', icon: Icons.refresh, page: SpinnerPage()),
    _PageInfo(title: 'NavBar', icon: Icons.menu, page: NavBarPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _pages
            .map((p) => NavBarItem(icon: Icon(p.icon), label: p.title))
            .toList(),
        railHeader: _buildHeader(),
        railFooter: _buildThemeToggle(),
        body: _pages[_currentIndex].page,
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Orient UI',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4),
        Text(
          'Widget Playground',
          style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
        ),
      ],
    );
  }

  Widget _buildThemeToggle() {
    return ValueListenableBuilder<Brightness>(
      valueListenable: _brightnessNotifier,
      builder: (context, brightness, _) {
        final isDark = brightness == Brightness.dark;

        return Button.small(
          onPressed: () {
            _brightnessNotifier.value = isDark
                ? Brightness.light
                : Brightness.dark;
          },
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          label: isDark ? 'Light mode' : 'Dark mode',
          variant: ButtonVariant.ghost,
        );
      },
    );
  }
}

class _PageInfo {
  final String title;
  final IconData icon;
  final Widget page;

  const _PageInfo({
    required this.title,
    required this.icon,
    required this.page,
  });
}
