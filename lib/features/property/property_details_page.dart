import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import '../../core/models/property.dart';
import '../../core/repositories/listing_repository.dart';

class PropertyDetailsPage extends ConsumerStatefulWidget {
  final Property property;

  const PropertyDetailsPage({super.key, required this.property});

  @override
  ConsumerState<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends ConsumerState<PropertyDetailsPage> {
  // Theme Colors
  static const Color lettingRed = Color(0xFFCE3132);
  static const Color expertBlack = Color(0xFF1C1C1C);
  
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final listingsAsync = ref.watch(listingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: CustomScrollView(
        slivers: [
          // 1. Premium Image Carousel Header
          SliverAppBar(
            expandedHeight: screenHeight * 0.45,
            pinned: true,
            backgroundColor: expertBlack,
            leading: _buildHeaderAction(Icons.arrow_back, () => Navigator.pop(context)),
            actions: [
              _buildHeaderAction(Icons.share_outlined, () {}),
              _buildHeaderAction(Icons.favorite_border, () {}),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemCount: widget.property.images.isNotEmpty ? widget.property.images.length : 1,
                    itemBuilder: (context, index) {
                      final url = widget.property.images.isNotEmpty ? widget.property.images[index] : widget.property.image;
                      return Hero(
                        tag: 'image_${widget.property.id}',
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.grey.shade800),
                        ),
                      );
                    },
                  ),
                  // Carousel Indicator
                  if (widget.property.images.length > 1)
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.property.images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: _currentImageIndex == index ? 24 : 6,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index ? lettingRed : Colors.white70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(100),
                          Colors.transparent,
                          Colors.black.withAlpha(120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. Property Details Body
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainHeader(),
                    const SizedBox(height: 30),
                    _buildQuickStats(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Description'),
                    const SizedBox(height: 12),
                    Text(
                      widget.property.description.isNotEmpty 
                        ? widget.property.description 
                        : 'Experience unparalleled luxury in this exquisite ${widget.property.type.toLowerCase()} located in the heart of ${widget.property.location}. Featuring modern finishes, expansive living areas, and breathtaking views, this property is designed for those who appreciate the finer things in life.',
                      style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Premium Features'),
                    const SizedBox(height: 16),
                    _buildFeaturesGrid(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Location'),
                    const SizedBox(height: 16),
                    _buildLocationMap(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Similar Properties'),
                    const SizedBox(height: 16),
                    _buildSimilarListings(listingsAsync),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withAlpha(80)),
            child: IconButton(icon: Icon(icon, color: Colors.white, size: 20), onPressed: onTap),
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.property.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: lettingRed),
                  const SizedBox(width: 4),
                  Text(widget.property.location, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: lettingRed.withAlpha(30), borderRadius: BorderRadius.circular(16), border: Border.all(color: lettingRed.withAlpha(100))),
          child: Text('R${widget.property.rent.toStringAsFixed(0)}\n/mo', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: lettingRed)),
        )
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickStat(Icons.king_bed, '${widget.property.bedrooms}', 'Beds'),
        _buildStatDivider(),
        _buildQuickStat(Icons.shower, '${widget.property.bathrooms}', 'Baths'),
        _buildStatDivider(),
        _buildQuickStat(Icons.square_foot, '2,400', 'Sq.Ft'),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {'icon': Icons.wifi, 'label': 'Fibre Ready'},
      {'icon': Icons.security, 'label': '24/7 Security'},
      {'icon': Icons.pool, 'label': 'Private Pool'},
      {'icon': Icons.local_parking, 'label': 'Secure Parking'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: features.length,
      itemBuilder: (context, index) => _buildFeaturePill(features[index]['icon'] as IconData, features[index]['label'] as String),
    );
  }

  Widget _buildLocationMap() {
    final lat = widget.property.lat ?? -25.8361;
    final lng = widget.property.lng ?? 28.1633;
    
    return Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withAlpha(20))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 15),
          markers: {Marker(markerId: const MarkerId('prop'), position: LatLng(lat, lng))},
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (controller) => controller.setMapStyle(_getMapStyle()),
        ),
      ),
    );
  }

  Widget _buildSimilarListings(AsyncValue<List<Property>> listingsAsync) {
    return SizedBox(
      height: 200,
      child: listingsAsync.when(
        data: (props) {
          final similar = props.where((p) => p.id != widget.property.id).take(5).toList();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            itemBuilder: (context, index) => _buildSimilarCard(similar[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: lettingRed)),
        error: (_, _) => const Text('Unable to load similar properties', style: TextStyle(color: Colors.white54)),
      ),
    );
  }

  Widget _buildSimilarCard(Property prop) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PropertyDetailsPage(property: prop))),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: CachedNetworkImage(imageUrl: prop.image, height: 100, width: 160, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('R${prop.rent.toStringAsFixed(0)}', style: const TextStyle(color: lettingRed, fontWeight: FontWeight.bold)),
                  Text(prop.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      decoration: BoxDecoration(color: expertBlack, boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 30, offset: const Offset(0, -10))]),
      child: Row(
        children: [
          _buildCircleButton(Icons.chat_bubble_outline),
          const SizedBox(width: 12),
          _buildCircleButton(Icons.phone_outlined),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: lettingRed, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 10),
              child: const Text('Book a Viewing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withAlpha(20))),
      child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: () {}),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
  Widget _buildQuickStat(IconData i, String v, String l) => Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF2C2C2C), shape: BoxShape.circle, border: Border.all(color: Colors.white.withAlpha(10))), child: Icon(i, color: Colors.grey.shade300, size: 24)), const SizedBox(height: 8), Text(v, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)), Text(l, style: TextStyle(color: Colors.grey.shade500, fontSize: 12))]);
  Widget _buildStatDivider() => Container(height: 40, width: 1, color: Colors.white.withAlpha(20));
  Widget _buildFeaturePill(IconData i, String l) => Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withAlpha(15))), child: Row(children: [Icon(i, size: 18, color: lettingRed.withAlpha(200)), const SizedBox(width: 8), Expanded(child: Text(l, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis))]));
  
  String _getMapStyle() => '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212121"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]}]';
}
