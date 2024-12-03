import 'package:flutter/material.dart';

class ClassementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading leaderboard'));
          }

          final leaderboard = snapshot.data ?? [];

          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final player = leaderboard[index];
              return ListTile(
                leading: Text('#${index + 1}'),
                title: Text(player['name']),
                trailing: Text(player['score'].toString()),
              );
            },
          );
        },
      ),
    );
  }

  getLeaderboard() {}
}
