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
  State<InstituionClassSelectorPage> createState() => _InstituionClassSelectorPageState();

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

class _InstituionClassSelectorPageState extends State<InstituionClassSelectorPage> {
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
                            .map<Widget>((inst) => InfoBar(
                                  color: appSettings.monoColor ? null : widget.getRandomColor(inst["id"]),
                                  onTap: () async {
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          title: const Text("Select Class"),
                                          centerTitle: true,
                                        ),
                                        body: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(children: [
                                            FutureBuilder(
                                                future: client.from("classes").select().eq("institution", inst["id"]),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Loading();
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Center(child: Text('Error loading classes'));
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Center(child: Text('No data available'));
                                                  }

                                                  final classes = snapshot.data!;

                                                  final classWidgets = classes
                                                      .map<Widget>(
                                                        (cls) => InfoBar(
                                                            onTap: () {
                                                              client
                                                                  .from("profiles")
                                                                  .update({"joined_class": cls["id"]})
                                                                  .eq("id", client.auth.currentUser!.id)
                                                                  .select()
                                                                  .then((value) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                        content: Text('Successfully set the class to ${cls["name"]}')));
                                                                    // POP twice to fully exist the InstitutionClassSelectorPage
                                                                    Navigator.of(context)
                                                                      ..pop()
                                                                      ..pop();
                                                                  }, onError: (error) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text('Error occured while setting class')));
                                                                    print(error);
                                                                    if (error is Exception) {
                                                                      print("error is exception");
                                                                    }
                                                                  });
                                                            },
                                                            color: appSettings.monoColor ? null : widget.getRandomColor(cls["id"].hashCode),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.book),
                                                                SizedBox(width: 20),
                                                                Text(cls["name"]),
                                                                SizedBox(width: 20),
                                                                if (inst["creator"] == client.auth.currentUser!.id)
                                                                  IconButton(
                                                                      icon: Icon(Icons.delete),
                                                                      onPressed: () {
                                                                        final String instName = cls["name"];
                                                                        client.from("classes").delete().eq("id", cls["id"]).select().then(
                                                                            (value) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text('Deleted class "$instName"')));
                                                                          setState(() {});
                                                                        }, onError: (error) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text('Failed to delete class "$instName"')));
                                                                        });
                                                                      }),
                                                              ],
                                                            )),
                                                      )
                                                      .toList();

                                                  return SingleChildScrollView(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: (classWidgets.isNotEmpty
                                                                ? classWidgets
                                                                : <Widget>[
                                                                    Center(
                                                                      child: Text("No classes are found :("),
                                                                    )
                                                                  ]) +
                                                            <Widget>[
                                                              if (inst["creator"] == client.auth.currentUser!.id)
                                                                TextButton(
                                                                    onPressed: () async {
                                                                      await showDialog(
                                                                        context: context,
                                                                        builder: (context) {
                                                                          final _formKey = GlobalKey<FormState>();
                                                                          final TextEditingController _classController =
                                                                              TextEditingController();

                                                                          return AlertDialog(
                                                                            title: Center(child: Text("Create Class")),
                                                                            content: SizedBox(
                                                                              //height: MediaQuery.of(context).size.width * 0.7,
                                                                              width: MediaQuery.of(context).size.height * 0.3,
                                                                              child: Form(
                                                                                key: _formKey,
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    TextFormField(
                                                                                      controller: _classController,
                                                                                      decoration: InputDecoration(labelText: "Class Name"),
                                                                                      validator: (value) {
                                                                                        if (value == null || value.isEmpty) {
                                                                                          return "Please enter the class name";
                                                                                        }
                                                                                        if (value.length > 20) {
                                                                                          return "Class name must be under 20 characters";
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    client
                                                                                        .from("classes")
                                                                                        .insert({
                                                                                          "name": _classController.text,
                                                                                          "institution": inst["id"],
                                                                                        })
                                                                                        .select()
                                                                                        .single()
                                                                                        .then((value) {
                                                                                          Navigator.of(context).pop();

                                                                                          setState(() {
                                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                content: Text(
                                                                                                    'Created new class named "${_classController.text}"')));
                                                                                          });
                                                                                        }, onError: (error) {
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                              SnackBar(
                                                                                                  content:
                                                                                                      Text('Failed to create the class')));
                                                                                        });
                                                                                  }
                                                                                },
                                                                                child: Text("Create"),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Text("Add Class"))
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
                                      if (inst["verified"]) Icon(Icons.verified),
                                      if (inst["creator"] == client.auth.currentUser!.id) Text("(owner)"),
                                      if (inst["creator"] == client.auth.currentUser!.id)
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              final String instName = inst["name"];
                                              client.from("institutions").delete().eq("id", inst["id"]).select().then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(content: Text('Deleted institution "$instName"')));
                                                setState(() {});
                                              }, onError: (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(content: Text('Failed to delete institution "$instName"')));
                                              });
                                            }),
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
