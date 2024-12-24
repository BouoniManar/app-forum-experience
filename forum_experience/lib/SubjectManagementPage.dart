import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SubjectManagementPage extends StatefulWidget {
  @override
  _SubjectManagementPageState createState() => _SubjectManagementPageState();
}

class _SubjectManagementPageState extends State<SubjectManagementPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child("posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Sujets"),
        backgroundColor: const Color.fromARGB(255, 236, 33, 243),
      ),
      body: StreamBuilder(
        stream: _database.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            final data = (snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>?;
            final posts = data != null ? data.entries.toList() : [];

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final postKey = posts[index].key;
                final postValue = posts[index].value as Map<dynamic, dynamic>;
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(postValue["title"] ?? "Titre manquant"),
                    subtitle: Text(postValue["description"] ?? "Description manquante"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            _showEditDialog(postKey, postValue);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(postKey);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Aucun sujet trouvé."));
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(String postKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous vraiment supprimer ce sujet ?"),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Supprimer"),
              onPressed: () {
                _database.child(postKey).remove();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(String postKey, Map<dynamic, dynamic> postValue) {
    final titleController = TextEditingController(text: postValue["title"]);
    final descriptionController = TextEditingController(text: postValue["description"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier le Sujet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Titre"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sauvegarder"),
              onPressed: () {
                _database.child(postKey).update({
                  "title": titleController.text,
                  "description": descriptionController.text,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
