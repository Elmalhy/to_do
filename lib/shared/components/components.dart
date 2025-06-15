import 'package:flutter/material.dart';
import 'package:untitled/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 40.0,
          child: Text('${model['time']}', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text('${model['date']}', style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ),
        SizedBox(width: 20.0),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          },
          icon: Icon(Icons.check_circle_outline, color: Colors.green),
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateData(status: 'archived', id: model['id']);
          },
          icon: Icon(Icons.archive_outlined, color: Colors.black45),
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
