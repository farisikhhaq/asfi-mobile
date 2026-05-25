import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedVariant;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants[0];
    }
  }

  void _increment() {
    if (_quantity < widget.product.stock) {
      setState(() => _quantity++);
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addToCart(widget.product, variant: _selectedVariant, quantity: _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${_quantity}x ${widget.product.name} masuk keranjang!'),
        backgroundColor: const Color(0xFF43E97B),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(p.price);

    final originalPriceStr = p.originalPrice != null
        ? NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(p.originalPrice)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13132B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Hero Image Banner
            Container(
              height: 300,
              color: Colors.black26,
              child: p.images.isNotEmpty
                  ? Image.network(
                      p.images[0],
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 72),
                    ),
            ),

            // Product Details Block
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13132B),
                      border: Border.all(color: Colors.white10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏪 ', style: TextStyle(fontSize: 12)),
                        Text(
                          p.storeName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (p.city != null) ...[
                          Text(
                            '  ·  📍 ${p.city}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8888AA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF43E97B),
                        ),
                      ),
                      if (originalPriceStr != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          originalPriceStr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8888AA),
                            decoration: textDecorationThrough,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating, reviews, sold
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD93D), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        p.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFFD93D),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${p.reviewCount} ulasan)',
                        style: const TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        '${p.totalSold} terjual',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 32),

                  // Select Variant (if any exist)
                  if (p.variants.isNotEmpty) ...[
                    const Text(
                      'PILIH VARIAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8888AA),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: p.variants.length,
                        itemBuilder: (context, i) {
                          final variant = p.variants[i];
                          final isSelected = _selectedVariant == variant;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                variant,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF8888AA),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedVariant = variant),
                              backgroundColor: const Color(0xFF13132B),
                              selectedColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected ? Colors.transparent : Colors.white10,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(color: Colors.white12, height: 32),
                  ],

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'JUMLAH BELANJA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8888AA),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stok tersedia: ${p.stock}',
                            style: TextStyle(
                              fontSize: 12,
                              color: p.stock <= 5 ? const Color(0xFFFF6584) : const Color(0xFF8888AA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF13132B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white70, size: 18),
                              onPressed: _decrement,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white, size: 18),
                              onPressed: _increment,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 32),

                  // Description
                  const Text(
                    'DESKRIPSI PRODUK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8888AA),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.description ?? 'Belum ada deskripsi produk.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Technical Specifications / Meta
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13132B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        _buildMetaRow('Kategori', p.category),
                        _buildMetaRow('Berat Produk', '${p.weight} gram'),
                        _buildMetaRow('Asal Pengiriman', p.city ?? 'Indonesia'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF13132B),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: p.stock > 0 ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  p.stock > 0 ? 'Tambah ke Keranjang' : 'Stok Habis',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8888AA), fontSize: 13, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
