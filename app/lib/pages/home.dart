import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/timetable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client.from("users").select();

  StandardTimeTable timetable = StandardTimeTable.fromJson({
    "timings": [
      {
        "startTime": "-0001-11-30T09:00:00.000",
        "endTime": "-0001-11-30T09:45:00.000"
      }
    ],
    "days": {
      "monday": [
        {"name": "PHP"},
        {"name": "AI"},
        {"name": "J2EE"}
      ],
      "tuesday": [],
      "wednesday": [],
      "thursday": [
        {"name": "PHP"},
        {"name": "AI"},
        {"name": "J2EE"}
      ],
      "friday": [],
      "saturday": [],
      "sunday": [],
    }
  });
  @override
  Widget build(BuildContext context) {
    Widget layout;

    if (isWeb) {
      layout = Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              flex: 70,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: SingleChildScrollView(
                  child: TimetableCarousel(
                    timetable: timetable,
                    editable: true,
                    onEdit: (editedJson) async {
                      await Supabase.instance.client
                          .from("users")
                          .update({"timetable": editedJson}).eq("id",
                              Supabase.instance.client.auth.currentUser!.id);
                      setState(() {
                        logger.d("State was set");
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Placeholder for additional content'),
                      // Add more widgets here for the right section
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      layout = Text("Unimplemented");
    }

    return Scaffold(
      body: layout,
    );
  }
}
