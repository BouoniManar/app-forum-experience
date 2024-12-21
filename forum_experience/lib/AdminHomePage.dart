import 'package:flutter/material.dart';
import 'package:forum_experience/CategoryManagementPage.dart';
import 'package:forum_experience/UserManagementPage.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de Bord Admin"),
        backgroundColor: const Color.fromARGB(255, 150, 0, 117),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenue, Admin",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 150, 0, 117),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  
               _buildDashboardCard(
                  title: "Utilisateurs",
                  icon: Icons.person,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserManagementPage()),
                    );
                  },
                ),

                  _buildDashboardCard(
                    title: "Sujets",
                    icon: Icons.forum,
                    color: Colors.blue,
                    onTap: () {
                      // Navigation vers la modération des sujets
                    },
                  ),
                  _buildDashboardCard(
                    title: "Catégories",
                    icon: Icons.category,
                    color: Colors.orange,
                    onTap: () {
                                          // Navigation vers la gestion des catégories
                    },
                  ),
                _buildDashboardCard(
                  title: "Catégories",
                  icon: Icons.category,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryManagementPage()),
                    );
                  },
                ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
