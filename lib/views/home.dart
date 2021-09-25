import 'package:flutter/material.dart';
import 'package:to_do_app/database/database.dart';
import 'package:to_do_app/views/taskpage.dart';
import 'package:to_do_app/widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppDatabase db = AppDatabase();
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 32, top: 32),
                    child: Image(image: AssetImage('assets/images/logo.png'))),
                Expanded(
                  child: ScrollConfiguration(
                      behavior: noGlow(),
                      child: FutureBuilder(
                          initialData: [],
                          future: db.getTasks(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TaskPage(
                                                    task: snapshot.data[index],
                                                  ))).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: TaskCard(
                                      title: snapshot.data[index].title,
                                      description:
                                          snapshot.data[index].description ??
                                              'No description',
                                    ),
                                  );
                                });
                          })),
                )
              ],
            ),
            Positioned(
              bottom: 24.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TaskPage()))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FD8)],
                          begin: Alignment(0.0, -1),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Image(
                    image: AssetImage('assets/images/add_icon.png'),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
