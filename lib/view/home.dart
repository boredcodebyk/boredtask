import 'package:animations/animations.dart';
import 'package:boredtask/model/task.dart';
import 'package:boredtask/view/component/expandedtile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/settings.dart';
import '../controller/task.dart';
import 'views.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  String? expandedID;
  bool bulkSelection = false;
  List<String> selectedList = [];
  void pinTask(Task task) {
    final pinnedTask =
        task.copyWith(pin: !task.pin, dateModified: DateTime.now());
    ref.read(taskListProvider.notifier).updateTask(pinnedTask);
  }

  void editTask(Task task) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TaskEditView(
        editMode: EditMode.edit,
        task: task,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    ));
  }

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
                  onPressed: () {
                    setState(() => bulkSelection = !bulkSelection);
                    if (bulkSelection) {
                      setState(() => selectedList = []);
                    }
                  },
                  icon: Icon(bulkSelection
                      ? Icons.expand_circle_down_sharp
                      : Icons.select_all))
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (value
                                        .where((e) => e.pin == true)
                                        .toList()
                                        .isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text("Pinned"),
                                      ),
                                      taskList(value
                                          .where((e) => e.pin == true)
                                          .toList()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text("Others"),
                                      ),
                                    ],
                                    if (bulkSelection)
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 12.0),
                                        leading: Checkbox(
                                          value: listEquals(
                                              selectedList,
                                              value
                                                  .where((e) => e.pin == false)
                                                  .map((el) => el.id)
                                                  .toList()),
                                          onChanged: (v) {
                                            if (selectedList.isEmpty) {
                                              var v = value
                                                  .where((e) => e.pin == false)
                                                  .map((el) => el.id)
                                                  .toList();
                                              for (var item in v) {
                                                setState(() =>
                                                    selectedList.add(item));
                                              }
                                            } else {
                                              setState(() => selectedList = []);
                                            }
                                          },
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (selectedList.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "No task is selected"),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    ));
                                                  } else {
                                                    var v = value
                                                        .where((e) =>
                                                            e.pin == false)
                                                        .toList();
                                                    for (var item
                                                        in selectedList) {
                                                      var task = v
                                                          .where((e) =>
                                                              e.id == item)
                                                          .toList()
                                                          .first;
                                                      pinTask(task);
                                                    }
                                                    setState(() =>
                                                        selectedList = []);
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.push_pin_outlined))
                                          ],
                                        ),
                                      ),
                                    taskList(value
                                        .where((e) => e.pin == false)
                                        .toList()),
                                  ],
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

  Widget taskList(List<Task> value) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: ref.watch(listTypeProvider) == ListType.card
          ? Theme.of(context).colorScheme.surfaceContainerLowest
          : Colors.transparent,
      margin: EdgeInsets.zero,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: value.length,
        clipBehavior: Clip.antiAlias,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          var task = value[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onLongPress: bulkSelection
                    ? null
                    : () => setState(() => expandedID != task.id
                        ? expandedID = task.id
                        : expandedID = null),
                child: CheckboxListTile(
                  dense: ref.watch(denseListProvider),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(task.task),
                  checkboxShape: ref.watch(roundedCheckboxProvider)
                      ? CircleBorder()
                      : null,
                  value: bulkSelection
                      ? selectedList.contains(task.id)
                      : task.done,
                  onChanged: (value) {
                    if (bulkSelection) {
                      if (selectedList.contains(task.id)) {
                        setState(() => selectedList.remove(task.id));
                      } else {
                        setState(() => selectedList.add(task.id));
                      }
                    } else {
                      final updatedTask = task.copyWith(
                          done: value, dateModified: DateTime.now());
                      ref
                          .read(taskListProvider.notifier)
                          .updateTask(updatedTask);
                    }
                  },
                ),
              ),
              ExpandedTile(
                expand: expandedID == task.id,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() => expandedID = null);
                        pinTask(task);
                      },
                      dense: ref.watch(denseListProvider),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(task.pin
                            ? Icons.push_pin
                            : Icons.push_pin_outlined),
                      ),
                      title: Text(task.pin ? "Unpin" : "Pin"),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() => expandedID = null);

                        editTask(task);
                      },
                      dense: ref.watch(denseListProvider),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.edit),
                      ),
                      title: Text("Edit"),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() => expandedID = null);
                      },
                      dense: ref.watch(denseListProvider),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.delete_outline),
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
    );
  }
}
