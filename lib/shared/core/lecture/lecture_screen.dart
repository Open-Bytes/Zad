import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/bottom_sheet/lecture_options_sheet.dart';
import '../../data/models/lecture.dart';

class LectureScreen extends StatefulWidget {
  final Lecture lecture;

  const LectureScreen(this.lecture, {super.key});

  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  double _fontSize = 16.0;
  Color _fontColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? _fontSize;
      _fontColor = Color(prefs.getInt('fontColor') ?? _fontColor.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LectureOptionsSheet(lecture: widget.lecture),
            ),
          ],
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(
            widget.lecture.title,
          ),
        ),
        body: screenView(context));
  }

  Widget screenView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: SelectableText(
          widget.lecture.details,
          style: TextStyle(fontSize: _fontSize, color: _fontColor),
          toolbarOptions: const ToolbarOptions(
            copy: true,
          ),
        ),
      ),
    );
  }
}