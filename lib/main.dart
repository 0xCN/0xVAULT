import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import './screens/swipe_screen.dart';

/*
  to fix:
  - code that completely ignores flutters best practices, like:
    - not splitting the code into small widgets....
  - some shitty logic here n there
  - animations
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      title: '0xVAULT',
      theme: ThemeData(
        // i'm color blind
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        accentColor: Color.fromRGBO(224, 123, 224, 1),
        primaryColorDark: Color.fromRGBO(94, 221, 152, 1),
        bottomAppBarColor: Color.fromRGBO(22, 23, 32, 1),
        fontFamily: 'Monda',
        cardColor: Color.fromRGBO(61, 65, 74, 1),
        unselectedWidgetColor: Colors.grey,
        scaffoldBackgroundColor: Color.fromRGBO(42, 45, 54, 1), 
      ),
      home: SwipeScreen(),
    );
  }
}