import 'package:flutter/material.dart';
import 'package:projet_mds/service/conversation_service.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationService _apiConversationService = ConversationService();
  List<Map<String, dynamic>> _allConversation = [];
  String? _message;

  String? selectedUniverse;
  String? selectedCharacter;
  List<Map<String, dynamic>> universes = [];
  List<Map<String, dynamic>> characters = [];

  @override
  void initState() {
    super.initState();
    _loadAllConversation();
    _loadAllUniverse();
  }

  Future<void> _loadAllConversation() async {
    final allConversation = await _apiConversationService.getAllConversation();
    setState(() {
      _allConversation = allConversation;
    });
  }

  Future<void> _loadAllUniverse() async {
    final allUniverse = await _apiConversationService.getAllUniverse();
    setState(() {
      universes = allUniverse;
    });
  }

  Future<void> _loadCharactersForUniverse(String universeId) async {
    final charactersInUniverse =
        await _apiConversationService.getCharactersByUniverse(universeId);
    setState(() {
      characters = charactersInUniverse;
      selectedCharacter = null;
    });
  }

  void _createConversation() async {
    final selectedCharacter = this.selectedCharacter;

    final response =
        await _apiConversationService.createConversation(selectedCharacter!);

    if (response.success) {
      _loadAllConversation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation List'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllConversation,
        child: const Center(
          child: Text("Liste des conversation"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Créer une conversation'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: selectedUniverse,
                          hint: const Text('Sélectionnez un univers'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUniverse = newValue;
                            });
                            if (newValue != null) {
                              _loadCharactersForUniverse(newValue);
                            }
                          },
                          items: universes
                              .map((e) => DropdownMenuItem<String>(
                                    value: e['id'].toString(),
                                    child: Text(e['name']),
                                  ))
                              .toList(),
                        ),
                        if (selectedUniverse != null)
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _apiConversationService
                                .getCharactersByUniverse(selectedUniverse!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Erreur de chargement');
                              } else {
                                final characters = snapshot.data ?? [];
                                return DropdownButton<String>(
                                  value: selectedCharacter,
                                  hint:
                                      const Text('Sélectionnez un personnage'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCharacter = newValue;
                                    });
                                  },
                                  items: characters
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e['id'].toString(),
                                            child: Text(e['name']),
                                          ))
                                      .toList(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          _createConversation();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Créer'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}