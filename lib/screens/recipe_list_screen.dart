import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_screen.dart';

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🍳สูตรอาหาร")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var recipes = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              var recipe = recipes[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.network(
                          recipe['imageUrl'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "โดย ${recipe['createdBy']}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed:
                                        () => _editRecipe(context, recipe),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _deleteRecipe(context, recipe.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
      ),
    );
  }

  void _editRecipe(BuildContext context, QueryDocumentSnapshot recipe) {
    TextEditingController nameController = TextEditingController(
      text: recipe['name'],
    );
    TextEditingController imageUrlController = TextEditingController(
      text: recipe['imageUrl'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "แก้ไขสูตรอาหาร",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "ชื่อสูตร",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.restaurant_menu),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: "URL รูปภาพ",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("บันทึก"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(recipe.id)
                    .update({
                      'name': nameController.text,
                      'imageUrl': imageUrlController.text,
                    });
                Navigator.pop(context);
                // แสดงข้อความว่าบันทึกสำเร็จ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('บันทึกการแก้ไขสำเร็จ'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteRecipe(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ยืนยันการลบ"),
          content: const Text("คุณแน่ใจหรือไม่ว่าต้องการลบสูตรนี้?"),
          actions: [
            TextButton(
              child: const Text("ยกเลิก"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("ลบ", style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(id)
                    .delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
