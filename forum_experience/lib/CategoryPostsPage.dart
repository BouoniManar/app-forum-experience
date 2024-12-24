import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CategoryPostsPage extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  CategoryPostsPage({required this.categoryName, required this.categoryId});

  @override
  _CategoryPostsPageState createState() => _CategoryPostsPageState();
}

class _CategoryPostsPageState extends State<CategoryPostsPage> {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref().child('posts');
  List<Map<String, dynamic>> posts = [];

  // Fonction pour récupérer les posts pour une catégorie donnée
  void _fetchPosts() async {
    DatabaseEvent event = await _postsRef.orderByChild('category_id').equalTo(widget.categoryId).once();
    final postsData = event.snapshot.value as Map<dynamic, dynamic>?;

    if (postsData != null) {
      setState(() {
        posts = postsData.entries.map((entry) {
          return {
            'title': entry.value['title'],
            'description': entry.value['description'],
            'id': entry.key,
            'name': entry.value['name'],
            'user_avatar_url': entry.value['user_avatar_url'],
            'created_at': entry.value['created_at'],
          };
        }).toList();
      });
    }
  }

  // Fonction pour ajouter un post dans Firebase
  void _addPost(String title, String description) async {
    final newPostRef = _postsRef.push();
    await newPostRef.set({
      'title': title,
      'description': description,
      'category_id': widget.categoryId,
      'created_at': DateTime.now().toString(),
      'name': 'name',  // Remplacez par le nom de l'utilisateur actuel
      'user_avatar_url': 'URL de l\'avatar', // Remplacez par l'URL de l'avatar de l'utilisateur
    });

    _fetchPosts();
  }

  // Fonction pour afficher un formulaire d'ajout de post
  void _showAddPostDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter un post"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Titre du post"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description du post"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  _addPost(title, description);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez remplir tous les champs')),
                  );
                }
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: const Color.fromARGB(255, 150, 0, 105),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C1B6C), Color(0xFF6A0D3D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: posts.isEmpty
            ? Center(child: Text("Aucun post disponible."))
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Affichage du nom de l'utilisateur et de l'avatar en haut
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(post['user_avatar_url'] ?? 'URL de l\'avatar par défaut'),
                                radius: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                post['user_name'] ?? 'Utilisateur inconnu',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Affichage du titre et de la description du post
                          Text(
                            post['title'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(post['description']),
                          SizedBox(height: 10),
                          // Actions pour les commentaires et favoris
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.comment),
                                onPressed: () {
                                  // Action pour les commentaires
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {
                                  // Action pour ajouter aux favoris
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 150, 0, 105),
      ),
    );
  }
}
