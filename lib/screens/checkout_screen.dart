import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();

  String _selectedCourier = 'JNE';
  String _selectedPayment = 'cod';
  bool _isSubmitting = false;

  final List<String> _couriers = ['JNE', 'J&T', 'SiCepat', 'POS Indonesia', 'ASFI Express'];
  final Map<String, String> _paymentMethods = {
    'cod': 'Cash on Delivery (COD)',
    'qris': 'QRIS Digital QR',
    'transfer_bca': 'Transfer Bank BCA',
    'transfer_mandiri': 'Transfer Bank Mandiri',
  };

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.user?.name ?? '');
    _emailController = TextEditingController(text: auth.user?.email ?? '');
  }

  void _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final cart = Provider.of<CartProvider>(context, listen: false);
    final itemsPayload = cart.items.map((item) {
      return {
        'product_id': item.product.id,
        'variant': item.variant,
        'qty': item.quantity,
        'price': item.product.price,
      };
    }).toList();

    final result = await ApiService.createOrder(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      province: _provinceController.text,
      courier: _selectedCourier,
      paymentMethod: _selectedPayment,
      items: itemsPayload,
      shippingCost: 15000, // standard delivery flat rate
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (result['success']) {
        cart.clearCart(); // Clear local shopping cart
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              orderNumber: result['order_number'],
              totalPrice: result['total'],
              qrisImage: result['qris_image'],
              qrisNumber: result['qris_number'],
              paymentMethod: _selectedPayment,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✗ ${result['message']}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final formattedSubtotal = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(cart.totalAmount);
    final formattedShipping = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(15000);
    final formattedTotal = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(cart.totalAmount + 15000);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13132B),
        elevation: 0,
        title: const Text('Checkout Pesanan', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shipping info card
              _buildSectionCard(
                title: '📍 Informasi Pengiriman',
                children: [
                  _buildLabel('NAMA PENERIMA'),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _buildInputDeco('Nama lengkap penerima'),
                    validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('EMAIL'),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _buildInputDeco('Alamat email'),
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('NOMOR TELEPON / WA'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _buildInputDeco('Contoh: 08123456789'),
                    validator: (v) => v!.isEmpty ? 'Nomor telepon wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('ALAMAT LENGKAP'),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _buildInputDeco('Nama jalan, nomor rumah, RT/RW, dll'),
                    validator: (v) => v!.isEmpty ? 'Alamat lengkap wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('KOTA / KABUPATEN'),
                            TextFormField(
                              controller: _cityController,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: _buildInputDeco('Kota asal'),
                              validator: (v) => v!.isEmpty ? 'Kota wajib' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('PROVINSI'),
                            TextFormField(
                              controller: _provinceController,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: _buildInputDeco('Provinsi'),
                              validator: (v) => v!.isEmpty ? 'Provinsi wajib' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Courier & payment section
              _buildSectionCard(
                title: '🚚 Pengiriman & Pembayaran',
                children: [
                  _buildLabel('PILIH JASA KIRIM (KURIR)'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCourier,
                        dropdownColor: const Color(0xFF13132B),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        isExpanded: true,
                        items: _couriers.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _selectedCourier = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('METODE PEMBAYARAN'),
                  Column(
                    children: _paymentMethods.entries.map((entry) {
                      return RadioListTile<String>(
                        value: entry.key,
                        groupValue: _selectedPayment,
                        title: Text(entry.value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        activeColor: const Color(0xFF6C63FF),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _selectedPayment = v!),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary card
              _buildSectionCard(
                title: '📊 Ringkasan Pembayaran',
                children: [
                  _buildSummaryRow('Subtotal Belanja', formattedSubtotal),
                  _buildSummaryRow('Biaya Kirim (Flat)', formattedShipping),
                  const Divider(color: Colors.white12, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                      Text(formattedTotal, style: const TextStyle(color: Color(0xFF43E97B), fontWeight: FontWeight.w900, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Action button
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
                  : ElevatedButton(
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43E97B),
                        foregroundColor: const Color(0xFF0D0D1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Buat Pesanan Sekarang', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13132B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
          const Divider(color: Colors.white12, height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF8888AA))),
    );
  }

  InputDecoration _buildInputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF0D0D1A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }

  Widget _buildSummaryRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8888AA), fontSize: 13, fontWeight: FontWeight.w600)),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
const TextDecoration textDecorationThrough = TextDecoration.lineThrough;
