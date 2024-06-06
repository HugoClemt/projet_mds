import 'package:flutter/material.dart';
import 'package:projet_mds/service/authentification_service.dart';
import 'package:projet_mds/view/conversation_screen.dart';
import 'package:projet_mds/view/login_screen.dart';
import 'package:projet_mds/view/universe_screen.dart';
import 'package:projet_mds/view/user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthentificationService _apiService = AuthentificationService();
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _apiService.getUserInfo();
    setState(() {
      _userInfo = userInfo;
    });
  }

  void _logout(BuildContext context) async {
    await _apiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text('Hello ${_userInfo?['username']}!'),
          ),
          const SizedBox(height: 20),
          Center(
              child: GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserScreen(),
                    ),
                  );
                },
                child: const Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Text('User List'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UniverseScreen(),
                    ),
                  );
                },
                child: const Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rocket_launch_outlined),
                      Text('Universe List'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConversationScreen(),
                    ),
                  );
                },
                child: const Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.messenger_outline),
                      Text('Conversation List'),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
