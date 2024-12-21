import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/post.dart';

class PostPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addPost(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Récupérer l'utilisateur authentifié
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Créer un objet Post
          Post newPost = Post(
            userId: user.uid, // L'ID de l'utilisateur authentifié
            username: user.displayName ?? 'Anonymous', // Nom d'utilisateur ou 'Anonymous'
            message: _contentController.text.trim(),
            timestamp: DateTime.now().toIso8601String(), // Timestamp actuel
          );

          // Référence à la Realtime Database
          DatabaseReference postsRef = FirebaseDatabase.instance.ref('posts'); // Corrected class name

          // Ajouter le post dans la Realtime Database
          await postsRef.push().set(newPost.toJson());

          // Afficher un message de confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post added successfully!')),
          );

          // Réinitialiser les champs du formulaire
          _titleController.clear();
          _contentController.clear();
        } else {
          // Afficher un message si l'utilisateur n'est pas authentifié
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User is not authenticated')),
          );
        }
      } catch (e) {
        // Afficher un message d'erreur en cas d'échec
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add post: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        backgroundColor: const Color.fromARGB(255, 150, 0, 117),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _addPost(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(255, 150, 0, 117),
                ),
                child: Text(
                  'Add Post',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
