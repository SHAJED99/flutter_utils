// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //     // useMaterial3: true,
      //     ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnProcessButtonWidget(
                  onTap: () async {
                    await Future.delayed(Duration(seconds: 1));
                    return false;
                  },
                  child: Icon(Icons.error, color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ],

                  roundBorderWhenRunning: true,
                  expanded: false,

                  // child: Text("Hello"),
                  // alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
