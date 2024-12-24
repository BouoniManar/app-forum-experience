import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:forum_experience/CategoryPostsPage.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  // Référence à Firebase Realtime Database
  final DatabaseReference _categoriesRef = FirebaseDatabase.instance.ref().child('categories');
  
  // Liste pour stocker les catégories récupérées
  List<Map<String, dynamic>> categories = [];

  @override
  void dispose() {
    super.dispose();
    // Cancel any ongoing operations here if necessary
  }

  // Fonction pour récupérer les catégories depuis Firebase
  void _fetchCategories() async {
    DatabaseEvent event = await _categoriesRef.once();
    final categoriesData = event.snapshot.value as Map<dynamic, dynamic>?;

    if (categoriesData != null && mounted) { // Check if the widget is still in the tree
      setState(() {
        categories = categoriesData.entries.map((entry) {
          return {
            'name': entry.value['name'],
            'description': entry.value['description'],
            'created_at': entry.value['created_at'],
            'id': entry.key, // Ajouter l'ID de la catégorie
          };
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Appeler la fonction pour récupérer les catégories au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Home Page"),
        backgroundColor: const Color.fromARGB(255, 203, 95, 230),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 228, 134, 193), Color.fromARGB(255, 228, 107, 169)], // Fond dégradé mauve
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement si les données sont vides
            : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created at: ${category['created_at']}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            category['description'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      tileColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPostsPage(
                              categoryName: category['name'],
                              categoryId: category['id'],  // Utilisation de l'ID de la catégorie
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
