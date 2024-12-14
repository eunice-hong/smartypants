import 'package:example/smartypants_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartypants/smartypants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartyPants Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SmartyPants Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _formattedText = '';

  // Format the input text using SmartyPants
  void _formatInput() {
    setState(() {
      _formattedText = SmartyPants.formatText(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Formatted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Text(_formattedText),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              inputFormatters: <TextInputFormatter>[
                // You can use the SmartypantsFormatter to format the input text
                SmartypantsFormatter(),
              ],
              decoration: InputDecoration(
                labelText: 'Enter text',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _formatInput,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
