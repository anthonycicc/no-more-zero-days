import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nomorezerodays/Entry.dart';
import 'package:nomorezerodays/FileLoader.dart';

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
    Entry(0, new DateTime.now(), "Made this!")
  ];
  FileLoader f = new FileLoader();

  List<Entry> _zerodayslist = new List<Entry>.from(_firstEntry);

  void _newEntry(DateTime date, String whatyoudid) {
    int highestID = 0;
    for (var i = 0; i < _zerodayslist.length; ++i) {
      if (_zerodayslist[i].id > highestID) {
        highestID = _zerodayslist[i].id;
      }
    }

    setState(
        () => _zerodayslist.add(new Entry(highestID + 1, date, whatyoudid)));

    _save();
  }

  void _removeEntry(Entry entry) {
    _zerodayslist.removeWhere((testEntry) => testEntry.id == entry.id);
    _save();
  }

  void _editEntry(Entry entry) {
    _removeEntry(entry);
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
                    if (newValue != null) {
                      setState(() {
                        _newEntry(newValue, entry.whatYouDid);
                      });
                    }
                    Navigator.pop(context);
                  }).catchError((err) {
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(content: new Text(err.toString())));
                  });
                }),
            new TextFormField(
              initialValue: entry.whatYouDid,
              onFieldSubmitted: (newValue) {
                setState(() {
                  _newEntry(entry.date, newValue);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return new Scaffold(
        appBar: new AppBar(title: new Text("Edit this entry")),
        body: t,
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              setState(() {
                _zerodayslist.remove(entry);
              });
              Navigator.pop(context);
            },
            child: new Icon(Icons.delete)),
      );
    }));
  }

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
            if (value != null) _newEntry(value, "nothing");
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

  void _save() {
    f.writeFile(json.encode(_zerodayslist));
  }

  void _load() {
    f.readFile().then((s) {
      setState(() {
        List<Entry> newList = <Entry>[];
        List<dynamic> tempList = json.decode(s);

        for (var i = 0; i < tempList.length; ++i) {
          newList.add(Entry.fromJson(tempList[i]));
        }
        _zerodayslist = newList;
      });
    });
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
      appBar: new AppBar(title: new Text(widget.title), actions: <Widget>[
        new IconButton(icon: new Icon(Icons.save), onPressed: _save),
        new IconButton(icon: new Icon(Icons.file_upload), onPressed: _load),
      ]),
      body: new Scaffold(body: new ListView.builder(
        itemBuilder: (context, entry) {
          f.checkForFile().then((value) {
            if (value) {
              _load();
            } else {
              f.writeFile("");
            }
          });

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
