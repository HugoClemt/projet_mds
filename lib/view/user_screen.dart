import 'package:flutter/material.dart';
import 'package:projet_mds/service/authentification_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AuthentificationService _apiService = AuthentificationService();
  List<Map<String, dynamic>> _allUserInfo = [];

  @override
  void initState() {
    super.initState();
    _loadAllUserInfo();
  }

  Future<void> _loadAllUserInfo() async {
    final allUserInfo = await _apiService.getAllUserInfo();
    setState(() {
      _allUserInfo = allUserInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _allUserInfo.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_allUserInfo[index]['username']}'),
              subtitle: Text('Email: ${_allUserInfo[index]['email']}'),
            );
          },
        ),
      ),
    );
  }
}
