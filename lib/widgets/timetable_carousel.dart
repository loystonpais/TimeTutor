import 'package:carousel_slider/carousel_slider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'dart:async';

class TimetableCarouselSlider extends StatefulWidget {
  final DateTime Function() time;
  final StandardTimetable timetable;
  final CarouselOptions? carouselOptions;
  final Duration updateDuration;
  final bool editable;
  final bool currentDayOnly;
  final bool showDayName;
  final String Function(Day) dayName;
  final Function(StandardTimetable timetable) onEdit;

  TimetableCarouselSlider({
    super.key,
    DateTime Function()? time,
    required this.timetable,
    this.editable = false,
    required this.onEdit,
    this.currentDayOnly = false,
    this.showDayName = true,
    this.carouselOptions,
    String Function(Day)? dayName,
    Duration? updateDuration,
  })  : updateDuration = updateDuration ?? Duration(seconds: 3),
        time = time ?? (() => DateTime.now()),
        dayName = dayName ?? ((day) => day.name.capitalize);

  @override
  State<TimetableCarouselSlider> createState() => _TimetableCarouselSliderState();
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
    final DateTime now = widget.time();
    final TimeOfDay tod = TimeOfDay(hour: now.hour, minute: now.minute);

    final StandardTimetable timetable = widget.timetable;
    final dayWithPeriods = timetable.dayWithPeriods;
    final List<Period> currentDayPeriods = dayWithPeriods.getDayFromDateInt(now.weekday);
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
              .where((item) => item.$2.isNotEmpty && (widget.currentDayOnly ? item.$1 == currentDay : true))
              .map((item) {
            final (day, periods) = item;
            return Column(
              children: [
                if (widget.showDayName)
                  Text(
                    widget.dayName(day),
                    style: TextStyle(
                      color: day == currentDay ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                PeriodCarouselSlider(
                  periods: periods,
                  highlightPeriod: day == currentDay ? currentPeriod : null,
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

class PeriodCarouselSlider extends StatefulWidget {
  final DateTime Function() time;

  final List<Period> periods;
  final Period? highlightPeriod;
  final CarouselOptions carouselOptions;
  final bool editable;
  final Function(Period newPeriod) onEdit;

  PeriodCarouselSlider({
    super.key,
    required this.periods,
    DateTime Function()? time,
    CarouselOptions? carouselOptions,
    required this.editable,
    required this.onEdit,
    this.highlightPeriod,
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
        time = time ?? (() => DateTime.now());

  @override
  State<PeriodCarouselSlider> createState() => _PeriodCarouselSliderState();
}

class _PeriodCarouselSliderState extends State<PeriodCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: List.generate(widget.periods.length, (index) {
        return SizedBox(
          width: 100,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Material(
              child: InkWell(
                onDoubleTap: () async {
                  if (!widget.editable) return;

                  Period period = widget.periods[index];
                  TextEditingController nameController = TextEditingController(text: period.subject.name);

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Edit Period"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(labelText: "Subject Name"),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty) {
                                  Period updatedPeriod = Period(
                                    subject: Subject(name: nameController.text.trim()),
                                    timing: period.timing,
                                  );

                                  setState(() {
                                    widget.periods[index] = updatedPeriod;
                                  });

                                  widget.onEdit(updatedPeriod);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    children: [
                      Text(
                        "${index + 1}/${widget.periods.length}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        widget.periods[index].subject.name,
                        style: (widget.highlightPeriod != null && widget.periods[index] == widget.highlightPeriod)
                            ? Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                        widget.periods[index].timing.toString(),
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
      options: widget.carouselOptions,
    );
  }
}
