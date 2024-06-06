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
  final TextEditingController _nameController = TextEditingController();
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
      _nameController.text = _charactereData?['name'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_charactereData?['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {},
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
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: ''),
                    ),
                    const SizedBox(height: 20),
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
