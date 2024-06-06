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
        child: _allUserInfo.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _allUserInfo.length,
                itemBuilder: (context, index) {
                  return buildUserColumn(_allUserInfo[index]);
                },
              ),
      ),
    );
  }
}

Widget buildUserColumn(Map<String, dynamic> userInfo) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.grey),
        right: BorderSide(color: Colors.grey),
        bottom: BorderSide(color: Colors.grey),
        left: BorderSide(color: Colors.grey),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 10.0),
          child: Icon(Icons.account_circle, size: 40.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo['username'] ?? 'Pseudo inconnu',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                userInfo['email'] ?? 'Email inconnu',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
