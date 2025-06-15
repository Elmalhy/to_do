import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:untitled/modules/done_tasks/done_tasks_screen.dart';
import 'package:untitled/modules/new_tasks/new_tasks_screen.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';
import '../shared/components/constants.dart';

class TodoApp extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text(
                  cubit.str[cubit.currentIndex],
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) => Center(child: CircularProgressIndicator(color: Colors.blue,)),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertIntoDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator:
                                    (value) =>
                                value!.isEmpty
                                    ? 'title must not be empty'
                                    : null,
                                onTap: () {},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Task title'),
                                  prefixIcon: Icon(Icons.title),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                validator:
                                    (value) =>
                                value!.isEmpty
                                    ? 'time must not be empty'
                                    : null,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Task time'),
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                validator:
                                    (value) =>
                                value!.isEmpty
                                    ? 'date must not be empty'
                                    : null,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2025-05-03'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(
                                      value!,
                                    );
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Task date'),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .closed
                        .then((value) {
                          cubit.changeBottomSheetState(
                            isShown: false,
                            icon: Icons.edit,
                          );
                    });
                    cubit.changeBottomSheetState(
                      isShown: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(cubit.fabIcon, color: Colors.white),
              ),
              bottomNavigationBar: BottomNavigationBar(
                fixedColor: Colors.blue,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if(state is AppInsertDatabaseState) {
              Navigator.pop(context);
            }
          },
      ),
    );
  }
}
