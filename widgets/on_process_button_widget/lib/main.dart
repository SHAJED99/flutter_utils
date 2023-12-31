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
  final RxString buttonText = "Hover Here".obs;
  final RxString processDone = "".obs;
  final RxBool buttonRunning = true.obs;

  Future<bool?> onCallFunction({bool? type}) async {
    await Future.delayed(Duration(seconds: 2));
    return type;
  }

  final Widget _____spacing = SizedBox(height: 8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Obx(
            () => Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //! Hovering effect && On processing loading indicator
                    OnProcessButtonWidget(
                      backgroundColor: Colors.amber,
                      onTap: () async => await onCallFunction(),
                      onHover: (isEnter) => buttonText.value = isEnter ? "Hi" : "Hover Here",
                      child: Text(buttonText.value),
                    ),
                    _____spacing,

                    //! Request status - true and false
                    OnProcessButtonWidget(
                      backgroundColor: Colors.blue,
                      onTap: () async => await onCallFunction(type: true),
                      // onTap: () async => await onCallFunction(type: false),
                      child: Text("Request status"),
                    ),
                    _____spacing,

                    //! Double process
                    OnProcessButtonWidget(
                      backgroundColor: Colors.purple,
                      onTap: () async {
                        processDone.value = "Running first task.";
                        var s = await onCallFunction(type: true);
                        processDone.value = "First operation status $s";
                        return s;
                      },
                      onDone: (isSuccess) async {
                        // TODO: You can your homepage here. If onTap function (Login process) return true it will redirect to the homepage.
                        processDone.value = "Running second task.";
                        await onCallFunction();
                        processDone.value = "";
                      },
                      child: Text("Double process"),
                    ),
                    if (processDone.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text("Process status: ${processDone.value}")),
                    _____spacing,

                    //! Shadow and Icon color can be changed
                    OnProcessButtonWidget(
                      iconColor: Colors.black,
                      backgroundColor: Colors.amberAccent,
                      onTap: () async => await onCallFunction(type: false),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 2), color: Colors.black54, blurRadius: 2)
                      ],
                      child: Text("My shadow and Icon color can be changed"),
                    ),
                    _____spacing,

                    //! On processing widget is changeable
                    OnProcessButtonWidget(
                      backgroundColor: Colors.green,
                      onTap: () async => await onCallFunction(type: true),
                      onRunningWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("On processing widget is changed"),
                        ],
                      ),
                      onSuccessWidget: Icon(
                        Icons.wallpaper_rounded,
                        color: Colors.white,
                      ),
                      child: Text("On processing and Status widget"),
                    ),
                    _____spacing,

                    //! Use as a card
                    OnProcessButtonWidget(
                      enable: false,
                      iconColor: Colors.amber,
                      backgroundColor: Colors.white,
                      child: Text(
                        "I am a card",
                        style: TextStyle(color: Colors.black),
                      ),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 2), color: Colors.black54, blurRadius: 2)
                      ],
                    ),
                    _____spacing,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
