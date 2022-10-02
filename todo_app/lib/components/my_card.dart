import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/theme/app_style.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.todo,
  }) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(todo.time);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${dt.day} / ${dt.month} / ${dt.year}',
                  style: AppStyle.h2,
                ),
                Text(
                  '${dt.hour} h :  ${dt.minute} m',
                  style: AppStyle.h2,
                ),
              ],
            ),
            Text(
              todo.note,
              style: AppStyle.h2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
