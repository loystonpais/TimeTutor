import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/info_bar.dart';
import 'package:timetutor/widgets/loading.dart';

class InstituionClassSelectorPage extends StatefulWidget {
  const InstituionClassSelectorPage({super.key});

  @override
  State<InstituionClassSelectorPage> createState() =>
      _InstituionClassSelectorPageState();

  Color getRandomColor(int seed) {
    final Random random = Random(seed);
    return Color.fromARGB(
      255, // Alpha (fully opaque)
      random.nextInt(100) + 156, // Red
      random.nextInt(100) + 156, // Green
      random.nextInt(100) + 156, // Blue
    );
  }
}

class _InstituionClassSelectorPageState
    extends State<InstituionClassSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Institution"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // SizedBox(height: 20),
            // Text("Select Institution",
            //     style: Theme.of(context).textTheme.headlineMedium!),
            // SizedBox(height: 20),
            FutureBuilder(
                future: client.from("institutions").select(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading institutions'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  }

                  // Ensure snapshot.data is a List
                  final institutions = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: institutions
                            .map((inst) => InfoBar(
                                  color: appSettings.monoColor
                                      ? null
                                      : widget.getRandomColor(inst["id"]),
                                  onTap: () async {
                                    await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          title: const Text("Select Class"),
                                          centerTitle: true,
                                        ),
                                        body: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(children: [
                                            // SizedBox(height: 20),
                                            // Text("Select Class",
                                            //     style: Theme.of(context)
                                            //         .textTheme
                                            //         .headlineMedium!),
                                            // SizedBox(height: 20),
                                            FutureBuilder(
                                                future: client
                                                    .from("classes")
                                                    .select()
                                                    .eq("institution",
                                                        inst["id"]),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Loading();
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                        child: Text(
                                                            'Error loading classes'));
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                        child: Text(
                                                            'No data available'));
                                                  }

                                                  final classes =
                                                      snapshot.data!;

                                                  final classWidgets = classes
                                                      .map(
                                                        (cls) => InfoBar(
                                                            onTap: () {
                                                              client
                                                                  .from(
                                                                      "profiles")
                                                                  .update({
                                                                    "joined_class":
                                                                        cls["id"]
                                                                  })
                                                                  .eq(
                                                                      "id",
                                                                      client
                                                                          .auth
                                                                          .currentUser!
                                                                          .id)
                                                                  .select()
                                                                  .then(
                                                                      (value) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Successfully set the class to ${cls["name"]}')));
                                                                    // POP twice to fully exist the InstitutionClassSelectorPage
                                                                    Navigator.of(
                                                                        context)
                                                                      ..pop()
                                                                      ..pop();
                                                                  }, onError:
                                                                          (error) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Error occured while setting class')));
                                                                    print(
                                                                        error);
                                                                    if (error
                                                                        is Exception) {
                                                                      print(
                                                                          "error is exception");
                                                                    }
                                                                  });
                                                            },
                                                            color: appSettings
                                                                    .monoColor
                                                                ? null
                                                                : widget.getRandomColor(
                                                                    cls["id"]
                                                                        .hashCode),
                                                            child: Text(
                                                                cls["name"])),
                                                      )
                                                      .toList();

                                                  return SingleChildScrollView(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: classWidgets
                                                                .isNotEmpty
                                                            ? classWidgets
                                                            : [
                                                                Center(
                                                                  child: Text(
                                                                      "No classes are found :("),
                                                                )
                                                              ]),
                                                  );
                                                })
                                          ]),
                                        ),
                                      );
                                    }));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.school),
                                      SizedBox(width: 20),
                                      Text(inst["name"]),
                                      SizedBox(width: 10),
                                      if (inst["verified"]) Icon(Icons.verified)
                                    ],
                                  ),
                                ))
                            .toList()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
