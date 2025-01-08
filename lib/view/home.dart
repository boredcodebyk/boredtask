import 'package:boredtask/model/task.dart';
import 'package:boredtask/view/component/expandedtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/settings.dart';
import '../controller/task.dart';

Color colorScheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Theme.of(context).colorScheme.surfaceContainerLow
      : Theme.of(context).colorScheme.surfaceContainerHigh;
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.watch(listTypeProvider) == ListType.card
          ? colorScheme(context)
          : null,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            backgroundColor: ref.watch(listTypeProvider) == ListType.card
                ? colorScheme(context)
                : null,
            title: Text("Home"),
            leading: IconButton(
                onPressed: () => context.push('/settings'),
                icon: Icon(Icons.settings_outlined)),
            actions: [
              IconButton(
                  onPressed: () => ref
                      .read(themeProvider.notifier)
                      .updateTheme(ThemeMode.light),
                  icon: Icon(Icons.color_lens))
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ref.watch(taskListProvider).when(
                        loading: () => LinearProgressIndicator(),
                        error: (error, stack) => Text(
                            "Oops, something unexpected happened\n $stack"),
                        data: (value) => value.isEmpty
                            ? Text("Empty")
                            : Padding(
                                padding:
                                    ref.watch(listTypeProvider) == ListType.card
                                        ? const EdgeInsets.all(16.0)
                                        : EdgeInsets.zero,
                                child: Card(
                                  elevation: 0,
                                  clipBehavior: Clip.antiAlias,
                                  color: ref.watch(listTypeProvider) ==
                                          ListType.card
                                      ? Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerLowest
                                      : Colors.transparent,
                                  margin: EdgeInsets.zero,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: value.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(
                                      height: 1,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var task = value[index];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onLongPress: () {
                                              expandedIndex != index
                                                  ? setState(() =>
                                                      expandedIndex = index)
                                                  : setState(() =>
                                                      expandedIndex = null);
                                            },
                                            child: CheckboxListTile(
                                              dense:
                                                  ref.watch(denseListProvider),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              title: Text(task.task),
                                              checkboxShape: ref.watch(
                                                      roundedCheckboxProvider)
                                                  ? CircleBorder()
                                                  : null,
                                              value: task.done,
                                              onChanged: (value) {
                                                final updatedTask =
                                                    task.copyWith(
                                                        done: value,
                                                        dateModified:
                                                            DateTime.now());
                                                ref
                                                    .read(taskListProvider
                                                        .notifier)
                                                    .toggle(updatedTask);
                                              },
                                            ),
                                          ),
                                          ExpandedTile(
                                            expand: expandedIndex == index,
                                            child: ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: [
                                                ListTile(
                                                  onTap: () {},
                                                  dense: ref
                                                      .watch(denseListProvider),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Icon(Icons
                                                        .push_pin_outlined),
                                                  ),
                                                  title: Text("Pin"),
                                                ),
                                                ListTile(
                                                  onTap: () {},
                                                  dense: ref
                                                      .watch(denseListProvider),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Icon(Icons.edit),
                                                  ),
                                                  title: Text("Edit"),
                                                ),
                                                ListTile(
                                                  onTap: () {},
                                                  dense: ref
                                                      .watch(denseListProvider),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Icon(
                                                        Icons.delete_outline),
                                                  ),
                                                  title: Text("Trash"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new'),
        child: Icon(Icons.add),
      ),
    );
  }
}
