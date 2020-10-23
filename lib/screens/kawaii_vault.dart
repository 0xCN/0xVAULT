import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart';
import 'package:bot_toast/bot_toast.dart';

import '../models/config.dart';

const Cipher aesGcm = AesGcm();

class PasswordManager extends StatefulWidget {
  final password;
  final String encryptedContent;
  final String uniqueValue;
  final String uname;
  final String userId;
  final String plaintext;
  final Config _config;
  PasswordManager(this._config, this.plaintext, this.password,
      this.encryptedContent, this.uniqueValue, this.uname, this.userId);
  @override
  _PasswordManagerState createState() => _PasswordManagerState(
        password,
        encryptedContent,
        uniqueValue,
        uname,
        userId,
      );
}

class _PasswordManagerState extends State<PasswordManager> {
  TextEditingController vaultController = TextEditingController();
  String encryptedContent;
  String uniqueValue;
  String uname;
  String userId;
  String key;
  bool loading = true;
  final cipher = aesGcm;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  _PasswordManagerState(this.key, this.encryptedContent, this.uniqueValue,
      this.uname, this.userId);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    vaultController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = false;
      vaultController.text = widget.plaintext;
    });
  }

  String getRandomString() {
    return String.fromCharCodes(
      Iterable.generate(
        12,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );
  }

  String genPassword() {
    return String.fromCharCodes(
      Iterable.generate(
        15,
        (_) => '$_chars\$%^&*()#@!.;lk?_-'
            .codeUnitAt(_rnd.nextInt('$_chars\$%^&*()#@!.;lk?_-'.length)),
      ),
    );
  }

  Future encrypt() async {
    final secretKey = SecretKey(utf8.encode(key));
    final nonce = Nonce(utf8.encode(uniqueValue));
    final encrypted = await cipher.encrypt(
      utf8.encode(vaultController.text),
      secretKey: secretKey,
      nonce: nonce,
    );
    setState(() {
      encryptedContent = base64.encode(encrypted);
    });
  }

  Future decrypt() async {
    final secretKey = SecretKey(utf8.encode(key));
    final nonce = Nonce(utf8.encode(uniqueValue));
    final decrypted = await cipher
        .decrypt(
          base64.decode(encryptedContent),
          secretKey: secretKey,
          nonce: nonce,
        )
        .catchError(
          (_) => BotToast.showText(
            text: 'Incorrect Password',
            animationDuration: Duration(milliseconds: 200),
            textStyle: TextStyle(
              fontFamily: 'Monda',
            ),
          ),
        );
    setState(() {
      vaultController.text = utf8.decode(decrypted);
    });
  }

  Future getGist() async {
    String url = 'https://api.github.com/gists/${widget._config.gistId}';
    Map<String, String> header = {
      'Authorization': 'token ${widget._config.accessToken}'
    };
    Response response = await get(url, headers: header);
    var jsonRes = json.decode(response.body);
    setState(() {
      uniqueValue = jsonRes['files']['${widget._config.uniqued}']['content'];
      encryptedContent =
          jsonRes['files']['${widget._config.vaultd}']['content'];
      uname = jsonRes['owner']['login'];
      userId = jsonRes['owner']['id'].toString();
    });
  }

  Future updateGist() async {
    String url = 'https://api.github.com/gists/${widget._config.gistId}';
    Map<String, String> header = {
      'Authorization': 'token ${widget._config.accessToken}'
    };
    Map body = {
      'files': {
        '${widget._config.uniqued}': {'content': '$uniqueValue'},
        '${widget._config.vaultd}': {'content': '$encryptedContent'}
      }
    };
    Response response =
        await patch(url, headers: header, body: json.encode(body));
    var jsonRes = json.decode(response.body);
    setState(() {
      uniqueValue = jsonRes['files']['${widget._config.uniqued}']['content'];
      encryptedContent =
          jsonRes['files']['${widget._config.vaultd}']['content'];
      uname = jsonRes['owner']['login'];
      userId = jsonRes['owner']['id'].toString();
    });
  }

  void updateAll() async {
    setState(() {
      loading = true;
      uniqueValue = getRandomString();
    });
    await encrypt();
    await updateGist();
    await decrypt();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            loading
                ? Container(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Loading',
                      style: TextStyle(fontSize: 20, fontFamily: 'Monda'),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: vaultController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        hintText: 'Kawaii Vault (>"-")>',
                        hintStyle: TextStyle(
                          fontFamily: 'Monda',
                          fontSize: 20,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Monda',
                        fontSize: 16,
                      ),
                    ),
                  ),
            Container(padding: EdgeInsets.all(15))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateAll,
        child: Icon(Icons.save),
        heroTag: 'save',
      ),
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
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                '    In Vault    ',
                style: TextStyle(
                  fontFamily: 'Monda',
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.code,
                ),
                onPressed: () {
                  String text = vaultController.text;
                  TextSelection textSelection = vaultController.selection;
                  String newText = text.replaceRange(
                    textSelection.start,
                    textSelection.end,
                    genPassword(),
                  );
                  vaultController.text = newText;
                  vaultController.selection = textSelection.copyWith(
                    baseOffset: textSelection.start + 15,
                    extentOffset: textSelection.start + 15,
                  );
                },
              )
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
