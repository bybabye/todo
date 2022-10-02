import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'package:todo_app/components/my_home.dart';
import 'package:todo_app/models/todos.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Todos())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHome(),
      ),
    );
  }
}
