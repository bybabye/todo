import 'dart:ui';

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
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';

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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  AppColors.noteColor,
                  AppColors.noteSecondColor,
                ],
              ),
            ),
          ),
          Positioned(
            top: -(sizeH * 0.2),
            left: sizeW * 0.5,
            child: Image.asset(AppAssets.logo2),
          ),
          Positioned(
            right: sizeW * 0.4,
            bottom: -(sizeH * 0.2),
            child: Image.asset(AppAssets.logo1),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              height: sizeH,
              width: sizeW,
              color: Colors.white.withOpacity(.1),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _space(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            final id = Localstore.instance
                                .collection('todos')
                                .doc()
                                .id;

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
                  _space(),
                  SizedBox(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(.6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 60, horizontal: 8), // <-- SEE HERE
                      ),
                    ),
                  ),
                  _space(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Time",
                        style: AppStyle.h1,
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: DateTimeField(
                          selectedDate: selectedDate,
                          onDateSelected: (DateTime value) {
                            setState(
                              () {
                                selectedDate = value;
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
          ),
        ],
      ),
    );
  }

  Widget _space() {
    return SizedBox(
      height: sizeH * 0.05,
    );
  }
}
