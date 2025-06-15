import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled/layout/home_layout.dart';
import 'package:untitled/modules/counter/counter_screen.dart';
import 'package:untitled/shared/bloc_observer.dart';
import 'layout/todo_app.dart';
import 'modules/login_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoApp(),
    );
  }
}
