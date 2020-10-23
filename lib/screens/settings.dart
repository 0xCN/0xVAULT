import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import '../models/config.dart';
import '../utils/database_helper.dart';

class Settings extends StatefulWidget {
  final Config _config;
  Settings(this._config);
  @override
  _SettingsState createState() => _SettingsState(_config);
}

class _SettingsState extends State<Settings> {
  bool validatePin = false;
  TextEditingController _pinController = TextEditingController();
  TextEditingController _vaultdController = TextEditingController();
  TextEditingController _uniquedController = TextEditingController();
  TextEditingController _gistIdController = TextEditingController();
  TextEditingController _accessTokenController = TextEditingController();
  Config _config;
  _SettingsState(this._config);

  DatabaseHelper helper = DatabaseHelper();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    this._pinController.dispose();
    this._vaultdController.dispose();
    this._uniquedController.dispose();
    this._gistIdController.dispose();
    this._accessTokenController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._pinController.text = _config.pin;
    this._vaultdController.text = _config.vaultd;
    this._uniquedController.text = _config.uniqued;
    this._gistIdController.text = _config.gistId;
    this._accessTokenController.text = _config.accessToken;
  }

  void _validatePin() {
    if(_pinController.text.length > 0){
      setState(() {
        validatePin = false;
      });
      _saveDialog();
    }
    else{
      setState(() {
        validatePin = true;      
      });
    }
  }

  void _saveDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Some Changes Happened',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Do you want to save changes?',
              style:
                  TextStyle(fontFamily: 'Monda', fontWeight: FontWeight.w500),
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              FlatButton(
                  onPressed: () {
                    BotToast.showText(
                      text: 'Saved',
                      animationDuration: Duration(milliseconds: 200),
                      textStyle: TextStyle(
                        fontFamily: 'Monda',
                      ),
                    );
                    Navigator.pop(context, true);
                    _save();
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            children: [
              Container(
                height: validatePin?68:40,
                margin:
                    EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                child: TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  maxLines: 1,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Pin Code',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    counterText: '',
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                    errorText: validatePin ? 'Can\'t be empty' : null,
                    errorStyle: TextStyle(color: Theme.of(context).accentColor),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
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
                  ),
                  style: TextStyle(
                    fontFamily: 'Monda',
                    fontSize: 16,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 40,
                margin:
                    EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                child: TextField(
                  controller: _vaultdController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Vaultd Filename',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusColor: Theme.of(context).primaryColor,
                    counterText: '',
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 40,
                margin:
                    EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                child: TextField(
                  controller: _uniquedController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Unique Filename',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusColor: Theme.of(context).primaryColor,
                    counterText: '',
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: TextField(
                  controller: _gistIdController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Gist ID',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusColor: Theme.of(context).primaryColor,
                    counterText: '',
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                    fontSize: 16,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: TextField(
                  controller: _accessTokenController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Gist Access Token',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusColor: Theme.of(context).primaryColor,
                    counterText: '',
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                    fontSize: 16,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _validatePin(),
          tooltip: 'Save',
          child: Icon(Icons.save),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                onPressed: moveToLastScreen,
              ),
              Text('    Settings'),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Save data to database
  void _save() async {
    await helper.updateConfig(
      Config.withId(
        1,
        _gistIdController.text,
        _accessTokenController.text,
        _vaultdController.text,
        _uniquedController.text,
        _pinController.text,
      ),
    );
  }
}
