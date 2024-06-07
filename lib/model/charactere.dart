import 'package:projet_mds/model/universe.dart';

class Charactere {
  final String id;
  final String name;
  final String description;
  final String image;
  final Universe universe;

  const Charactere({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.universe,
  });

  factory Charactere.fromJson(Map<String, dynamic> json) {
    return Charactere(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      image: json['image'],
      universe: Universe.fromJson(json['universe']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'universe': universe.toJson(),
    };
  }
}
