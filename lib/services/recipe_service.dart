import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Recipe>> getRecipes() {
    return _db.collection('recipes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _db.collection('recipes').add({
      'name': recipe.name,
      'imageUrl': recipe.imageUrl,
      'ingredients': recipe.ingredients,
      'instructions': recipe.instructions,
      'createdBy': recipe.createdBy,
    });
  }
}
