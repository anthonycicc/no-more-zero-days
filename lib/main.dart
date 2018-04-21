import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nomorezerodays/Entry.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'No More Zero Days!',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(body: new NoZeroDays(title: 'No Zero Days!')));
  }
}

class NoZeroDays extends StatefulWidget {
  NoZeroDays({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _NoZeroDaysState createState() => new _NoZeroDaysState();
}

class _NoZeroDaysState extends State<NoZeroDays> {
  static List<Entry> _firstEntry = <Entry>[
    Entry(new DateTime.now(), "Made this!")
  ];
  List<Entry> _zerodayslist = new List<Entry>.from(_firstEntry);

  Future<DateTime> _currentDatePicker() {
    int currentYear = new DateTime.now().year;
    return showDatePicker(
        context: (context),
        initialDate: new DateTime.now(),
        firstDate: new DateTime(currentYear),
        lastDate: new DateTime(currentYear + 1));
  }

  Widget _buildFAB() {
    return new FloatingActionButton(
      onPressed: () {
        Future<DateTime> pickedDate = _currentDatePicker();
        pickedDate.then((value) {
          setState(() {
            if (value != null) _zerodayslist.add(Entry(value, "nothing"));
          });
        }).catchError((err) {
          Scaffold
              .of(context)
              .showSnackBar(new SnackBar(content: new Text(err.toString())));
        });
      },
      tooltip: 'Make a new entry',
      child: new Icon(Icons.add),
    );
  }

  Widget _buildRow(Entry entry) {
    return new ListTile(
      title: new Text(entry.toString()),
      onTap: () {
        //edit entry
      },
      trailing: new Icon(Icons.edit),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Scaffold(body: new ListView.builder(
        itemBuilder: (context, entry) {
          if (entry < _zerodayslist.length) {
            return _buildRow(_zerodayslist[entry]);
          } else
            return new ListTile();
        },
      )),
      floatingActionButton: _buildFAB(),
    );
  }
}
