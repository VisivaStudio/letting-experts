import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property.dart';

final listingRepositoryProvider = Provider((ref) => ListingRepository(Supabase.instance.client));

class ListingRepository {
  final SupabaseClient _client;
  ListingRepository(this._client);

  Future<List<Property>> fetchListings() async {
    try {
      print('DEBUG: Attempting to fetch listings from Supabase...');
      final response = await _client
          .from('listings')
          .select('*, listing_media(*), areas(name, city)')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      print('DEBUG: Supabase Response received. Row count: ${response is List ? response.length : 0}');
      
      final props = (response as List).map((data) {
        final area = data['areas'] as Map<String, dynamic>?;
        final location = area != null ? "${area['name']}, ${area['city']}" : (data['location'] ?? "Unknown");
        
        final enrichedData = Map<String, dynamic>.from(data);
        enrichedData['location'] = location;
        
        return Property.fromJson(enrichedData);
      }).toList();

      print('DEBUG: Successfully parsed ${props.length} properties.');
      return props;
    } catch (e) {
      print('Supabase CRITICAL Exception: $e');
      if (e.toString().contains('PGRST205')) {
        print('HINT: This error means the Schema Cache is outdated. Please click "Reload PostgREST" in Supabase Settings.');
      }
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
