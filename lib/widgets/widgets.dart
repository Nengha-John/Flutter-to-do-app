import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  TaskCard({required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.isEmpty ? '(Unnamed Task)' : title,
              style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Flexible(
                child: Text(
                    description.isEmpty
                        ? '(No description added)'
                        : description.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF86829D),
                      height: 1.5,
                    )),
              ),
            )
          ],
        ));
  }
}

class ToDo extends StatelessWidget {
  final String text;
  final bool isDone;
  ToDo({required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
                color: isDone ? Color(0xFF7349FE) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isDone
                    ? null
                    : Border.all(color: Color(0xFF86829D), width: 1.5)),
            child: Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Flexible(
            child: Text(
              text.isEmpty ? '(Unamed Activity)' : text,
              style: TextStyle(
                  fontSize: 16,
                  color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class noGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
