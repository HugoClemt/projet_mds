import 'package:flutter/material.dart';
import 'package:projet_mds/service/universe_service.dart';
import 'package:projet_mds/view/charactere_screen.dart';

class ShowUniverse extends StatefulWidget {
  final String universeId;
  const ShowUniverse({super.key, required this.universeId});

  @override
  State<ShowUniverse> createState() => _ShowUniverseState();
}

class _ShowUniverseState extends State<ShowUniverse> {
  final UniverseService _apiUniverseService = UniverseService();
  final TextEditingController _nameController = TextEditingController();
  Map<String, dynamic>? _universeData;

  @override
  void initState() {
    super.initState();
    _loadUniverseData();
  }

  Future<void> _loadUniverseData() async {
    final universeData =
        await _apiUniverseService.getUniverseData(widget.universeId);
    setState(() {
      _universeData = universeData;
      _nameController.text = _universeData?['name'] ?? '';
    });
  }

  void _updateUniverseName() async {
    final newName = _nameController.text;
    print('New name: $newName');
    final response =
        await _apiUniverseService.updateUniverse(widget.universeId, newName);
    if (response.success) {
      _loadUniverseData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_universeData?['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUniverseData,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateUniverseName,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CharactereScreen(universeId: widget.universeId);
              }));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '',
                      ),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    Text('${_universeData?['description']}'),
                    const SizedBox(height: 20),
                    Image.network(
                      "https://mds.sprw.dev/image_data/${_universeData?['image']}",
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
