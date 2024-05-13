import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class People {
  final  String id;
  final String name;
  final String embedding;
  People({
    required this.id,
    required this.name,
    required this.embedding,
  });

  People copyWith({
    String? id,
    String? name,
    String? embedding,
  }) {
    return People(
      id: id ?? this.id,
      name: name ?? this.name,
      embedding: embedding ?? this.embedding,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'embedding': embedding,
    };
  }

  factory People.fromMap(Map<String, dynamic> map) {
    return People(
      id: map['id'] as String,
      name: map['name'] as String,
      embedding: map['embedding'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory People.fromJson(String source) => People.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'People(id: $id, name: $name, embedding: $embedding)';

  @override
  bool operator ==(covariant People other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.embedding == embedding;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ embedding.hashCode;
}
