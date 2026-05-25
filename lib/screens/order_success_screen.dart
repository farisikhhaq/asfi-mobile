import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;
  final int totalPrice;
  final String? qrisImage;
  final String? qrisNumber;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.totalPrice,
    this.qrisImage,
    this.qrisNumber,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTotal = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(totalPrice);

    final isQris = paymentMethod == 'qris';
    final isTransfer = paymentMethod.startsWith('transfer_');

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // Success Icon Badge
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF43E97B).withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF43E97B), width: 2),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF43E97B),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Pesanan Berhasil Dibuat!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Terima kasih telah berbelanja di ASFI.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8888AA),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF13132B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    _buildRow('Nomor Order', orderNumber, color: const Color(0xFF6C63FF), isMonospace: true),
                    const Divider(color: Colors.white12, height: 24),
                    _buildRow('Metode Bayar', paymentMethod.toUpperCase().replaceAll('_', ' ')),
                    const Divider(color: Colors.white12, height: 24),
                    _buildRow('Total Tagihan', formattedTotal, color: const Color(0xFF43E97B), isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // QRIS Payment Box (If QRIS selected)
              if (isQris) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13132B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFFD93D).withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '📱 Pembayaran QRIS Toko',
                        style: TextStyle(color: Color(0xFFFFD93D), fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Silakan scan QR code di bawah menggunakan GoPay, OVO, Dana, LinkAja, atau m-Banking Anda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF8888AA), fontSize: 11, height: 1.4),
                      ),
                      const SizedBox(height: 20),

                      // QR Code Image
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: qrisImage != null && qrisImage!.isNotEmpty
                            ? Image.network(
                                qrisImage!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.qr_code_2, size: 100, color: Colors.black54),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.qr_code_2, size: 100, color: Colors.black54),
                              ),
                      ),
                      const SizedBox(height: 16),
                      if (qrisNumber != null) ...[
                        Text(
                          'ID Merchant: $qrisNumber',
                          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Bank Transfer Instructions
              if (isTransfer) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13132B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          '🏦 Instruksi Transfer Bank',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                      const Divider(color: Colors.white12, height: 24),
                      const Text(
                        '1. Lakukan transfer senilai total tagihan di atas.',
                        style: TextStyle(color: Color(0xFF8888AA), fontSize: 12, height: 1.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '2. Transfer ke rekening tujuan ${paymentMethod.toUpperCase().replaceAll('_', ' ')}.',
                        style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12, height: 1.5),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '3. Kirim bukti transfer di detail pesanan atau hubungi CS penjual.',
                        style: TextStyle(color: Color(0xFF8888AA), fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Home Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Kembali ke Beranda', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color, bool isMonospace = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8888AA), fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            fontFamily: isMonospace ? 'monospace' : null,
            fontSize: isBold ? 15 : 13,
          ),
        ),
      ],
    );
  }
}
