import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/my_card.dart';
import 'package:todo_app/components/note.dart';
import 'package:todo_app/models/todos.dart';
import 'package:todo_app/theme/app_assets.dart';
import 'package:todo_app/theme/app_colors.dart';
import 'package:todo_app/theme/app_style.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late double sizeH;
  late double sizeW;
  late Todos todosModel;
  DateTime dt = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    todosModel = Provider.of<Todos>(context);
    sizeH = MediaQuery.of(context).size.height;
    sizeW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.mainColor,
                  AppColors.mainSecondColor,
                ],
              ),
            ),
          ),
          Positioned(
            left: -(sizeW * 0.3),
            child: Image.asset(AppAssets.vector3),
          ),
          Positioned(
            top: -(sizeH * 0.2),
            right: -(sizeW * 0.5),
            child: Image.asset(AppAssets.vector),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(AppAssets.vector1),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Container(
              height: sizeH,
              width: sizeW,
              color: Colors.white.withOpacity(.25),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _space(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(AppAssets.ava),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: IconButton(
                              iconSize: 40,
                              hoverColor: Colors.blue[300],
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Note(),
                                  ),
                                )
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _space(),
                      const Text(
                        'Task List',
                        style: AppStyle.h1,
                      ),
                      SizedBox(
                        height: sizeH * 0.7,
                        width: sizeW,
                        child: todosModel.items.isEmpty
                            ? const Center(
                                child: Text(
                                  "Không có Task nào ...!",
                                  style: AppStyle.h2,
                                ),
                              )
                            : ListView.builder(
                                itemCount: todosModel.items.keys.length,
                                itemBuilder: (context, index) {
                                  final key =
                                      todosModel.items.keys.elementAt(index);
                                  final item = todosModel.items[key]!;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    height: sizeH * .1,
                                    width: sizeW,
                                    child: Slidable(
                                      // The end action pane is the one at the right or the bottom side.
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            // An action can be bigger than the others.
                                            onPressed: (context) {
                                              todosModel.delete(item.id);
                                              setState(() {
                                                todosModel.items
                                                    .remove(item.id);
                                              });
                                            },

                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: MyCard(todo: item),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
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
