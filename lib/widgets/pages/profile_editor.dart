import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/loading.dart';
import 'dart:math';

class ProfileEditorPage extends StatefulWidget {
  final bool createIfDoesNotExist;
  final VoidCallback? onProfileCreated;
  const ProfileEditorPage({
    super.key,
    this.createIfDoesNotExist = false,
    this.onProfileCreated,
  });

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();

  static String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890_';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final avatarStringController = TextEditingController();

  Future<({Map<String, dynamic> profile, Map<String, dynamic> class_, Map<String, dynamic> institution})> _fetchData() async {
    var profile = await client.from("profiles").select().eq("id", client.auth.currentUser!.id).limit(1).maybeSingle();

    if (widget.createIfDoesNotExist) {
      print("creating");
      profile = await client
          .from("profiles")
          .insert({"id": client.auth.currentUser!.id, "username": ProfileEditorPage.getRandomString(19)})
          .select()
          .limit(1)
          .maybeSingle();
      print("created");
    }
    if (profile == null) {
      throw Exception("Your profile doesn't exist!");
    }

    final String joinedClass = profile['joined_class'];

    final class_ = await client.from("classes").select().eq("id", joinedClass).single();

    Map<String, dynamic> institution = await client.from("institutions").select().eq("id", class_["institution"]).limit(1).single();

    return (profile: profile, class_: class_, institution: institution);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit/Set Profile"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading profile'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            final (:profile, :class_, :institution) = snapshot.data!;

            avatarStringController.text = profile["avatar_string"];
            nameController.text = profile["name"];
            usernameController.text = profile["username"];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: avatarStringController,
                      builder: (context, value, child) {
                        return Center(
                          child: RandomAvatar(
                            value.text,
                            trBackground: appSettings.monoColor,
                            theme: (appSettings.monoColor) ? SvgTheme(currentColor: Theme.of(context).primaryColor) : SvgTheme(),
                            colorFilter:
                                appSettings.monoColor ? ColorFilter.mode(Theme.of(context).primaryColorLight, BlendMode.modulate) : null,
                          ),
                        );
                      },
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: avatarStringController,
                            decoration: InputDecoration(
                              hintText: "Enter avatar string",
                              labelText: "Avatar String",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a valid avatar string";
                              }

                              if (value.length >= 20) {
                                return "Avatar string must be less than 20 characters";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "Enter username",
                              labelText: "Username",
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Username cannot be empty";
                              }

                              if (value.length < 3) {
                                return "Username must be at least 3 characters long";
                              }

                              if (value.length > 20) {
                                return "Username must be less than 20 characters";
                              }

                              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                return "Username can only contain letters, numbers, and underscores";
                              }

                              return null;
                            },
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                              labelText: "Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }

                              if (value.length >= 20) {
                                return "Name must be less than 20 characters";
                              }
                              return null;
                            },
                          ),
                          TextButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                final String username = usernameController.text;

                                final usernameCheck = await client
                                    .from("profiles")
                                    .select()
                                    .eq("username", username)
                                    .neq("id", client.auth.currentUser!.id)
                                    .maybeSingle();
                                if (usernameCheck != null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text('Username $username is already taken')));
                                  return;
                                }

                                client
                                    .from("profiles")
                                    .update({
                                      "name": nameController.text,
                                      "avatar_string": avatarStringController.text,
                                      "username": username,
                                    })
                                    .eq("id", client.auth.currentUser!.id)
                                    .select()
                                    .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text('Successfully updated the profile')));
                                      // POP twice to fully exist the InstitutionClassSelectorPage
                                      //Navigator.of(context).pop();
                                      if (widget.onProfileCreated != null) {
                                        widget.onProfileCreated!.call();
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    }, onError: (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update the profile')));
                                    });
                              },
                              child: Text("Done"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
