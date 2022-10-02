import 'dart:async';

import 'package:flutter/material.dart';

import 'package:localstore/localstore.dart';

import 'package:todo_app/models/todo.dart';

class Todos with ChangeNotifier {
  final db = Localstore.instance;
  final items = <String, Todo>{};
  late StreamSubscription<Map<String, dynamic>>? _subscription;
  DateTime dt = DateTime.now();
  Todos() {
    _subscription = db.collection('todos').stream.listen((event) {
      final item = Todo.fromMap(event);
      items.putIfAbsent(item.id, () => item);
      notifyListeners();
    });
  }

  Future save(Todo data) async {
    db.collection('todos').doc(data.id).set(data.toMap());
    notifyListeners();
  }

  Future delete(id) async {
    db.collection('todos').doc(id).delete();
    notifyListeners();
  }
}
