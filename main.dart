import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(title: 'To-Do List'),
    );
  }
}

class ToDoList extends StatefulWidget {
  String title;

  ToDoList({Key? key, required this.title}) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<String> _tasks = [];
  List<bool> _completed = [];
  bool _showCompleted = true;

  void _addTask(String task) {
    setState(() {
      if (task.isNotEmpty) {
        _tasks.add(task);
        _completed.add(false); // Initialize completed status to false
      }
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _completed.removeAt(index);
    });
  }

  void _toggleCompleted(int index) {
    setState(() {
      _completed[index] = !_completed[index];
    });
  }

  void _toggleShowCompleted() {
    setState(() {
      _showCompleted = !_showCompleted;
    });
  }

  void _renameList() {
    String newListName = widget.title; // Initialize with current title
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename List'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newListName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.title = newListName; // Update the title
                });
                Navigator.of(context).pop();
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 100.0), // Shift PopupMenuButton to the left
            child: PopupMenuButton<String>(
              onSelected: (String result) {
                switch (result) {
                  case 'Rename List':
                    _renameList();
                    break;
                  case 'Show Completed Tasks':
                    _toggleShowCompleted();
                    break;
                  case 'Hide Completed Tasks':
                    _toggleShowCompleted();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Rename List',
                  child: Text('Rename List'),
                ),
                PopupMenuItem<String>(
                  value: 'Show Completed Tasks',
                  child: Text('Show Completed Tasks'),
                ),
                PopupMenuItem<String>(
                  value: 'Hide Completed Tasks',
                  child: Text('Hide Completed Tasks'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          if (!_showCompleted && _completed[index]) {
            return SizedBox.shrink(); // Hide completed tasks if not showing
          }
          return ListTile(
            title: Text(
              _tasks[index],
              style: _completed[index]
                  ? TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeTask(index);
              },
            ),
            onTap: () {
              _toggleCompleted(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newTask = '';
              return AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        newTask = value;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addTask(newTask);
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
