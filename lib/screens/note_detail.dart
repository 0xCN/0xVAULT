import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import '../models/note.dart';
import '../utils/database_helper.dart';


class DetailNote extends StatefulWidget {
  final Note note;
  final String title;
  DetailNote(this.note, this.title);
  @override
  _DetailNoteState createState() => _DetailNoteState(this.note);
}

class _DetailNoteState extends State<DetailNote> {
  TextEditingController titleController;
  TextEditingController bodyController;
  bool validateTitle = false;
  bool validateBody = false;
  String modifiedTime;
  String createdTime;
  int id;
  bool privateCheck;
  Note note;
  
  _DetailNoteState(this.note);
  DatabaseHelper helper = DatabaseHelper();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: note.title,
    );
    bodyController = TextEditingController(
      text: note.text,
    );
    modifiedTime = note.modified;
    createdTime = note.created;
    id = note.id;
    privateCheck = note.private;
  }

  String appTitleDecider() {
    if (note.id == null) {
      return 'New Note';
    } else {
      return 'Editing Note';
    }
  }

  List<Widget> indexIsNull() {
    if (note.id == null) {
      return [
        Column(
          children: [
            SizedBox(
              child: null,
              height: 10,
            ),
            SizedBox(
              height: 20,
              child: Checkbox(
                value: privateCheck, //checkedValue
                activeColor: Theme.of(context).primaryColorDark,
                onChanged: (newValue) {
                  setState(() {
                    privateCheck = newValue;
                  });
                },
              ),
            ),
            Text(
              'SECRET',
              style: TextStyle(
                fontFamily: 'Monda',
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ];
    } else {
      return [
        Column(
          children: [
            SizedBox(
              child: null,
              height: 10,
            ),
            SizedBox(
              height: 20,
              child: Checkbox(
                activeColor: Theme.of(context).primaryColorDark,
                value: privateCheck, //checkedValue
                onChanged: (newValue) {
                  setState(() {
                    privateCheck = newValue;
                  });
                },
              ),
            ),
            Text(
              'SECRET',
              style: TextStyle(
                fontFamily: 'Monda',
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          timeStuff(),
          style: TextStyle(
            fontFamily: 'Monda',
            fontSize: 13,
          ),
          textAlign: TextAlign.start,
        ),
      ];
    }
  }

  String timeStuff() {
    String lol = '';
    if (createdTime != null && createdTime != '')
      lol += 'Created: ${createdTime.substring(0, 16)} \n';
    if (modifiedTime != null && modifiedTime != '')
      lol += 'Modified: ${modifiedTime.substring(0, 16)}';
    return lol;
  }

  void _deleteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Note Deletion',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Do you want to delete this note?',
              style:
                  TextStyle(fontFamily: 'Monda', fontWeight: FontWeight.w500),
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              FlatButton(
                  onPressed: () {
                    BotToast.showText(
                      text: 'Deleted',
                      animationDuration: Duration(milliseconds: 200),
                      textStyle: TextStyle(
                        fontFamily: 'Monda',
                      ),
                    );
                    Navigator.pop(context, true);
                    if (note.id != null) _delete();
                  },
                  child: Text('Yes')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToLastScreen();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          elevation: 4,
          notchMargin: 4.0,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => moveToLastScreen(),
                ),
                Text(
                  '    ${appTitleDecider()}    ',
                  style: TextStyle(
                    fontFamily: 'Monda',
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                  ),
                  onPressed: () {
                    _deleteDialog();
                  },
                )
              ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            children: [
              Container(
                height: validateTitle?68:40,
                margin: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                padding: EdgeInsets.all(0),
                child: TextField(
                  controller: titleController,
                  maxLength: 15,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    errorText: validateTitle ? 'Can\'t be empty' : null,
                    errorStyle: TextStyle(color: Theme.of(context).accentColor),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    counterText: '',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Monda',
                    fontSize: 18,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 14, right: 14),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: bodyController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    errorStyle: TextStyle(color: Theme.of(context).accentColor),
                    hintText: 'Note',
                    hintStyle: TextStyle(
                      fontFamily: 'Monda',
                      fontSize: 16,
                    ),
                    errorText: validateBody ? 'Can\'t be empty' : null,
                  ),
                  style: TextStyle(
                    fontFamily: 'Monda',
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 60,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: indexIsNull(),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) {
              setState(() {
                validateTitle = true;
              });
            } else if (bodyController.text.trim().isEmpty) {
              setState(() {
                validateBody = true;
              });
            } else {
              setState(() {
                validateTitle = false;
                validateBody = false;
              });

              note.title = titleController.text;
              note.text = bodyController.text;
              note.created = createdTime;
              note.modified = note.modified;
              note.private = privateCheck;

              String now = DateTime.now().toString();
              if (note.id == null) {
                setState(() {
                  createdTime = now;
                });
                note.created = now;
              } else {
                setState(() {
                  modifiedTime = now;
                });
                note.modified = now;
              }
              _save();
              BotToast.showText(
                text: 'Saved',
                animationDuration: Duration(milliseconds: 200),
                textStyle: TextStyle(
                  fontFamily: 'Monda',
                ),
              );
            }
          },
          tooltip: 'Save',
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Save data to database
  void _save() async {
    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      moveToLastScreen();
      await helper.insertNote(note);
    }
  }

  void _delete() async {
    moveToLastScreen();
    await helper.deleteNote(note.id);
  }
}
