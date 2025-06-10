import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/supabase_service.dart';
import 'marketplace_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'product_detail_page.dart';
import '../presentation/providers/product_provider.dart'; // Import ProductProvider
import '../domain/entities/product.dart'; // Import Product entity
import '../core/utils/color_converter.dart'; // Import color converter
import 'dart:async'; // Import for Timer
import '../presentation/providers/theme_provider.dart'; // Import ThemeProvider

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String shippingPrice;
  final VoidCallback onTap;
  final String description;
  final double rating;
  final int reviews;
  final List<String> varieties;
  final List<String> weights;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.shippingPrice,
    required this.onTap,
    this.description = '',
    this.rating = 0.0,
    this.reviews = 0,
    this.varieties = const [],
    this.weights = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                ),
              ),
              SizedBox(
                height: 102,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shippingPrice,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  late Timer _timer;

  final List<String> _carouselImages = [
    'assets/images/Farm_produce1.jpg',
    'assets/images/Farm_produce2.jpg',
    'assets/images/Farm_produce3.jpg',
    'assets/images/Farm_produce4.jpg',
    'assets/images/Farm_produce5.jpg',
    'assets/images/Farm_produce6.jpg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _buildHomePageContent(),
      const MarketplacePage(),
      const SearchPage(),
      const ProfilePage(),
    ];
    // Fetch products when the page initializes
    Future.microtask(() => Provider.of<ProductProvider>(context, listen: false).fetchProducts());

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= _carouselImages.length) {
          nextPage = 0; // Loop back to the first page
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Lima Soko',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 180.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _carouselImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(_carouselImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          _buildDashboardCard(
            title: 'Browse Products',
            icon: Icons.shopping_bag,
            onTap: () {
              _onItemTapped(1);
            },
          ),
          const SizedBox(height: 16),
          _buildDashboardCard(
            title: 'My Orders',
            icon: Icons.receipt_long,
            onTap: () {
              // Navigate to orders
              
            },
          ),
          const SizedBox(height: 16),
          _buildDashboardCard(
            title: 'Favorites',
            icon: Icons.favorite,
            onTap: () {
              // Navigate to favorites
            },
          ),
          const SizedBox(height: 20),

          const Text(
            'Recent Offers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (productProvider.errorMessage != null) {
                return Center(child: Text('Error: ${productProvider.errorMessage}'));
              } else if (productProvider.products.isEmpty) {
                return const Center(child: Text('No products available.'));
              } else {
                return SizedBox(
                  height: 204,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.products.length, // Use dynamic product count
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ProductCard(
                        imageUrl: product.images.isNotEmpty ? product.images[0] : 'https://via.placeholder.com/150',
                        title: product.name,
                        subtitle: product.description.length > 50 ? product.description.substring(0, 50) + '...' : product.description,
                        shippingPrice: '\${product.price.toStringAsFixed(2)} per lb', // Assuming price is per lb
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product, // Pass the Product object directly
                              ),
                            ),
                          );
                        },
                        description: product.description,
                        rating: product.rating,
                        reviews: product.reviews,
                        varieties: product.varieties,
                        weights: product.weights,
                      );
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: const Text(
                'Lima Soko',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _onItemTapped(2);
            },
          ),
          const Center(child: Text('User Name')),
          const SizedBox(width: 8),
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/farmer1.jpg'),
              child: Icon(Icons.person),
            ),
            onPressed: () {
              _onItemTapped(3);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}