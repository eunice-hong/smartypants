import 'package:flutter/material.dart';

import 'examples_tab.dart';
import 'playground_tab.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartyPants Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<PlaygroundTabState> _playgroundKey =
      GlobalKey<PlaygroundTabState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTryExample(String inputText) {
    // Switch to Playground tab and inject the text
    _tabController.animateTo(0);
    // Wait for animation to settle, then set text
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _playgroundKey.currentState?.setInput(inputText);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Example loaded in Playground'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartyPants'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.edit_note_rounded),
              text: 'Playground',
            ),
            Tab(
              icon: Icon(Icons.auto_stories_rounded),
              text: 'Examples',
            ),
          ],
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          indicatorColor: theme.colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PlaygroundTab(key: _playgroundKey),
          ExamplesTab(onTryExample: _onTryExample),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
