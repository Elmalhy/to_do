import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/cubit/cubit.dart';

import '../../shared/components/constants.dart';
import '../../shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.0,
            ),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
