import 'package:flutter/material.dart';

import '../controller/sqflite_db_controller.dart';
import '../di.dart';
import '../model/user.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final ValueNotifier<List<User>> users = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void fetchUser() async {
    isLoading.value = true;
    final list = await locator<SqfLiteDbController>().fetchAllUser();
    users.value = list;
    isLoading.value = false;
  }

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  void dispose() {
    isLoading.dispose();
    users.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users"), centerTitle: true),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, isTrue, child) {
          if (isTrue) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return child!;
          }
        },
        child: ValueListenableBuilder<List<User>>(
          valueListenable: users,
          builder: (context, list, child) {
            if (list.isEmpty) {
              return const Center(child: Text("No User Found"));
            } else {
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text("${list[i].email}"),
                        subtitle: Text("${list[i].username}"),
                        trailing: CircleAvatar(
                          child: Text("${list[i].id}"),
                        ),
                      ),
                      const Divider(color: Colors.black),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
