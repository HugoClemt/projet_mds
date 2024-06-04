import 'package:flutter/material.dart';
import 'package:projet_mds/service/universe_service.dart';

class ShowUniverse extends StatefulWidget {
  final String universeId;
  const ShowUniverse({super.key, required this.universeId});

  @override
  State<ShowUniverse> createState() => _ShowUniverseState();
}

class _ShowUniverseState extends State<ShowUniverse> {
  final UniverseService _apiUniverseService = UniverseService();
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
    });
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
            icon: const Icon(Icons.person),
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
                      decoration: const InputDecoration(
                        labelText: '',
                      ),
                      controller:
                          TextEditingController(text: _universeData?['name']),
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
