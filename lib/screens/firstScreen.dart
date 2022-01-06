import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_3_todo_local/model/task.dart';
import 'package:project_3_todo_local/widgets/tasksList.dart';
import 'package:project_3_todo_local/services/dbHelper.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Task> tasksList;
  static DatabaseHelper db = DatabaseHelper.instance;
  var isLoaded = false;

  void refreshData() {
    tasksList = [];
    try{
      db.queryAllRows().then((value) {
        value.forEach((element) {
          Task newTask =
          Task(name: element['name'], description: element['details']);
          tasksList.add(newTask);
        });
      }).then((value) {
        setState(() {
          isLoaded = true;
        });
      });
    } catch(e) {
      print("The error is ${e.toString()}");

    }
  }


  @override
  void initState() {
    refreshData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Text(
              'Your To-Do List',
              style: GoogleFonts.alata(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: (!isLoaded)? Center(child: Text('Loading')): (tasksList.length == 0)?Center(
          child: Image.asset("assets/empty.jpg"),
        ) : TasksList(tasksList, refreshData),
        floatingActionButton: FAB(refreshData));
  }
}

class FAB extends StatefulWidget {
  final x;
  FAB(this.x);
  @override
  _FABState createState() => _FABState();
}

class _FABState extends State<FAB> {
  bool isOpen = false;
  PersistentBottomSheetController _controller;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xFFEF848C),
      onPressed: () {
        setState(() {
          isOpen = !isOpen;
        });
        (isOpen)?
         _controller = showBottomSheet(
          context: context,
          builder: (ctx) {
            return Container(
              height: 400,
              child: TaskInput(widget.x),
            );
          },
        ) : Navigator.pop(context);
        _controller.closed.then((val){
          setState(() {
            isOpen = !isOpen;
          });
        });
      },
      child: Icon(
        !isOpen?Icons.add:Icons.close,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class TaskInput extends StatefulWidget {
  final x;
  TaskInput(this.x);
  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  String taskName;
  String taskDetails = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Add Task',
            style: GoogleFonts.alata(
              color: Colors.black,
              fontSize: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              validator: (val) {
                if(val.isEmpty) {
                  return "This field can not be empty";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter Task Name (Must)'
              ),
              onChanged: (val) {
                taskName = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              onChanged: (val) {
                taskDetails = val;
              },
              decoration: InputDecoration(
                  hintText: 'Enter Task Details (Optional)'
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FlatButton(
                color: Color(0xFFEF848C),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Add To List',
                          style: GoogleFonts.alata(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.add_circle_outline, color: Colors.white, size:  30,),
                      ],
                    ),
                  ),
                ),
                onPressed: (){
                  _FirstScreenState.db.insert({
                    'name' : taskName,
                    'details' : taskDetails
                  }).then((value) {
                  print('Task Added' , );
                  widget.x();
                  Navigator.pop(context);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
