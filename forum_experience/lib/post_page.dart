import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/post.dart';

class PostPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Ajout d'un post
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
          DatabaseReference postsRef = FirebaseDatabase.instance.ref('posts');

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

  // Supprimer un post
  void _deletePost(String postId) async {
    try {
      DatabaseReference postRef = FirebaseDatabase.instance.ref('posts/$postId');
      await postRef.remove();
      print("Post deleted successfully!");
    } catch (e) {
      print("Failed to delete post: $e");
    }
  }

 // Modifier un post
void _editPost(BuildContext context, String postId, String currentTitle, String currentContent) {
  _titleController.text = currentTitle;
  _contentController.text = currentContent;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                // Mettre à jour le post dans la base de données
                DatabaseReference postRef = FirebaseDatabase.instance.ref('posts/$postId');
                await postRef.update({
                  'title': _titleController.text,
                  'message': _contentController.text,
                });

                // Fermer la boîte de dialogue et afficher un message de succès
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post updated successfully')));
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
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
              SizedBox(height: 30),
              // Affichage des posts
              FutureBuilder<DataSnapshot>(
                future: FirebaseDatabase.instance.ref('posts').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.value == null) {
                    return Center(child: Text('No posts available.'));
                  }

                  Map<dynamic, dynamic> posts = snapshot.data!.value as Map<dynamic, dynamic>;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts.values.toList()[index];
                      var postId = posts.keys.toList()[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(post['username']),
                          subtitle: Text(post['message']),
                          trailing: PopupMenuButton<String>(
  onSelected: (value) {
    if (value == 'edit') {
      _editPost(context, postId, post['title'], post['message']);
    } else if (value == 'delete') {
      _deletePost(postId);
    }
  },
  itemBuilder: (context) {
    return [
      PopupMenuItem<String>(
        value: 'edit',
        child: Text('Edit'),
      ),
      PopupMenuItem<String>(
        value: 'delete',
        child: Text('Delete'),
      ),
    ];
  },
)

                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
