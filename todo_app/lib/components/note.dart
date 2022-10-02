import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todos.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/theme/app_style.dart';

import '../models/notification_sevirce.dart';
import '../models/todo.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  late DateTime selectedDate;
  late double sizeH;
  late double sizeW;
  late Todos todosModel;
  late TextEditingController _controller;
  @override
  void initState() {
    Noti.initialize(flutterLocalNotificationsPlugin);
    selectedDate = DateTime.now();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeH = MediaQuery.of(context).size.height;
    sizeW = MediaQuery.of(context).size.width;
    todosModel = Provider.of<Todos>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                final id = Localstore.instance.collection('todos').doc().id;

                final item = Todo(
                  id: id,
                  time: selectedDate.toString(),
                  note: _controller.text,
                );
                todosModel.save(item);
                todosModel.items.putIfAbsent(item.id, () => item);
                Noti.showTextNotification(
                  title: "Có thông báo nè Cậu chủ?...",
                  body: item.note,
                  tz: tz.TZDateTime.from(selectedDate, tz.local),
                  fln: flutterLocalNotificationsPlugin,
                );

                Navigator.pop(context);
              }
            },
            child: _controller.text.isNotEmpty
                ? const Text(
                    "Done",
                    style: AppStyle.h1,
                  )
                : Text(
                    "Done",
                    style: AppStyle.h1.copyWith(color: Colors.grey),
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 60, horizontal: 8), // <-- SEE HERE
                ),
              ),
            ),
            _space(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Time"),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: DateTimeField(
                    selectedDate: selectedDate,
                    onDateSelected: (DateTime value) {
                      setState(
                        () {
                          selectedDate = value;
                          print(selectedDate);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            _space(),
          ],
        ),
      ),
    );
  }

  Widget _space() {
    return SizedBox(
      height: sizeH * 0.05,
    );
  }
}
