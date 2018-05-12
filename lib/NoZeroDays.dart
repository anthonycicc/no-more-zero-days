import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nomorezerodays/Entry.dart';

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
        _editEntry(entry);
      },
      trailing: new Icon(Icons.edit),
    );
  }

  void _editEntry(Entry entry) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final t = new Form(
        child: new Column(
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.date_range),
                onPressed: () {
                  Future<DateTime> newDate = showDatePicker(
                      context: (context),
                      initialDate: entry.date,
                      firstDate: new DateTime(DateTime.now().year),
                      lastDate: new DateTime(DateTime.now().year + 1));
                  newDate.then((newValue) {
                    setState(() {
                      _zerodayslist.remove(entry);
                      _zerodayslist.add(new Entry(newValue, entry.whatYouDid));
                    });
                  });
                }),
            new TextFormField(
              initialValue: entry.whatYouDid,
              onFieldSubmitted: (newValue) {
                setState(() {
                  _zerodayslist.remove(entry);
                  _zerodayslist.add(new Entry(entry.date, newValue));
                });
              },
            ),
          ],
        ),
      );
      return new Scaffold(
        appBar: new AppBar(title: new Text("Edit this entry")),
        body: t,
        floatingActionButton: new FloatingActionButton(onPressed: () {
          setState(() {_zerodayslist.remove(entry); });
          Navigator.pop(context);
        },
        child: new Icon(Icons.delete)
        ),
      );
    }));
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
