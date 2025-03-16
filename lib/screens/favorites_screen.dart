import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Map<String, dynamic>> _favoritedRecipes = [
    {
      'name': 'ต้มยำกุ้ง',
      'image': 'assets/images/tom_yum_kung.jpg',
      'duration': '30 นาที',
    },
    {
      'name': 'ผัดไทย',
      'image': 'assets/images/pad_thai.jpg',
      'duration': '25 นาที',
    },
    {
      'name': 'แกงเขียวหวาน',
      'image': 'assets/images/green_curry.jpg',
      'duration': '45 นาที',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการที่สนใจ')),
      body:
          _favoritedRecipes.isEmpty
              ? const Center(
                child: Text(
                  'ยังไม่มีรายการที่สนใจ',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _favoritedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _favoritedRecipes[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(recipe['image']),
                      ),
                      title: Text(recipe['name']),
                      subtitle: Text('เวลาทำ: ${recipe['duration']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _favoritedRecipes.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'นำ ${recipe['name']} ออกจากรายการที่สนใจแล้ว',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
