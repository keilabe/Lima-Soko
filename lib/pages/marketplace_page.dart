import 'package:flutter/material.dart';
import 'package:lima_soko/core/services/mock_data_service.dart';
import 'package:lima_soko/domain/entities/product.dart';
import 'package:provider/provider.dart';
import 'package:lima_soko/presentation/providers/product_provider.dart';
import 'package:lima_soko/presentation/providers/cart_provider.dart';
import 'package:lima_soko/pages/cart_page.dart';
import 'package:lima_soko/pages/product_detail_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String? selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = MockDataService.getMockProducts();
  }

  void _filterProducts() {
    setState(() {
      if (selectedCategoryId != null) {
        _filteredProducts = MockDataService.getProductsByCategory(selectedCategoryId!);
      } else {
        _filteredProducts = MockDataService.getMockProducts();
      }

      if (_searchController.text.isNotEmpty) {
        _filteredProducts = MockDataService.searchProducts(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProducts();
                        },
                      )
                    : null,
              ),
              onChanged: (value) => _filterProducts(),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockDataService.mockCategories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: selectedCategoryId == null,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategoryId = null;
                          _filterProducts();
                        });
                      },
                    ),
                  );
                }
                final category = MockDataService.mockCategories[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category['name']),
                    selected: selectedCategoryId == category['id'],
                    onSelected: (selected) {
                      setState(() {
                        selectedCategoryId = selected ? category['id'] : null;
                        _filterProducts();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products found'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero, // Remove card margin to maximize space
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 200, // Minimum card height
            maxHeight: 240, // Maximum card height
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section (40% of card)
              Flexible(
                flex: 4,
                child: Container(
                  color: Colors.grey[200],
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.image_not_supported, size: 40),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(Icons.image, size: 40),
                        ),
                ),
              ),
              // Content section (60% of card)
              Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name and price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'R\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      // Add to cart button
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          onPressed: product.stockQuantity > 0
                              ? () {
                                  Provider.of<CartProvider>(context, listen: false)
                                      .addItem(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} added to cart'),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'View Cart',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const CartPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: const Text('ADD TO CART'),
                        ),
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