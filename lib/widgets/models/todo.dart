class AppToDo {
  final int? id;
  final String? title;
  final int? isDone;
  final int? taskId;
  AppToDo({this.id, this.isDone, this.title, this.taskId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isDone': isDone, 'taskId': taskId};
  }
}
