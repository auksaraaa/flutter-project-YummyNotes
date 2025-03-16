class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final String createdBy;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.createdBy,
  });

  factory Recipe.fromMap(String id, Map<String, dynamic> data) {
    return Recipe(
      id: id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      ingredients: List<String>.from(data['ingredients']),
      instructions: data['instructions'],
      createdBy: data['createdBy'],
    );
  }
}
