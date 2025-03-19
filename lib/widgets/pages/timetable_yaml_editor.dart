import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/widgets/loading.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'dart:convert';

class TimetableYamlEditor extends StatefulWidget {
  const TimetableYamlEditor({super.key});

  @override
  State<TimetableYamlEditor> createState() => _TimetableYamlEditorState();
}

class _TimetableYamlEditorState extends State<TimetableYamlEditor> {
  final TextEditingController textController = TextEditingController(text: "hello");
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Timetable"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fetchData(),
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

            final (:profile, :class_, :institution) = snapshot.data!;

            final YamlWriter yamlWriter = YamlWriter();

            textController.text = yamlWriter.write(Timetable.fromJson(class_["timetable"]).toEasyJson());
            print(textController.text);

            late Map json;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1.5, // Allows horizontal scrolling
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7, // Proper height
                          child: Form(
                            autovalidateMode: AutovalidateMode.always,
                            key: _formKey,
                            child: TextFormField(
                              validator: (String? value) {
                                try {
                                  json = loadYaml(value!);
                                } catch (e) {
                                  return "$e";
                                }
                                return null;
                              },
                              controller: textController,
                              maxLines: null,
                              expands: true, // Allows full expansion
                              textAlignVertical: TextAlignVertical.top, // Aligns text to the top
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.sourceCodePro(
                                color: Theme.of(context).primaryColor,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8), // Adds padding to text
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Done"),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    try {
                      final actualJson = jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
                      Timetable _timetable = Timetable.fromEasyJson(actualJson);
                      client.from("classes").update({"timetable": _timetable.toJson()}).eq("id", class_["id"]).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully updated the Timetable')));
                          }, onError: (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update the timetable')));
                          });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      //rethrow;
                    }
                  },
                ),
              ],
            );
          }),
    );
  }
}
