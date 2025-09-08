import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import 'profile_form_page.dart';
import 'item_form_page.dart';
import 'comparison_page.dart';
import 'history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pitta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          if (state.selectedProfile != null)
            ListTile(
              title: Text('Profile: ${state.selectedProfile!.name}'),
              onTap: () => _selectProfile(context),
            ),
          ...state.history.take(5).map(
                (r) => ListTile(
                  title: Text(r.item.name),
                  subtitle: Text(r.comments().join(', ')),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ComparisonPage(record: r),
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Add Body Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileFormPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.checkroom),
              title: const Text('Add Clothing Size'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ItemFormPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectProfile(BuildContext context) {
    final state = context.read<AppState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Profile'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: state.profiles
                .map(
                  (p) => RadioListTile(
                    value: p,
                    groupValue: state.selectedProfile,
                    onChanged: (v) {
                      state.selectProfile(p);
                      Navigator.pop(ctx);
                    },
                    title: Text(p.name),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
