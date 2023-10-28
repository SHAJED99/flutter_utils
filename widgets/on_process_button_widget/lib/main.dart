// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';
import 'package:get/get.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Rx<Offset> hoveringOffset = Offset(0, 0).obs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Obx(
            () => Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      OnProcessButtonWidget(
                        onTap: () async {
                          await Future.delayed(Duration(seconds: 1));
                          return false;
                        },
                        // child: Icon(Icons.error, color: Colors.white),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(0, 2),
                        //     color: Colors.black.withOpacity(0.5),
                        //     blurRadius: 2,
                        //     spreadRadius: 1,
                        //   )
                        // ],

                        roundBorderWhenRunning: true,
                        onHovering: (offset) {
                          hoveringOffset.value = offset.localPosition;
                        },
                        onHover: (isEnter) {
                          if (!isEnter) hoveringOffset.value = Offset(0, 0);
                        },
                        // expanded: false,

                        child: Text("Hello"),
                        // alignment: Alignment.center,
                        // alignment: Alignment(hoveringOffset.value.dx, hoveringOffset.value.dy),
                      ),
                      // Positioned(
                      //   left: hoveringOffset.value.dx - 4,
                      //   top: hoveringOffset.value.dy - 4,
                      //   child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
