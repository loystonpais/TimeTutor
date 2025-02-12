import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:timetutor/classes/classes.dart';

class TimetableCarousel extends StatefulWidget {
  final StandardTimeTable timetable;
  const TimetableCarousel({
    super.key,
    required this.timetable,
  });

  @override
  State<TimetableCarousel> createState() => _TimetableCarouselState();
}

class _TimetableCarouselState extends State<TimetableCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.timetable.days.asList
          .where((item) => item.$2.isNotEmpty)
          .map((item) {
        final (day, subjects) = item;
        return Column(
          children: [
            Text(day.name),
            CarouselSlider(
                items: List.generate(subjects.length, (index) {
                  return SizedBox(
                    width: 100,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        children: [
                          Text(
                            "${index + 1}/${subjects.length}",
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(subjects[index],
                              style: Theme.of(context).textTheme.headlineMedium)
                        ],
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    height: 90,
                    aspectRatio: 1,
                    viewportFraction: 0.35,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0,
                    scrollDirection: Axis.horizontal))
          ],
        );
      }).toList(),
    );
  }
}
