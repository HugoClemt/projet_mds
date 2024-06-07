class Charactere {
  final String id;
  final String name;
  final String description;
  final String image;

  const Charactere({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Charactere.fromJson(Map<String, dynamic> json) {
    return Charactere(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }
}
