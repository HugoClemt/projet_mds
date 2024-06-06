import 'package:flutter/material.dart';
import 'package:projet_mds/service/charactere_service.dart';

class ShowCharactere extends StatefulWidget {
  final String charactereId;
  final String universeId;
  const ShowCharactere(
      {super.key, required this.charactereId, required this.universeId});

  @override
  State<ShowCharactere> createState() => _ShowCharactereState();
}

class _ShowCharactereState extends State<ShowCharactere> {
  final CharactereService _apiCharactereService = CharactereService();
  Map<String, dynamic>? _charactereData;

  @override
  void initState() {
    super.initState();
    _loadCharactereData();
  }

  Future<void> _loadCharactereData() async {
    final charactereData = await _apiCharactereService.getCharactereData(
        widget.universeId, widget.charactereId);
    setState(() {
      _charactereData = charactereData;
    });
  }

  void _updateCharactereName() async {
    final response = await _apiCharactereService.updateCharactere(
        widget.universeId, widget.charactereId);
    if (response.success) {
      _loadCharactereData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_charactereData?['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCharactereData,
          ),
          IconButton(
            icon: const Icon(Icons.save_as),
            onPressed: _updateCharactereName,
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
                    Text('${_charactereData?['description']}'),
                    const SizedBox(height: 20),
                    Image.network(
                      "https://mds.sprw.dev/image_data/${_charactereData?['image']}",
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
