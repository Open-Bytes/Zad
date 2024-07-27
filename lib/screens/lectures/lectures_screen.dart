import 'package:flutter/material.dart';
import 'package:zad/screens/bottom_sheet/lecture_options_sheet.dart';

import '../../shared/core/lecture/lecture_screen.dart';
import '../../shared/data/models/lecture.dart';
import '../../shared/presentation/navigate_to.dart';

class LecturesScreen extends StatelessWidget {
  final List<Lecture> lectures;
  final String title;

  const LecturesScreen({
    super.key,
    required this.lectures,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(title),
      ),
      body: ListView.separated(
        itemCount: lectures.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: itemView(
              context,
              lectures[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20.0,
              end: 20.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget itemView(BuildContext context, Lecture item) {
    return TextButton(
      onPressed: () {
        navigate(
          LectureScreen(item),
        );
      },
      child: Container(
        alignment: Alignment.bottomRight,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Text(
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                    ),
                    item.contentWithoutLines(),
                    maxLines: 5,
                  )
                ],
              ),
            ),
            LectureOptionsSheet(lecture: item),
          ],
        ),
      ),
    );
  }
}
