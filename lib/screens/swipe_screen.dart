import 'package:flutter/material.dart';

import './note_list.dart';
import './password_screen.dart';


class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        MyHomePage(title: 'I want to sleep and never wake up'),
        PwdScreen(),
      ],
    );
  }
}