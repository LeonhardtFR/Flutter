import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OsbroSound Settings', style: TextStyle(color: Theme
            .of(context)
            .textTheme
            .bodyLarge!
            .color)),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        elevation: 0,
      ),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  Obx(
                        () => _CustomListTile(
                    title: "Dark Mode",
                    icon: CupertinoIcons.moon,
                    trailing: CupertinoSwitch(
                      value: settingsController.themeMode() == 1 || settingsController.themeMode() == 2,
                      onChanged: (value) {
                          value ? settingsController.themeMode.value = 1 : settingsController.themeMode.value = 0;
                          settingsController.saveTheme(settingsController.themeMode.value);
                          print(settingsController.themeMode.value.toString());
                          if (!value) {
                            settingsController.amoledMode(false);
                          }
                      },
                    ),
                  ),
                  ),


                  // Activable uniquement quand le dark mode est activé
                  Obx(
                        () => _CustomListTile(
                    title: "Amoled Mode",
                    icon: CupertinoIcons.moon_stars,
                    trailing: CupertinoSwitch(
                      value: settingsController.themeMode() == 2,
                      onChanged: settingsController.themeMode.value == 1 || settingsController.themeMode() == 2
                          ? (value) {
                        settingsController.amoledMode(value);
                        settingsController.amoledMode.value
                              ? settingsController.themeMode.value = 2
                              : settingsController.themeMode.value = 1;
                        settingsController.saveTheme(settingsController.themeMode.value);
                      } : null,
                    ),
                  ),
                  ),
                  const _CustomListTile(
                      title: "Storage music",
                      icon: CupertinoIcons.folder),
                ],
              ),

              const _SingleSection(
                title: "Download",
                children: [
                  _CustomListTile(
                      title: "Download Quality",
                      icon: CupertinoIcons.cloud_download),
                  _CustomListTile(
                      title: "Folder download",
                      icon: Icons.save_as),
                ],
              ),

              const _SingleSection(
                title: "About the application",
                children: [
                  _CustomListTile(
                      title: "Information",
                      icon: CupertinoIcons.info),
                  _CustomListTile(
                      title: "Version",
                      icon: Icons.update,
                      trailing: Text("0.1.0"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
