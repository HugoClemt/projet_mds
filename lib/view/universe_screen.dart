import 'package:flutter/material.dart';
import 'package:projet_mds/service/universe_service.dart';

class UniverseScreen extends StatefulWidget {
  const UniverseScreen({super.key});

  @override
  State<UniverseScreen> createState() => _UniverseScreenState();
}

class _UniverseScreenState extends State<UniverseScreen> {
  final UniverseService _apiUniverseService = UniverseService();
  List<Map<String, dynamic>> _allUniverseInfo = [];

  @override
  void initState() {
    super.initState();
    _loadAllUniverseInfo();
  }

  Future<void> _loadAllUniverseInfo() async {
    final allUniverseInfo = await _apiUniverseService.getAllUniverseInfo();
    setState(() {
      _allUniverseInfo = allUniverseInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universe List'),
      ),
      body: Center(
        child: Column(
          children: [
            for (final universeInfo in _allUniverseInfo)
              buildUniverseColumn(universeInfo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add new universe');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget buildUniverseColumn(Map<String, dynamic> universeInfo) {
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
              Text(universeInfo['name'] ?? 'Universe unknown',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    ),
  );
}