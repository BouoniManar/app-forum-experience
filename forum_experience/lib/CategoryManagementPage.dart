import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CategoryManagementPage extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('categories');
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // Helper method to show SnackBar
  void _showSnackBar(String message) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _addCategory() async {
    if (_categoryController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      _showSnackBar("Le nom et la description de la catégorie ne peuvent pas être vides.");
      return;
    }

    try {
      await _databaseRef.push().set({
        'name': _categoryController.text.trim(),
        'description': _descriptionController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });

      _showSnackBar("Catégorie ajoutée avec succès !");
      _categoryController.clear();
      _descriptionController.clear();
    } catch (e) {
      _showSnackBar("Erreur lors de l'ajout : $e");
    }
  }

  void _editCategory(String key, String currentName, String currentDescription) {
    _categoryController.text = currentName;
    _descriptionController.text = currentDescription;

    showDialog(
      context: scaffoldMessengerKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier la Catégorie"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  hintText: "Nom de la catégorie",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: "Description de la catégorie",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _databaseRef.child(key).update({
                    'name': _categoryController.text.trim(),
                    'description': _descriptionController.text.trim(),
                  });

                  _showSnackBar("Catégorie modifiée avec succès !");
                  Navigator.pop(context);
                } catch (e) {
                  _showSnackBar("Erreur : $e");
                }
              },
              child: Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gestion des Catégories"),
          backgroundColor: const Color.fromARGB(255, 234, 0, 255),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Liste des Catégories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                  stream: _databaseRef.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Erreur : ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                      return Center(child: Text("Aucune catégorie disponible."));
                    }

                    final categories = Map<String, dynamic>.from(
                        snapshot.data!.snapshot.value as Map);

                    return ListView(
                      children: categories.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.value['name']),
                          subtitle: Text(entry.value['description'] ?? "Pas de description"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _editCategory(
                                    entry.key,
                                    entry.value['name'],
                                    entry.value['description'] ?? '',
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, entry.key);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Ajouter une Catégorie"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _categoryController,
                              decoration: InputDecoration(
                                hintText: "Nom de la catégorie",
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                hintText: "Description de la catégorie",
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Annuler"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _addCategory();
                              Navigator.pop(context);
                            },
                            child: Text("Ajouter"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Ajouter une Catégorie",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 0, 234),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirmation dialog for deleting a category
  void _showDeleteConfirmationDialog(BuildContext context, String key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous vraiment supprimer cette catégorie ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Non"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _databaseRef.child(key).remove();
                  _showSnackBar("Catégorie supprimée !");
                  Navigator.pop(context); // Close dialog after deleting
                } catch (e) {
                  _showSnackBar("Erreur : $e");
                }
              },
              child: Text("Oui"),
            ),
          ],
        );
      },
    );
  }
}
