import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/property.dart';
import '../../core/repositories/listing_repository.dart';
import '../property/property_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Navigation State
  int _currentIndex = 0;
  
  // App Theme Colors (Dark Mode)
  static const Color lettingRed = Color(0xFFCE3132);
  static const Color expertBlack = Color(0xFF1C1C1C);
  static const Color mediumGrey = Color(0xFF2C2C2C);
  static const Color unselectedGrey = Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mediumGrey,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ExploreView(),
          PlaceholderView(title: 'Saved Properties', icon: Icons.favorite),
          PlaceholderView(title: 'Messages', icon: Icons.chat_bubble),
          PlaceholderView(title: 'Profile', icon: Icons.person),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: expertBlack,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.search, 'Explore'),
              _buildNavItem(1, Icons.favorite_border, 'Saved'),
              _buildNavItem(2, Icons.chat_bubble_outline, 'Messages'),
              _buildNavItem(3, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? lettingRed.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? lettingRed : unselectedGrey),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: lettingRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  String _selectedCategory = 'All';
  bool _showMap = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(listingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      drawer: _buildPremiumDrawer(context),
      body: listingsAsync.when(
        data: (properties) {
          final filtered = _selectedCategory == 'All' 
            ? properties 
            : properties.where((p) => p.type == _selectedCategory).toList();

          return _showMap ? _buildMapView(filtered) : _buildListView(filtered);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFCE3132))),
        error: (err, stack) => Center(child: Text('Live Error: $err', style: const TextStyle(color: Colors.white))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showMap = !_showMap),
        backgroundColor: const Color(0xFFCE3132),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(_showMap ? Icons.format_list_bulleted : Icons.map, color: Colors.white),
        label: Text(_showMap ? 'List View' : 'Map View', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildListView(List<Property> properties) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: _buildCategories(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: properties.isEmpty 
              ? const SliverFillRemaining(child: Center(child: Text("No properties found in this category.", style: TextStyle(color: Colors.white54))))
              : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPropertyCard(properties[index]),
              childCount: properties.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  Widget _buildMapView(List<Property> properties) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(color: Colors.black.withAlpha(120)),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search map area...',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) => _launchURL('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(val)}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (properties.isNotEmpty)
                Container(
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 100),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: properties.length,
                    itemBuilder: (ctx, i) => _buildMapCard(properties[i]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapCard(Property prop) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsPage(property: prop))),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: prop.image,
                width: 110,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R${prop.rent.toStringAsFixed(0)}',
                      style: const TextStyle(color: Color(0xFFCE3132), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prop.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.white54),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            prop.location,
                            style: const TextStyle(color: Colors.white54, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1C),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Image.asset('assets/images/logo_primary.png', height: 50, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.apartment, color: Color(0xFFCE3132), size: 30)),
                  ),
                  const SizedBox(width: 16),
                  const Text('MENU', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4)),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildDrawerItem(context, Icons.info_outline, 'About Us', Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Our Story',
                        style: TextStyle(color: Color(0xFFCE3132), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Letting Experts was founded on a simple yet powerful principle: property management should be synonymous with peace of mind. As a premier real estate agency in South Africa, we have spent years refining the art of connecting discerning tenants with exceptional homes.',
                        style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Our Core Values',
                        style: TextStyle(color: Color(0xFFCE3132), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      _buildValueItem(Icons.auto_awesome_outlined, 'God', 'Guided by faith and spiritual principles in all our dealings.'),
                      _buildValueItem(Icons.handshake_outlined, 'Commitment', 'Long-term relationships over short-term gains.'),
                      _buildValueItem(Icons.verified_user_outlined, 'Integrity', 'Transparency in every contract and interaction.'),
                      const SizedBox(height: 20),
                      const Text(
                        'Specialized Services',
                        style: TextStyle(color: Color(0xFFCE3132), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Premium Residential Rentals\n• Portfolio Management\n• Tenant Vetting & Placement\n• Corporate Relocation Services',
                        style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.8),
                      ),
                    ],
                  )),
                  _buildDrawerItem(context, Icons.location_on_outlined, 'Where We Are Situated', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Head Office', style: TextStyle(color: Color(0xFFCE3132), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.map, color: Colors.white), title: const Text('1030 Saxby Avenue,\nEldoraigne, Centurion,\nPretoria, 0157', style: TextStyle(color: Colors.white, height: 1.5, decoration: TextDecoration.underline)), onTap: () => _launchURL('https://www.google.com/maps/search/?api=1&query=1030+Saxby+Avenue,+Centurion')),
                    const SizedBox(height: 16),
                    const Text('Other Branches', style: TextStyle(color: Color(0xFFCE3132), fontWeight: FontWeight.bold)),
                    const Text('Pretoria East | Midrand | Stellenbosch', style: TextStyle(color: Colors.white70)),
                  ])),
                  _buildDrawerItem(context, Icons.people_outline, 'Staff Directory', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Our dedicated property experts:', style: TextStyle(color: Colors.white70, height: 1.5)),
                    const SizedBox(height: 16),
                    _buildAgentTile('Quinton Milligan', 'assets/images/agents/quinton.jpg'),
                    _buildAgentTile('Pieter Jordaan', 'assets/images/agents/pieter.jpg'),
                    _buildAgentTile('Fathima Arlington', 'assets/images/agents/fathima.jpg'),
                    _buildAgentTile('Nadine', 'assets/images/agents/nadine.jpg'),
                    _buildAgentTile('Dylan Du Toit', 'assets/images/agents/dylan.jpg'),
                    _buildAgentTile('Suanita Joubert', 'assets/images/agents/suanita.jpg'),
                    _buildAgentTile('Crowther Fourie', 'assets/images/agents/crowther.jpg'),
                    _buildAgentTile('Quinton Rall', 'assets/images/agents/quinton_rall.jpg'),
                    const Text('\nAnd more in our national network...', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)),
                  ])),
                  _buildDrawerItem(context, Icons.contact_support_outlined, 'Contact Details', const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Phone: +27 12 660 2203', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Email: info@lettingexperts.co.za', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Hours: Mon-Fri 08:30 - 17:00 / Sat 09:00 - 12:00', style: TextStyle(color: Colors.white70)),
                  ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('© 2026 Letting Experts.\nPremium Real Estate.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withAlpha(40), fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(context, IconData icon, String title, Widget content) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFCE3132)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        _showPremiumDialog(context, title, icon, content);
      },
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
    );
  }

  Widget _buildValueItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFCE3132), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentTile(String name, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: imagePath.startsWith('http') ? CachedNetworkImageProvider(imagePath) : AssetImage(imagePath) as ImageProvider,
          ),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showPremiumDialog(BuildContext context, String title, IconData icon, Widget content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withAlpha(20))),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [Icon(icon, color: const Color(0xFFCE3132), size: 24), const SizedBox(width: 12), Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
                  ]),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child: Divider(color: Colors.white24, height: 1)),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: content,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) debugPrint('Could not launch $url');
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 440,
      pinned: true,
      backgroundColor: const Color(0xFF1C1C1C),
      leading: Builder(builder: (context) => IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black.withAlpha(60), shape: BoxShape.circle), child: const Icon(Icons.menu, color: Colors.white)), onPressed: () => Scaffold.of(context).openDrawer())),
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double offset = 0.0;
            if (_scrollController.hasClients) {
              offset = _scrollController.offset * 0.5; // Parallax factor
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                // Implementing 'background-attachment: fixed' feel via parallax offset
                Transform.translate(
                  offset: Offset(0, offset),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
                // Implementing the 270deg linear-gradient mask
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(200),
                        Colors.black.withAlpha(0),
                        const Color(0xFF1C1C1C),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(color: Colors.black),
                ),
                // Subtle dark overlay for readability
                Container(color: Colors.black.withAlpha(40)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Image.asset('assets/images/logo_primary.png', height: 60, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.apartment, color: Color(0xFFCE3132), size: 40))),
                            Row(children: [_buildHeaderIconButton(Icons.facebook, () => _launchURL('https://www.facebook.com/LettingExperts/')), const SizedBox(width: 8), _buildHeaderIconButton(Icons.language, () => _launchURL('https://lettingexperts.co.za'))]),
                          ],
                        ),
                        const Spacer(),
                        const Text('Discover\nPremium Living.', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            _buildBranchPill(Icons.star, 'Centurion HQ', 'https://www.google.com/maps/search/?api=1&query=1030+Saxby+Avenue,+Centurion'),
                            _buildBranchPill(Icons.location_on, 'Pretoria East', 'https://www.google.com/maps/search/?api=1&query=Pretoria+East'),
                            _buildBranchPill(Icons.location_on, 'Midrand', 'https://www.google.com/maps/search/?api=1&query=Midrand'),
                            _buildBranchPill(Icons.location_on, 'Stellenbosch', 'https://www.google.com/maps/search/?api=1&query=Stellenbosch'),
                          ]),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              height: 65,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(color: Colors.black.withAlpha(120), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withAlpha(40), width: 1)),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, color: Colors.white, size: 28),
                                  const SizedBox(width: 16),
                                  Expanded(child: TextField(style: const TextStyle(color: Colors.white, fontSize: 16), decoration: const InputDecoration(hintText: 'Where to next?', hintStyle: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500), border: InputBorder.none), onSubmitted: (v) => _launchURL('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(v)}'))),
                                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFCE3132), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.tune, color: Colors.white, size: 24)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black.withAlpha(100), shape: BoxShape.circle, border: Border.all(color: Colors.white.withAlpha(30))), child: Icon(icon, color: Colors.white, size: 20)));
  }

  Widget _buildBranchPill(IconData icon, String label, String url) {
    return GestureDetector(onTap: () => _launchURL(url), child: Container(margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white.withAlpha(20), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withAlpha(30))), child: Row(children: [Icon(icon, color: const Color(0xFFCE3132), size: 14), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))])));
  }

  Widget _buildCategories() {
    final categories = ['All', 'Houses', 'Apartments', 'Commercial', 'Villas'];
    return SizedBox(height: 44, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: categories.length, itemBuilder: (context, index) { final isSelected = _selectedCategory == categories[index]; return Padding(padding: const EdgeInsets.only(right: 12.0), child: InkWell(onTap: () => setState(() => _selectedCategory = categories[index]), borderRadius: BorderRadius.circular(24), child: AnimatedContainer(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), decoration: BoxDecoration(color: isSelected ? const Color(0xFFCE3132) : const Color(0xFF383838), borderRadius: BorderRadius.circular(24), boxShadow: isSelected ? [BoxShadow(color: const Color(0xFFCE3132).withAlpha(100), blurRadius: 12, offset: const Offset(0, 4))] : []), child: Center(child: Text(categories[index], style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, letterSpacing: 0.5)))))); }));
  }

  Widget _buildPropertyCard(Property property) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsPage(property: property))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 28.0),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 25, offset: const Offset(0, 15))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(tag: 'image_${property.id}', child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), child: CachedNetworkImage(imageUrl: property.image, height: 240, width: double.infinity, fit: BoxFit.cover))),
              Positioned.fill(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), gradient: LinearGradient(colors: [Colors.black.withAlpha(150), Colors.transparent, Colors.black.withAlpha(80)], begin: Alignment.topCenter, end: Alignment.bottomCenter)))),
              if (property.isFeatured) Positioned(top: 20, left: 20, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFCE3132).withAlpha(200)), child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)))))),
              Positioned(top: 20, right: 20, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withAlpha(40)), child: const Icon(Icons.favorite_border, color: Colors.white, size: 22))))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('R${property.rent.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)), const Row(children: [Icon(Icons.star, color: Color(0xFFFFD700), size: 20), SizedBox(width: 4), Text('4.9', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow, fontSize: 16))])]),
                const SizedBox(height: 12),
                Text(property.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Row(children: [Icon(Icons.location_on, size: 18, color: const Color(0xFFCE3132).withAlpha(200)), const SizedBox(width: 6), Text(property.location, style: TextStyle(color: Colors.grey.shade400, fontSize: 15))]),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildFeature(Icons.king_bed, '${property.bedrooms} Beds'), _buildFeature(Icons.shower, '${property.bathrooms} Baths'), _buildFeature(Icons.square_foot, '2,400 sq.ft')]),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withAlpha(20))),
      child: Row(children: [Icon(icon, size: 18, color: Colors.grey.shade400), const SizedBox(width: 8), Text(label, style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w600, fontSize: 13))]),
    );
  }
}

class PlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderView({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.white.withAlpha(50)),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text('This view is currently under development.', style: TextStyle(color: Colors.grey.shade500))
        ],
      ),
    );
  }
}
