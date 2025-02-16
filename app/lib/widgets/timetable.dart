import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/globals.dart';

class TimetableCarousel extends StatefulWidget {
  final StandardTimeTable timetable;
  final CarouselOptions carouselOptions;
  final bool editable;
  final Function(Map<String, dynamic> editedJson) onEdit;

  TimetableCarousel({
    super.key,
    required this.timetable,
    this.editable = false,
    required this.onEdit,
    CarouselOptions? carouselOptions,
  }) : carouselOptions = carouselOptions ??
            CarouselOptions(
                height: 100,
                aspectRatio: 16 / 9,
                viewportFraction: 0.4,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(
                  milliseconds: 800,
                ),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.1,
                scrollDirection: Axis.horizontal);

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
                      child: Material(
                        // onPressed: () {},
                        child: InkWell(
                          onDoubleTap: () async {
                            if (!widget.editable) return;

                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Edit subject"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          initialValue: subjects[index].name,
                                          onChanged: (value) {
                                            subjects[index] =
                                                Subject(name: value);
                                            logger.d(value);
                                          },
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            widget.onEdit(
                                                widget.timetable.toJson());
                                            Navigator.pop(context);
                                          },
                                          child: Text("Save"),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Text(
                                  "${index + 1}/${subjects.length}",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  subjects[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                options: widget.carouselOptions)
          ],
        );
      }).toList(),
    );
  }
}
