import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../screens/note_detail.dart';
import '../screens/pin_screen.dart';
import '../screens/settings.dart';
import '../widgets/note.dart';
import '../utils/database_helper.dart';
import '../models/note.dart';
import '../models/config.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  List<Note> filteredList = [];
  Config config;
  bool isUnlocked = false;
  int count = 0;
  int horizontalAxis = 2;
  TextEditingController searchController;
  bool showSearch = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  void filterNotes(String val) {
    if (val != null && val != '') {
      List<Note> newList = List<Note>();
      this.noteList.map((e) {
        // filtering notes that contains the following value
        if (e.text.toString().contains(val)) {
          newList.add(e);
        }
      }).toList();
      setState(() {
        filteredList = newList;
      });
    } else {
      setState(() {
        filteredList = noteList;
      });
    }
  }

  // toggles the grid/list view
  List gridSee() {
    if (horizontalAxis == 4) {
      return [Icons.grid_off, 4];
    } else {
      return [Icons.grid_on, 2];
    }
  }

  Widget searchBar() {
    return showSearch
        ? Row(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.all(0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (String text) => filterNotes(text),
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      counterText: '',
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Monda',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    gridSee()[0],
                    size: 20,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (horizontalAxis == 2)
                        horizontalAxis = 4;
                      else
                        horizontalAxis = 2;
                    });
                  },
                ),
              ),
            ],
          )
        : Container(height: 0.0);
  }

  // I have no idea why this function exists
  List _getTileSize(List _notes) {
    List val = <StaggeredTile>[StaggeredTile.fit(4), StaggeredTile.fit(4)];
    for (int i = 0; i < _notes.length; i++) {
      val.add(StaggeredTile.fit(horizontalAxis));
    }
    val.add(StaggeredTile.fit(4));
    return val;
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: showSearch ? 10.0 : 0.0,
          left: 5.0,
          right: 5.0,
        ),
        child: StaggeredGridView.count(
          primary: false,
          crossAxisCount: 4,
          children: <Widget>[
            searchBar(),
            Container(
                padding: EdgeInsets.all(7),
                child: filteredList.length == 0
                    ? Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text('No Notes Found'),
                        ),
                      )
                    : null),
            // not the best practice!!! but gotta make use of the spread operator somehow
            ...(filteredList).map((note) {
              return InkWell(
                onTap: () {
                  navigateToDetail(note, 'Edit Note');
                },
                child: NoteWidget(
                  title: note.title,
                  text: note.text,
                  created: note.created,
                  modified: note.modified,
                  private: note.private,
                ),
              );
            }),
            Container(
              padding: EdgeInsets.all(20),
            ),
          ],
          staggeredTiles: _getTileSize(filteredList),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        onPressed: () {
          navigateToDetail(Note('', '', '', '', false), 'Add Note');
        },
        tooltip: 'New Note',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 4,
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: navigateToSettings,
            ),
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    showSearch ? showSearch = false : showSearch = true;
                  });
                }),
          ],
        ),
      ),
    );
  }

  // don't judge me for whats below... i'm lazy
  void navigateToSettings() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinScreen(secretFunc, config.pin),
      ),
    );
    if (isUnlocked) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(config),
        ),
      );
      isUnlocked = false;
    }
    if (result == true) {
      updateListView();
    }
  }

  void navigateToDetail(Note noteVal, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => noteVal.private
            ? PinScreen(secretFunc, config.pin)
            : DetailNote(noteVal, title),
      ),
    );
    if (isUnlocked) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailNote(noteVal, title),
        ),
      );
      isUnlocked = false;
    }
    if (result == true) {
      updateListView();
    }
  }

  void secretFunc(bool val) {
    isUnlocked = val;
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        // confusion 100
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          this.filteredList = this.noteList;
        });
      });
      Future<Config> configFuture = databaseHelper.getConfig();
      configFuture.then((value) {
        setState(() {
          this.config = value;
        });
      });
    });
  }
}
