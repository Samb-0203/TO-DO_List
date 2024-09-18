import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/colors.dart';
import 'package:to_do_list_app/model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = ToDo.todosList();
  List<ToDo> _foundToDo = [];
  final TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Ensure the heading is aligned to the start (left)
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        padding: const EdgeInsets.only(
                            left: 15), // Add padding if needed
                        child: const Text(
                          'All ToDos List',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: _foundToDo.isNotEmpty
                            ? ListView(
                                children: [
                                  for (ToDo todoo in _foundToDo.reversed)
                                    TodoItem(
                                      todo: todoo,
                                      onToDoChange: _handleToDOChange,
                                      onDeleteItem: _deleteToDoItem,
                                    ),
                                ],
                              )
                            : const Center(
                                // Center the "No ToDos found!" message in the remaining space
                                child: Text(
                                  'No ToDos found!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 20, right: 20, left: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0)
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: todoController,
                            decoration: const InputDecoration(
                                hintText: 'Add a new todo item',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _addToDoItem(todoController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tdBlue,
                            minimumSize: const Size(60, 60),
                            elevation: 10,
                          ),
                          child: const Text(
                            '+',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDOChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String todoText) {
    if (todoText.isEmpty) {
      // Show error dialog when the text field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('To-Do item cannot be empty.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Add the new ToDo item if the text field is not empty
      setState(() {
        todosList.add(ToDo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            todoText: todoText));
      });
      todoController.clear(); // Clear the text field
    }
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
                'assets/images/user.png'), // Larger version of the image
          ),
        );
      },
    );
  }

  // SearchBox bar
  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints:
              BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 35,
          ),
          GestureDetector(
            onTap: () {
              _showImageDialog(context); // Call to show the image in a dialog
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/user.png'), // Image path
              ),
            ),
          ),
        ],
      ),
    );
  }
}
