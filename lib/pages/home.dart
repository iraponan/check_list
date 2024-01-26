import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _checkList = [];

  final TextEditingController _todoControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoControler,
                    decoration: const InputDecoration(
                      labelText: 'Nova Tarefa',
                      labelStyle: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: addTodo,
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _checkList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_checkList[index]['title']),
                  value: _checkList[index]['ok'],
                  secondary: CircleAvatar(
                    child: Icon(
                        _checkList[index]['ok'] ? Icons.check : Icons.error),
                  ),
                  onChanged: (check) {
                    setState(() {
                      _checkList[index]['ok'] = check;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo['title'] = _todoControler.text;
      _todoControler.text = '';
      newTodo['ok'] = false;
      _checkList.add(newTodo);
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_checkList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
