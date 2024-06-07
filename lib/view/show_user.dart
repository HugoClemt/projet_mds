import 'package:flutter/material.dart';
import 'package:projet_mds/service/authentification_service.dart';
import 'package:projet_mds/view/user_screen.dart';

class ShowUser extends StatefulWidget {
  final String userId;
  const ShowUser({super.key, required this.userId});

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  final AuthentificationService _apiService = AuthentificationService();
  Map<String, dynamic>? _userInfo;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _apiService.getUserData(widget.userId);
    setState(() {
      _userInfo = userInfo;
      _usernameController.text = _userInfo?['username'] ?? '';
      _emailController.text = _userInfo?['email'] ?? '';
      _firstnameController.text = _userInfo?['firstname'] ?? '';
      _lastnameController.text = _userInfo?['lastname'] ?? '';
    });
  }

  void _updateUserInfo() async {
    final newUsername = _usernameController.text;
    final newEmail = _emailController.text;
    final newFirstname = _firstnameController.text;
    final newLastname = _lastnameController.text;
    final response = await _apiService.updateUserInfo(
      widget.userId,
      newUsername,
      newEmail,
      newFirstname,
      newLastname,
    );
    if (response.success) {
      Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const UserScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: _userInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _firstnameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUserInfo,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
