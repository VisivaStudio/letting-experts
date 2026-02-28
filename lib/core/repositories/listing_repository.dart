import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property.dart';

final listingRepositoryProvider = Provider((ref) => ListingRepository(Supabase.instance.client));

class ListingRepository {
  final SupabaseClient _client;
  ListingRepository(this._client);

  Future<List<Property>> fetchListings() async {
    try {
      final response = await _client
          .from('listings')
          .select('*, listing_media(*), areas(name, city)')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List).map((data) {
        final area = data['areas'];
        final location = area != null ? "${area['name']}, ${area['city']}" : (data['location'] ?? "Unknown");
        
        // Merge area into data for fromJson
        final enrichedData = Map<String, dynamic>.from(data);
        enrichedData['location'] = location;
        // Assume coords maps to lat/lng for now or add them manually if they exist as separate columns
        
        return Property.fromJson(enrichedData);
      }).toList();
    } catch (e) {
      print('Supabase Exception: $e');
      return [];
    }
  }

  Stream<List<Property>> watchListings() {
    return _client
        .from('listings')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => Property.fromJson(item)).toList());
  }
}

final listingsProvider = FutureProvider<List<Property>>((ref) {
  return ref.watch(listingRepositoryProvider).fetchListings();
});
