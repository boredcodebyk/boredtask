import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../controller/task.dart';
import '../model/task.dart';

enum EditMode {
  edit,
  create,
}

class TaskEditView extends ConsumerStatefulWidget {
  const TaskEditView({super.key, this.task, required this.editMode});
  final Task? task;
  final EditMode editMode;
  @override
  ConsumerState<TaskEditView> createState() => _TaskEditViewState();
}

class _TaskEditViewState extends ConsumerState<TaskEditView> {
  Task? task;

  TextEditingController titleController = TextEditingController();

  bool done = false;

  int priority = 0;

  void updatePriority() {
    if (priority == 3) {
      setState(() => priority = 0);
    } else {
      setState(() => priority++);
    }
  }

  String priorityString(int val) {
    switch (val) {
      case 0:
        return "Low";
      case 1:
        return "Medium";
      case 2:
        return "High";
      case 3:
        return "Very High";
      default:
        return "Low";
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editMode == EditMode.edit) {
      setState(() {
        task = widget.task;
        done = widget.task!.done;
        priority = widget.task!.priority;
        titleController.text = widget.task!.task;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.editMode == EditMode.edit
          ? (widget.editMode == EditMode.edit &&
              widget.task?.task == titleController.text)
          : true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok"))
            ],
          ),
        );
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar.medium(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 2.0),
                    child: ChoiceChip(
                      label: Text("${done ? "" : "Not "}Done"),
                      selected: done,
                      onSelected: (value) => setState(() => done = value),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: Icon(Icons.title),
                        title: TextField(
                          controller: titleController,
                          decoration:
                              InputDecoration.collapsed(hintText: "Title"),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        leading: Icon(Icons.flag_outlined),
                        title: Text("Priority: ${priorityString(priority)}"),
                        trailing: IconButton(
                            onPressed: () => updatePriority(),
                            icon: Icon(Icons.change_circle_outlined)),
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Task task = widget.editMode == EditMode.edit
                ? widget.task!.copyWith(
                    task: titleController.text,
                    dateModified: DateTime.now(),
                    priority: priority,
                    contextTags: [],
                    projectTags: [],
                    done: done,
                  )
                : Task(
                    id: Uuid().v4(),
                    task: titleController.text,
                    dateCreated: DateTime.now(),
                    dateModified: DateTime.now(),
                    priority: priority,
                    contextTags: [],
                    projectTags: [],
                    done: done,
                  );
            if (titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Title cannot be blank"),
                behavior: SnackBarBehavior.floating,
              ));
            } else {
              widget.editMode == EditMode.edit
                  ? ref.read(taskListProvider.notifier).updateTask(task)
                  : ref.read(taskListProvider.notifier).add(task);
              context.pop();
            }
          },
          child: Icon(Icons.done),
        ),
      ),
    );
  }
}
