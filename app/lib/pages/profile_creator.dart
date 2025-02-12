import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';

class ProfileCreatorPage extends StatefulWidget {
  const ProfileCreatorPage({super.key});

  @override
  State<ProfileCreatorPage> createState() => _ProfileCreatorPageState();
}

class _ProfileCreatorPageState extends State<ProfileCreatorPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredPage(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Welcome to Timetutor!",
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
                    String userId =
                        Supabase.instance.client.auth.currentSession!.user.id;
                    await Supabase.instance.client
                        .from("users")
                        .insert({"id": userId, "name": nameController.text});
                    logger.d("User profile got set");
                  },
                  child: Text("Done"))
            ],
          ),
        ),
      ),
    );
  }
}
