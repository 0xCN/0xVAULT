import 'package:flutter/material.dart';

class NoteWidget extends StatelessWidget {
  final title;
  final text;
  final created;
  final modified;
  final private;

  NoteWidget({this.title, this.text, this.modified, this.created, this.private});

  String displayString(val) {
    String temp = val.replaceAll('\n', '  ');
    int count = temp.length;
    if (count <= 200)
      return temp;
    else
      return temp.substring(0, 200) + '...';
  }

  String displayDate() {
    Map week = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun'
    };
    String time = '';
    if (this.modified != '' && this.modified != null)
      time = this.modified;
    else
      time = this.created;

    return '${week[DateTime.parse(time).weekday]} ${DateTime.parse(time).day}/${DateTime.parse(time).month}/${DateTime.parse(time).year}';
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 40,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '$title',
                        style: TextStyle(
                          fontFamily: 'Monda',
                          fontSize: 18,
                          height: 1.6,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: this.private
                          ? Padding(
                              padding: EdgeInsets.all(7),
                              child: Text(
                                'ENCRYPTED',
                                style: TextStyle(
                                    fontFamily: 'Monda',
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Text(
                              '${displayString(text)}',
                              style: TextStyle(
                                fontFamily: 'Monda',
                                height: 1.35,
                              ),
                              textAlign: TextAlign.left,
                            ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      displayDate(),
                      style: TextStyle(
                        fontFamily: 'Monda',
                        fontSize: 10,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
              ])
            ],
          ),
        ),
        elevation: 1,
      ),
    );
  }
}
