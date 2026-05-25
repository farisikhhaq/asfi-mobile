import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = '';
  String _sortBy = 'popular';

  final List<String> _categories = [
    'Fashion',
    'Elektronik',
    'Makanan & Minuman',
    'Kecantikan',
    'Kesehatan',
    'Olahraga',
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final list = await ApiService.getProducts(
      query: _searchQuery,
      category: _selectedCategory,
      sortBy: _sortBy,
    );
    setState(() {
      _products = list;
      _isLoading = false;
    });
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    _fetchProducts();
  }

  void _onCategorySelect(String cat) {
    setState(() {
      _selectedCategory = _selectedCategory == cat ? '' : cat;
    });
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final isAuth = auth.isAuthenticated;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF13132B),
        elevation: 0,
        title: const Text(
          'ASFI Marketplace',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),
        ),
        actions: [
          // Shopping Cart Button with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6584),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header / Wallet Card (Gopay style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            color: const Color(0xFF13132B),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFFF6584)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ASFI Pay',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        isAuth ? 'Rp 1.500.000' : 'Rp -',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WalletAction(icon: Icons.arrow_upward, label: 'Bayar'),
                      _WalletAction(icon: Icons.add_circle_outline, label: 'Top Up'),
                      _WalletAction(icon: Icons.local_activity, label: 'Promo'),
                      _WalletAction(icon: Icons.more_horiz, label: 'Lainnya'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Menu Grid
          Container(
            color: const Color(0xFF13132B),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              children: [
                _MenuIcon(icon: Icons.fastfood, label: 'ASFI Food', color: Colors.orange),
                _MenuIcon(icon: Icons.local_mall, label: 'ASFI Mall', color: Colors.blue),
                _MenuIcon(icon: Icons.local_taxi, label: 'ASFI Ride', color: Colors.green),
                _MenuIcon(icon: Icons.delivery_dining, label: 'ASFI Send', color: Colors.green),
                _MenuIcon(icon: Icons.phone_android, label: 'Pulsa', color: Colors.lightBlue),
                _MenuIcon(icon: Icons.movie, label: 'Hiburan', color: Colors.purple),
                _MenuIcon(icon: Icons.receipt, label: 'Tagihan', color: Colors.redAccent),
                _MenuIcon(icon: Icons.apps, label: 'Lainnya', color: Colors.grey),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          // Search & Filter Box
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF13132B),
            child: Column(
              children: [
                // Search Input
                TextField(
                  onSubmitted: _onSearch,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari produk atau toko...',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D0D1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Category badges
                SizedBox(
                  height: 34,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, i) {
                      final cat = _categories[i];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF8888AA),
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => _onCategorySelect(cat),
                          backgroundColor: const Color(0xFF0D0D1A),
                          selectedColor: const Color(0xFF6C63FF),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : Colors.white10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Sorting & Stats Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_products.length} Produk Ditemukan',
                  style: const TextStyle(color: Color(0xFF8888AA), fontWeight: FontWeight.w600, fontSize: 13),
                ),
                // Sort Dropdown
                DropdownButton<String>(
                  value: _sortBy,
                  dropdownColor: const Color(0xFF13132B),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.filter_list, color: Color(0xFF6C63FF), size: 18),
                  items: const [
                    DropdownMenuItem(value: 'popular', child: Text('Terpopuler  ')),
                    DropdownMenuItem(value: 'price_asc', child: Text('Harga Terendah  ')),
                    DropdownMenuItem(value: 'price_desc', child: Text('Harga Tertinggi  ')),
                    DropdownMenuItem(value: 'rating', child: Text('Rating Tertinggi  ')),
                    DropdownMenuItem(value: 'newest', child: Text('Terbaru  ')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _sortBy = val);
                      _fetchProducts();
                    }
                  },
                ),
              ],
            ),
          ),

          // Product List Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📦', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            const Text(
                              'Produk tidak ditemukan',
                              style: TextStyle(color: Color(0xFF8888AA), fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedCategory = '';
                                });
                                _fetchProducts();
                              },
                              child: const Text('Reset Pencarian', style: TextStyle(color: Color(0xFF6C63FF))),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final p = _products[index];
                          final formattedPrice = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          ).format(p.price);

                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF13132B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Product Image
                                  Expanded(
                                    child: Container(
                                      color: Colors.black12,
                                      child: p.images.isNotEmpty
                                          ? Image.network(
                                              p.images[0],
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Icon(Icons.image_not_supported, color: Colors.white24, size: 36),
                                              ),
                                            )
                                          : const Center(
                                              child: Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 36),
                                            ),
                                    ),
                                  ),

                                  // Details Card
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Store Name
                                        Row(
                                          children: [
                                            const Text(
                                              '🏪 ',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Expanded(
                                              child: Text(
                                                p.storeName,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF8888AA),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

                                        // Product Title
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),

                                        // Price tag
                                        Text(
                                          formattedPrice,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF43E97B),
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        // Info Footer
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.star, color: Color(0xFFFFD93D), size: 14),
                                                const SizedBox(width: 2),
                                                Text(
                                                  p.rating.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFFFFD93D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${p.totalSold} terjual',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF8888AA),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _WalletAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WalletAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MenuIcon({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
