class Task {
  final int id;
  String todo;
  String completed; // Changed from bool to String
  final int userId;

  Task({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'].toString(), // Convert bool to String
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }
}
