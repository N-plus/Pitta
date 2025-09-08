import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import 'comparison_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        itemCount: state.history.length,
        itemBuilder: (context, index) {
          final record = state.history[index];
          return ListTile(
            title: Text(record.item.name),
            subtitle: Text(record.comments().join(', ')),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ComparisonPage(record: record),
              ),
            ),
          );
        },
      ),
    );
  }
}
