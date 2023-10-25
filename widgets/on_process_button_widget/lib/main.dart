import 'package:flutter/material.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnProcessButtonWidget();
  }
}
