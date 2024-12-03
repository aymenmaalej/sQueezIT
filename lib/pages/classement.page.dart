import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaderboardRef = FirebaseFirestore.instance
        .collection('leaderboard')
        .orderBy('totalScore', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Classement", style: TextStyle(color: Colors.orange)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: leaderboardRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error loading leaderboard: ${snapshot.error}");
            return Center(child: Text("Error loading leaderboard."));
          }

          final players = snapshot.data?.docs ?? [];

          if (players.isEmpty) {
            return Center(child: Text("No players found."));
          }

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Text("#${index + 1}" , style: TextStyle(fontSize: 15)),
                title: Text(player['username'] , style: TextStyle(color: Colors.orange)),
                trailing: Text(player['totalScore'].toString(), style: TextStyle(fontSize: 15)),
              );
            },
          );
        },
      ),
    );
  }
}
