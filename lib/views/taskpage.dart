import 'package:flutter/material.dart';
import 'package:to_do_app/database/database.dart';
import 'package:to_do_app/widgets/models/task.dart';
import 'package:to_do_app/widgets/models/todo.dart';
import 'package:to_do_app/widgets/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  TaskPage({this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = '';
  int? _taskId = 0;
  String? _taskDescription = '';
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  bool _contentVisible = false;
  AppDatabase _db = AppDatabase();
  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task!.title;
      _taskId = widget.task!.id;
      _taskDescription = widget.task!.description;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    print(widget.task);
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 6.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png')),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        focusNode: _titleFocus,
                        controller: TextEditingController()..text = _taskTitle,
                        onSubmitted: (val) async {
                          print(val);
                          if (val.isNotEmpty) {
                            if (widget.task == null) {
                              try {
                                AppDatabase _db = AppDatabase();

                                Task _newtask = Task(title: val);

                                _taskId = await _db.insertTask(_newtask);
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = val;
                                });
                                print(_taskId);
                                print('New Task Added');
                              } catch (e) {
                                print(e.toString());
                                print('Insertin failed');
                              }
                            } else {
                              print('Update existing task');
                              await _db.updateTitle(_taskId!, val);
                              print('Updated Succesfully');
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter Task title',
                            border: InputBorder.none),
                        style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211511)),
                      ))
                    ],
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      controller: TextEditingController()
                        ..text = _taskDescription!,
                      focusNode: _descriptionFocus,
                      decoration: InputDecoration(
                          hintText: 'Enter description for the Task',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(24)),
                      onSubmitted: (val) {
                        if (val != '') {
                          if (_taskId != 0) {
                            AppDatabase db = AppDatabase();
                            db.updateDescrip(_taskId!, val);
                          }
                        }
                        _todoFocus.requestFocus();
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Expanded(
                      child: FutureBuilder(
                          initialData: [],
                          future: _db.getToDos(_taskId),
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () async {
                                        //Complete task
                                        if (snapshot.data[index].isDone == 0) {
                                          await _db
                                              .updateiSDone(
                                                  snapshot.data[index].id, 1)
                                              .then((value) {
                                            setState(() {});
                                          });
                                          print('changed');
                                        } else {
                                          await _db
                                              .updateiSDone(
                                                  snapshot.data[index].id, 0)
                                              .then((value) {
                                            setState(() {});
                                          });
                                          print('changed');
                                        }
                                      },
                                      child: ToDo(
                                        text: snapshot.data[index].title,
                                        isDone: snapshot.data[index].isDone == 0
                                            ? false
                                            : true,
                                      ),
                                    ));
                          })),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              height: 20.0,
                              width: 20.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Color(0xFF86829D), width: 1.5)),
                              child: Image(
                                image:
                                    AssetImage('assets/images/check_icon.png'),
                              ),
                            ),
                            Expanded(
                                child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = '',
                              onSubmitted: (val) async {
                                if (val != '') {
                                  if (_taskId != 0) {
                                    AppToDo todo = AppToDo(
                                        title: val, isDone: 0, taskId: _taskId);
                                    await _db.insertToDo(todo).then((value) {
                                      setState(() {});
                                    });
                                    print('To do added');
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter To Do Activity',
                                border: InputBorder.none,
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      await _db.deleteTask(_taskId).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20)),
                    child: Image(
                      image: AssetImage('assets/images/delete_icon.png'),
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
