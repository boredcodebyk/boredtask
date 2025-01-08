import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/settings.dart';

class ThemeView extends ConsumerWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Text("Theme"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 2.0),
                  child: Text("Dark Mode"),
                ),
                RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: ref.watch(themeProvider),
                  title: Text("System"),
                  value: ThemeMode.system,
                  onChanged: (value) => ref
                      .read(themeProvider.notifier)
                      .updateTheme(ThemeMode.system),
                ),
                RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: ref.watch(themeProvider),
                  title: Text("On"),
                  value: ThemeMode.dark,
                  onChanged: (value) => ref
                      .read(themeProvider.notifier)
                      .updateTheme(ThemeMode.dark),
                ),
                RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: ref.watch(themeProvider),
                  title: Text("Off"),
                  value: ThemeMode.light,
                  onChanged: (value) => ref
                      .read(themeProvider.notifier)
                      .updateTheme(ThemeMode.light),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
