import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final c = Supabase.instance.client;
  bool loading = true;
  List<dynamic> rows = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await c.from('listings')
        .select('id,title,description,rent,bedrooms,bathrooms')
        .eq('is_active', true)
        .limit(50);
      setState(() { rows = res; loading = false; });
    } catch (_) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Find Rentals')),
      body: ListView.separated(
        itemCount: rows.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final l = rows[i] as Map<String, dynamic>;
          return ListTile(
            title: Text(l['title'] ?? 'Untitled'),
            subtitle: Text('R${l['rent'] ?? 0}  ${(l['bedrooms'] ?? 0).toString()} bd  ${(l['bathrooms'] ?? 0).toString()} ba'),
          );
        },
      ),
    );
  }
}
