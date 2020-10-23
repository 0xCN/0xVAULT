import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

import './kawaii_vault.dart';
import '../models/config.dart';
import '../utils/database_helper.dart';

const Cipher aesGcm = AesGcm();

class PwdScreen extends StatefulWidget {
  @override
  _PwdScreenState createState() => _PwdScreenState();
}

class _PwdScreenState extends State<PwdScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController _passwordController = TextEditingController();
  String _encryptedContent;
  String _uniqueValue;
  String uname = '';
  String userId = '';
  String _plaintext;
  Config _config;

  final cipher = aesGcm;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getConf();
  }

  @override
  setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // because md5 is really *secure*
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void getConf() async {
    Config configFuture = await databaseHelper.getConfig();
    setState(() {
      this._config = configFuture;
    });
    getGist();
  }

  void getGist() async {
    if (_config != null) {
      String url = 'https://api.github.com/gists/${_config.gistId}';
      Map<String, String> header = {
        'Authorization': 'token ${_config.accessToken}'
      };

      Response response = await get(url, headers: header);
      var jsonRes = json.decode(response.body);
      if (!response.body.toString().contains('Bad credentials')) {
        setState(() {
          _uniqueValue = jsonRes['files']['${_config.uniqued}']['content'];
          _encryptedContent = jsonRes['files']['${_config.vaultd}']['content'];
          uname = jsonRes['owner']['login'];
          userId = jsonRes['owner']['id'].toString();
        });
      } else {
        BotToast.showText(
          text: 'Bad credentials',
          animationDuration: Duration(milliseconds: 200),
          textStyle: TextStyle(
            fontFamily: 'Monda',
          ),
        );
      }
    }
  }

  void decrypt(val1) {
    getGist();
    final secretKey = SecretKey(utf8.encode(generateMd5(val1.text)));
    final nonce = Nonce(utf8.encode(_uniqueValue));
    final decrypted = cipher.decrypt(
      base64.decode(_encryptedContent),
      secretKey: secretKey,
      nonce: nonce,
    );
    decrypted.then((value) {
      setState(() {
        _plaintext = utf8.decode(value);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordManager(
            _config,
            _plaintext,
            generateMd5(val1.text),
            _encryptedContent,
            _uniqueValue,
            uname,
            userId,
          ),
        ),
      );
    }).catchError(
      // error handling 10/10 as you can see
      (value) => BotToast.showText(
        text: 'Incorrect Password',
        animationDuration: Duration(milliseconds: 200),
        textStyle: TextStyle(
          fontFamily: 'Monda',
        ),
      ),
    );
  }

  bool isPortrait() {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  @override
  Widget build(BuildContext context) {
    bool isPort = isPortrait();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPort
                ? Text(
                    '(づ｡◕‿‿◕｡)づ',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'roboto',
                      color: Theme.of(context).primaryColorDark,
                    ),
                  )
                : Container(),
            isPort
                ? Text(
                    'Kawaii Vault',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Monda',
                    ),
                  )
                : Container(),
            isPort
                ? Container(
                    padding: EdgeInsets.only(top: 30),
                  )
                : Container(),
            Container(
              height: 40,
              child: TextField(
                controller: _passwordController,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
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
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => _passwordController.text = '',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Monda',
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                getConf();
              },
              child: Text(
                uname != '' ? 'online - $uname' : 'offline',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            FlatButton(
              onPressed: () => decrypt(_passwordController),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  'Decrypt',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Monda',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
