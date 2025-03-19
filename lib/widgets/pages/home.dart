import 'dart:developer';
import 'dart:math';

import 'package:draggable_home/draggable_home.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/models/supabase.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/info_bar.dart';
import 'package:timetutor/widgets/loading.dart';
import 'package:timetutor/widgets/pages/institution_class_selector.dart';
import 'package:timetutor/widgets/pages/profile_page.dart';
import 'package:timetutor/widgets/pages/timetable_yaml_editor.dart';
import 'package:timetutor/widgets/timetable_carousel.dart';
import 'package:timetutor/widgets/timetable_period_countdown.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:yaml_writer/yaml_writer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return _withDraggableHome();
      }),
    );
  }

  Future<({Map<String, dynamic> profile, Map<String, dynamic> class_, Map<String, dynamic> institution})> _fetchData() async {
    final profile = await client.from("profiles").select().eq("id", client.auth.currentUser!.id).limit(1).maybeSingle();

    if (profile == null) {
      throw Exception("Your profile doesn't exist!");
    }

    final String joinedClass = profile['joined_class'];

    final class_ = await client
        .from("classes")
        .select()
        .eq(
          "id",
          joinedClass,
        )
        .single();

    Map<String, dynamic> institution = await client.from("institutions").select().eq("id", class_["institution"]).limit(1).single();

    return (profile: profile, class_: class_, institution: institution);
  }

  Widget _withDraggableHome() {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(child: CircularProgressIndicator());
            return Loading();
          }

          final (:profile, :class_, :institution) = snapshot.data!;
          print(institution);

          Timetable timetable;

          try {
            timetable = Timetable.fromJson(class_["timetable"]);
          } catch (e) {
            timetable = defaultTimetable;
            if (institution["creator"] != client.auth.currentUser!.id) {
              // not the owner so show default timetable
              //
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 20),
                    content: Text('Could not load the timetable. Potential cause: Version Mismatch. Falled back to default timetable.')));
              });

              // setState({})
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 4),
                    content: Text(
                        'Could not load the timetable. Potential cause: Version Mismatch. Updating the timetable to the latest version...')));
                client.from("classes").update({"timetable": timetable.toJson()}).eq("id", class_["id"]).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(duration: Duration(seconds: 10), content: Text('Updated the timetable to the latest version.')));
                      //setState(() {});
                    });
              });
            }
          }

          Widget expandedBody;
          Widget headerWidget;

          expandedBody = Center(
            child: FractionallySizedBox(
                //widthFactor: 0.9,
                heightFactor: 0.9,
                child: TimetableCarouselSlider(
                  editable: institution["creator"] == client.auth.currentUser!.id,
                  timetable: timetable,
                  onEdit: (json) {
                    print("After edit ${json.toJson()}");
                  },
                )),
          );

          headerWidget = Center(child: TimetablePeriodCountdown(timetable: timetable));

          final DateTime now = DateTime.now();
          final tod = now.toTimeOfDay();

          final Days<List<Timed<PeriodWithSubject>>> dayWithPeriods = timetable.dayWithPeriods;
          final List<Timed<PeriodWithSubject>> currentDayPeriods = dayWithPeriods.getDayFromDateInt(now.weekday);
          final Day currentDay = now.weekday.toDay();

          return DraggableHome(
            // appBarColor: Theme.of(context).primaryColorDark,
            actions: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: IconButton(
                    icon: RandomAvatar(
                      profile["avatar_string"],
                      trBackground: appSettings.monoColor,
                      theme: (appSettings.monoColor) ? SvgTheme(currentColor: Theme.of(context).primaryColor) : SvgTheme(),
                      colorFilter: appSettings.monoColor ? ColorFilter.mode(Theme.of(context).primaryColorLight, BlendMode.modulate) : null,
                      height: 35,
                      width: 35,
                    ),
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProfilePage();
                      }));
                      setState(() {});
                    }),
              )
            ],
            headerExpandedHeight: 0.35,
            body: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (currentDayPeriods.isNotEmpty)
                      Column(
                        children: [
                          TimetableCarouselSlider(
                            onEdit: (_) {},
                            timetable: timetable,
                            currentDayOnly: true,
                            showDayName: true,
                            dayName: (day) => "Today (${day.name.capitalize})",
                            updateDuration: Duration(seconds: 1),
                          ),
                        ],
                      ),
                    InfoBar(
                      color: appSettings.monoColor ? null : Colors.redAccent,
                      onTap: () {},
                      child: Column(children: [
                        Center(
                            child: Row(
                          children: [
                            Text("Joined ${class_['name']} of ${institution['name']}"),
                            SizedBox(width: 10),
                            if (institution["verified"]) Icon(Icons.verified)
                          ],
                        )),
                      ]),
                    ),
                    Center(child: Text("Quick Actions")),
                    InfoBar(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InstituionClassSelectorPage()),
                        );
                        setState(() {});
                      },
                      color: appSettings.monoColor ? null : Colors.yellow,
                      child: Row(
                        children: [
                          Icon(Icons.class_outlined),
                          SizedBox(width: 12),
                          Text('Switch class'),
                        ],
                      ),
                    ),
                    if (client.auth.currentUser!.id == institution["creator"])
                      InfoBar(
                        onTap: () async {
                          // final picker = ImagePicker();
                          // final XFile? img = await picker.pickImage(source: ImageSource.gallery);
                          // print(img);
                          // if (img != null) {
                          //   print(img.path);
                          // }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimetableYamlEditor()),
                          );
                        },
                        color: appSettings.monoColor ? null : Colors.green,
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings),
                            SizedBox(width: 12),
                            Text('Edit the timetable'),
                          ],
                        ),
                      ),
                    InfoBar(
                      onTap: () {
                        // setState(() {});
                        setState(() {});

                        materialPageKey = UniqueKey();

                        // Then trigger the app-level refresh
                        Future.delayed(Duration.zero, () {
                          materialPageSetState();
                        });
                      },
                      color: appSettings.monoColor ? null : Colors.deepPurpleAccent,
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 12),
                          Text('Refresh'),
                        ],
                      ),
                    ),
                    // InfoBar(
                    //   onTap: () {
                    //     notificationsPlugin.show(
                    //       0,
                    //       "TimeTutor",
                    //       "Hi, This is timetutor!",
                    //       notificationDetails,
                    //     );
                    //   },
                    //   color: appSettings.monoColor ? null : Colors.pinkAccent,
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.notifications),
                    //       SizedBox(width: 12),
                    //       Text('Notification Test'),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
            headerWidget: headerWidget,
            title: Text("TimeTutor"),
            expandedBody: expandedBody,
            fullyStretchable: true,
            headerBottomBar: null,
          );
        });
  }
}
