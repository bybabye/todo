class Todo {
  final String id;

  final String note;
  final String time;

  Todo({
    required this.id,
    required this.note,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'time': time,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      time: map['time'],
      note: map['note'],
    );
  }
}
