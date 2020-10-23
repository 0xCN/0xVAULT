import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:bot_toast/bot_toast.dart';

class PinScreen extends StatefulWidget {
  final Function updateView;
  final String pin;
  PinScreen(this.updateView, this.pin);
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'ENTER PIN CODE',
                    style: TextStyle(
                      fontFamily: 'Monda',
                      fontSize: 18,
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: PinPut(
                        obscureText: '*',
                        textStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                        fieldsAlignment: MainAxisAlignment.center,
                        eachFieldMargin: EdgeInsets.only(left: 4, right: 4),
                        fieldsCount: widget.pin.length,
                        onSubmit: (String pin) =>
                            _validatePinCode(pin, context),
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        selectedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        onPressed: null,
        tooltip: "Locked",
        child: Icon(Icons.lock),
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
            Text('    Locked'),
          ],
        ),
      ),
    );
  }

  void _validatePinCode(String pin, BuildContext context) {
    if (pin == widget.pin) {
      BotToast.showText(
        text: 'Unlocked',
        animationDuration: Duration(milliseconds: 200),
        textStyle: TextStyle(
          fontFamily: 'Monda',
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      widget.updateView(true);
    } else {
      BotToast.showText(
        text: 'Incorrect Pin',
        animationDuration: Duration(milliseconds: 200),
        textStyle: TextStyle(
          fontFamily: 'Monda',
        ),
      );
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

}
