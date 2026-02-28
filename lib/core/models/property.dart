class Property {
  final String id;
  final String title;
  final String description;
  final String type;
  final double rent;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final int parking;
  final List<String> images;
  final String image;
  final bool isFeatured;
  final String agent;
  final String? address;
  final DateTime? availableFrom;
  final double? lat;
  final double? lng;

  Property({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.rent,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    this.parking = 0,
    this.image = 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    this.images = const [],
    this.isFeatured = false,
    this.agent = 'Letting Experts',
    this.address,
    this.availableFrom,
    this.lat,
    this.lng,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final media = json['listing_media'] as List?;
    final images = media?.map((m) => m['url'].toString()).toList() ?? [];
    
    return Property(
      id: json['id'].toString(),
      title: json['title'] ?? 'N/A',
      description: json['description'] ?? '',
      type: json['property_type'] ?? 'Apartment',
      rent: (json['rent'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] ?? 'Unknown',
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      parking: json['parking'] ?? 0,
      image: images.isNotEmpty ? images.first : 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
      images: images,
      isFeatured: json['is_featured'] ?? false,
      agent: json['agent'] ?? 'Letting Experts',
      address: json['address'],
      availableFrom: json['available_from'] != null ? DateTime.tryParse(json['available_from']) : null,
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }
}
