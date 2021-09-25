import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/widgets/models/task.dart';
import 'package:to_do_app/widgets/models/todo.dart';

class AppDatabase {
  Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), 'todo.db'),
        onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
      );
      await db.execute(
        'CREATE TABLE todo(id INTEGER PRIMARY KEY,taskId INTEGER, title TEXT, isDone INTEGER)',
      );
    }, version: 1);
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTitle(int taskId, String title) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$taskId'");
  }

  Future<void> updateDescrip(int taskId, String descr) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$descr' WHERE id = '$taskId'");
  }

  Future<void> deleteTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id ='$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId ='$id'");
  }

  Future<void> updateiSDone(int toDoId, int isDone) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$toDoId'");
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    print(taskMap);
    return List.generate(taskMap.length, (index) {
      return Task(
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          id: taskMap[index]['id']);
    });
  }

  Future<void> insertToDo(AppToDo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AppToDo>> getToDos(int? taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> toDoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    print(toDoMap);
    return List.generate(toDoMap.length, (index) {
      return AppToDo(
          title: toDoMap[index]['title'],
          isDone: toDoMap[index]['isDone'],
          id: toDoMap[index]['id'],
          taskId: toDoMap[index]['taskId']);
    });
  }
}
