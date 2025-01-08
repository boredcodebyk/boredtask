import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controller/settings.dart';
import '../settings.dart';

class AppearanceView extends ConsumerWidget {
  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Text("Appearance"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DemoList(),
                ),
                SwitchListTile(
                  title: Text("Dense"),
                  value: ref.watch(denseListProvider),
                  onChanged: (bool value) =>
                      ref.read(denseListProvider.notifier).updateBool(value),
                ),
                SwitchListTile(
                  title: Text("Rounded Checkbox"),
                  value: ref.watch(roundedCheckboxProvider),
                  onChanged: (bool value) => ref
                      .read(roundedCheckboxProvider.notifier)
                      .updateBool(value),
                ),
                ListTile(
                  title: Text("List Type"),
                  onTap: () => context.push('/settings/appearance/listtype'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListTileType extends ConsumerWidget {
  const ListTileType({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Text("List Type"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DemoList(),
                ),
                RadioListTile(
                  title: Text("Card View"),
                  value: ListType.card,
                  groupValue: ref.watch(listTypeProvider),
                  onChanged: (ListType? value) => ref
                      .read(listTypeProvider.notifier)
                      .updateAppearance(value!),
                ),
                RadioListTile(
                  title: Text("Flat View"),
                  value: ListType.flat,
                  groupValue: ref.watch(listTypeProvider),
                  onChanged: (ListType? value) => ref
                      .read(listTypeProvider.notifier)
                      .updateAppearance(value!),
                ),
                ListTile()
              ],
            ),
          )
        ],
      ),
    );
  }
}
