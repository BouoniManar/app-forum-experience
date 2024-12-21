import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  // Reference to the Realtime Database
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Utilisateurs'),
        backgroundColor: const Color.fromARGB(255, 150, 0, 105),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addUser(context); // Call the add user method
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Retrieve the list of users from the snapshot
            final usersMap = (snapshot.data! as DatabaseEvent).snapshot.value
                as Map<dynamic, dynamic>?;

            if (usersMap == null || usersMap.isEmpty) {
              return Center(child: Text('Aucun utilisateur trouvé.'));
            }

            final userList = usersMap.entries.toList();

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final userId = userList[index].key;
                final userInfo = userList[index].value;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      userInfo['email'] ?? 'Utilisateur',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userInfo['role'] != null
                          ? 'Rôle : ${userInfo['role']}'
                          : 'Utilisateur',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmDeleteUser(context, userId);
                        } else if (value == 'edit') {
                          _editUser(context, userId, userInfo);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Modifier'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Supprimer'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Aucun utilisateur trouvé.'));
          }
        },
      ),
    );
  }

  // Method to show a confirmation dialog before deleting a user
  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(context, userId); // Call the delete method after confirmation
            },
            child: Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Method to delete a user from the database
  void _deleteUser(BuildContext context, String userId) {
    databaseReference.child(userId).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utilisateur supprimé avec succès.')),
    );
  }

  // Method to edit user details
  void _editUser(BuildContext context, String userId, Map userInfo) {
    final emailController = TextEditingController(text: userInfo['email']);
    final roleController = TextEditingController(text: userInfo['role'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier Utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Rôle'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              databaseReference.child(userId).update({
                'email': emailController.text,
                'role': roleController.text.isNotEmpty
                    ? roleController.text
                    : null, // Remove role if empty
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Utilisateur modifié avec succès.')),
              );
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  // Method to add a new user
  void _addUser(BuildContext context) {
    final emailController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter Utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Rôle'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newUserId = databaseReference.push().key;
              databaseReference.child(newUserId!).set({
                'email': emailController.text,
                'role': roleController.text.isNotEmpty
                    ? roleController.text
                    : null, // Optional role
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Nouvel utilisateur ajouté avec succès.')),
              );
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
