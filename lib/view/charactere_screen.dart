import 'package:flutter/material.dart';
import 'package:projet_mds/service/charactere_service.dart';
import 'package:projet_mds/view/charactere_show.dart';

class CharactereScreen extends StatefulWidget {
  final String universeId;
  const CharactereScreen({super.key, required this.universeId});

  @override
  State<CharactereScreen> createState() => _CharactereScreenState();
}

class _CharactereScreenState extends State<CharactereScreen> {
  final CharactereService _apiCharactereService = CharactereService();
  List<Map<String, dynamic>> _allCharactereInfo = [];
  String? _message;
  bool _isLoading = true;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllCharactereInfo();
  }

  Future<void> _loadAllCharactereInfo() async {
    setState(() {
      _isLoading = true;
    });
    final allCharactereInfo =
        await _apiCharactereService.getAllCharactereInfo(widget.universeId);
    setState(() {
      _allCharactereInfo = allCharactereInfo;
      _isLoading = false;
    });
  }

  Future<void> _createCharactere() async {
    final nameCharactere = _nameController.text;

    final response = await _apiCharactereService.createCharactere(
      nameCharactere,
      widget.universeId,
    );

    if (response.success) {
      _loadAllCharactereInfo();
    }
  }

  void _onCharactereTap(String charactereId) {
    print('Charactere ID: $charactereId');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ShowCharactere(
            charactereId: charactereId,
            universeId: widget.universeId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charactere List'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllCharactereInfo,
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _allCharactereInfo.isEmpty
                  ? const Text('No characters found.')
                  : ListView.builder(
                      itemCount: _allCharactereInfo.length,
                      itemBuilder: (context, index) {
                        return buildCharactereColumn(
                            _allCharactereInfo[index], _onCharactereTap);
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Charactere'),
                content: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Charactere name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _createCharactere();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget buildCharactereColumn(
    Map<String, dynamic> charactere, void Function(String) onTap) {
  return GestureDetector(
    onTap: () => onTap(charactere['id'].toString()),
    child: Container(
      margin: const EdgeInsets.all(10.0),
      height: 75,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
          top: BorderSide(color: Colors.grey),
          right: BorderSide(color: Colors.grey),
          left: BorderSide(color: Colors.grey),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.network(
              'https://mds.sprw.dev/image_data/${charactere['image']}',
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.person_off,
                size: 75.0,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  charactere['name'] ?? 'Character unknown',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
