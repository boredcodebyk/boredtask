import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/settings.dart';

class SettingList {
  String title;
  String route;
  IconData icon;
  List<SettingList> subPage;
  SettingList(
      {required this.title,
      required this.route,
      required this.icon,
      this.subPage = const []});
}

final pageList = [
  SettingList(
    title: "Theme",
    route: '/settings/theme',
    icon: Icons.color_lens_outlined,
  ),
  SettingList(
    title: "Appearance",
    route: '/settings/appearance',
    icon: Icons.list_alt,
  )
];

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var item in pageList)
                  ListTile(
                    title: Text(item.title),
                    leading: Icon(item.icon),
                    onTap: () => context.push(item.route),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DemoList extends ConsumerWidget {
  const DemoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          color: ref.watch(listTypeProvider) == ListType.card
              ? Theme.of(context).colorScheme.surfaceContainerLowest
              : Colors.transparent,
          child: ListView(
            shrinkWrap: true,
            children: [
              CheckboxListTile(
                dense: ref.watch(denseListProvider),
                checkboxShape:
                    ref.watch(roundedCheckboxProvider) ? CircleBorder() : null,
                value: false,
                onChanged: (bool? value) {},
                title: Text("A task"),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Divider(
                height: 1,
              ),
              CheckboxListTile(
                dense: ref.watch(denseListProvider) ?? true,
                checkboxShape:
                    ref.watch(roundedCheckboxProvider) ? CircleBorder() : null,
                value: false,
                onChanged: (bool? value) {},
                title: Text("A second task"),
                controlAffinity: ListTileControlAffinity.leading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
