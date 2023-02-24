import 'package:flutter/material.dart';
import 'package:makerthon/notifier/status_notifier.dart';
import 'package:makerthon/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StatusNotifier>(
      create: (_) => StatusNotifier(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
