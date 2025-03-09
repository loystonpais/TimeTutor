import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'dart:async';

class TimetableCarouselSlider extends StatefulWidget {
  final StandardTimetable timetable;
  final CarouselOptions carouselOptions;
  final Duration updateDuration;
  final bool editable;
  final Function(StandardTimetable timetable) onEdit;

  TimetableCarouselSlider({
    super.key,
    required this.timetable,
    this.editable = false,
    required this.onEdit,
    CarouselOptions? carouselOptions,
    Duration? updateDuration,
  })  : carouselOptions = carouselOptions ??
            CarouselOptions(
              height: 100,
              aspectRatio: 16 / 9,
              viewportFraction: 0.4,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.1,
              scrollDirection: Axis.horizontal,
            ),
        updateDuration = updateDuration ?? Duration(seconds: 3);

  @override
  State<TimetableCarouselSlider> createState() =>
      _TimetableCarouselSliderState();
}

class _TimetableCarouselSliderState extends State<TimetableCarouselSlider> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.updateDuration, (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final TimeOfDay tod = TimeOfDay(hour: now.hour, minute: now.minute);

    final StandardTimetable timetable = widget.timetable;
    final dayWithPeriods = timetable.dayWithPeriods;
    final List<Period> currentDayPeriods =
        dayWithPeriods.getDayFromDateInt(now.weekday);
    final Day currentDay = now.weekday.toDay();

    final (
      :currentPeriod,
      :nextPeriod,
      :prevPeriod,
      :currentPeriodPos,
    ) = currentDayPeriods.calculatePeriodsFromTimeOfDay(tod);

    return Column(
      children: [
        // if no Sunday then add spacing to center the carousel
        if (dayWithPeriods.sunday.isEmpty) SizedBox(height: 30),
        Column(
          children: widget.timetable.dayWithPeriods.asList
              .where((item) => item.$2.isNotEmpty)
              .map((item) {
            final (day, periods) = item;
            return Column(
              children: [
                Text(
                  day.name,
                  style: TextStyle(
                    color: day == currentDay
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                ),
                PeriodCarouselSlider(
                  periods: periods,
                  highlightIndex: day == currentDay ? currentPeriodPos : null,
                  carouselOptions: widget.carouselOptions,
                  editable: widget.editable,
                  onEdit: (period) {},
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// A stateless widget to display a carousel of periods for a specific day.
class PeriodCarouselSlider extends StatelessWidget {
  final List<Period> periods;
  final int? highlightIndex;
  final CarouselOptions carouselOptions;
  final bool editable;
  final Function(Period newPeriod) onEdit;

  const PeriodCarouselSlider({
    super.key,
    required this.periods,
    required this.carouselOptions,
    required this.editable,
    required this.onEdit,
    this.highlightIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: List.generate(periods.length, (index) {
        return SizedBox(
          width: 100,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Material(
              child: InkWell(
                onDoubleTap: () async {
                  if (!editable) return;
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Period period = periods[index];
                      String name = period.subject.name;
                      return AlertDialog(
                        title: Text("Edit period subject"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              initialValue: name,
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Period newPeriod = Period(
                                    subject: Subject(name: name),
                                    timing: period.timing);
                                onEdit(newPeriod);
                                Navigator.pop(context);
                              },
                              child: Text("Save"),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Text(
                        "${index + 1}/${periods.length}",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        periods[index].subject.name,
                        style:
                            (highlightIndex != null && index == highlightIndex)
                                ? Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    shadows: [
                                      Shadow(
                                        color: Theme.of(context).primaryColor,
                                        blurRadius: 10,
                                      )
                                    ],
                                  )
                                : Theme.of(context).textTheme.headlineMedium!,
                      ),
                      Text(
                        periods[index].timing.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
      options: carouselOptions,
    );
  }
}
