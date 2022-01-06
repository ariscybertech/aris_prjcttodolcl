import 'package:flutter/material.dart';
import 'package:project_3_todo_local/model/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_3_todo_local/services/dbHelper.dart';

class TasksList extends StatefulWidget {
  final List<Task> tasksList;
  final refreshData;
  TasksList(this.tasksList, this.refreshData);
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  DatabaseHelper db = DatabaseHelper.instance;
  TextStyle txtStyle = GoogleFonts.alata(
    color: Colors.black,
    fontSize: 25,
  );
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasksList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height * .1,
          child: Dismissible(
            onDismissed: (direction) async {
              db.deleteTask(widget.tasksList[index].name).then((value) {
                widget.refreshData();
              });
            },
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
              child: Row(
                children: [
                  SizedBox(width: 15,),
                  Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 15,)
                ],
              ),
            ),
            key: ObjectKey(widget.tasksList[index]),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                  ),
                  Text(widget.tasksList[index].name, style: txtStyle),
                  (widget.tasksList[index].description.isEmpty)
                      ? Text("There is no description")
                      : Text(widget.tasksList[index].description),
                ],
              ),
              elevation: 20,
            ),
          ),
        );
      },
    );
  }
}
