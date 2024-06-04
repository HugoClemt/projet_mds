import 'package:flutter/material.dart';
import 'package:projet_mds/service/universe_service.dart';
import 'package:projet_mds/view/add_universe.dart';

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
        child: _allUniverseInfo.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _allUniverseInfo.length,
                itemBuilder: (context, index) {
                  return buildUniverseColumn(_allUniverseInfo[index]);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUniverse()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget buildUniverseColumn(Map<String, dynamic> universeInfo) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    height: 75,
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
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Image.network(
            'https://mds.sprw.dev/image_data/${universeInfo['image']}',
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 75.0,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                universeInfo['name'] ?? 'Universe unknown',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
