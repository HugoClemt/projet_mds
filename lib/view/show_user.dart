import 'package:flutter/material.dart';

class ShowUser extends StatefulWidget {
  final String userId;
  const ShowUser({super.key, required this.userId});

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
