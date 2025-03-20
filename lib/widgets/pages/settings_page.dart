import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void dispose() {
    _updateData();
    super.dispose();
  }

  Future<void> _updateData() async {
    await client.from("profiles").update({"app_settings": appSettings.toJson()}).eq("id", client.auth.currentUser!.id);
    print("Updated settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SettingsList(
        darkTheme: SettingsThemeData(
          settingsTileTextColor: Theme.of(context).textTheme.bodyMedium!.color,
          titleTextColor: Theme.of(context).iconTheme.color,
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
        ),
        lightTheme: SettingsThemeData(
          settingsTileTextColor: Theme.of(context).textTheme.bodyMedium!.color,
          titleTextColor: Theme.of(context).iconTheme.color,
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
        ),
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile.switchTile(
                initialValue: appSettings.darkTheme,
                leading: Icon(Icons.wallpaper),
                onToggle: (value) {
                  setState(() {
                    appSettings.darkTheme = value;
                  });
                  materialPageSetState();
                },
                title: const Text("Dark mode"),
              ),
              SettingsTile.switchTile(
                initialValue: appSettings.monoColor,
                leading: Icon(Icons.filter),
                onToggle: (value) {
                  setState(() {
                    appSettings.monoColor = value;
                  });
                  materialPageSetState();
                },
                title: const Text("Mono Color"),
                description: Text("Sets everything to the same color as the theme"),
              ),
              SettingsTile(
                title: Text("Theme"),
                description: Text("Currently set to - ${appSettings.themeName}"),
                leading: Icon(Icons.brush),
                onPressed: (context) async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(child: Text("Choose theme")),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.7,
                            width: MediaQuery.of(context).size.height * 0.3,
                            child: GridView.count(padding: EdgeInsets.all(4.0), crossAxisCount: 3, children: [
                              for (final theme in FlexScheme.values)
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          appSettings.themeName = theme.name;
                                        });
                                        materialPageSetState();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(theme.name),
                                    ))
                            ]),
                          ),
                        );
                      });
                },
              ),
              SettingsTile.switchTile(
                initialValue: appSettings.generateAiTip,
                leading: Icon(Icons.api),
                onToggle: (value) {
                  setState(() {
                    appSettings.generateAiTip = value;
                  });
                },
                title: const Text("Enable AI Tips"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
