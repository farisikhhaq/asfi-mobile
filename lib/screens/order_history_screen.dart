import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final list = await ApiService.getOrders();
    setState(() {
      _orders = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13132B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('📋', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada transaksi pembelian',
                        style: TextStyle(color: Color(0xFF8888AA), fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final o = _orders[index];
                    final formattedTotal = NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(o.total);

                    // Map status to nice colors
                    Color statusColor = const Color(0xFFFFD93D); // yellow for pending
                    String statusLabel = '⏳ Menunggu';
                    if (o.status == 'processing') {
                      statusColor = const Color(0xFF8B85FF); // purple
                      statusLabel = '⚙ Diproses';
                    } else if (o.status == 'shipped') {
                      statusColor = const Color(0xFF38F9D7); // cyan
                      statusLabel = '🚚 Dikirim';
                    } else if (o.status == 'delivered') {
                      statusColor = const Color(0xFF43E97B); // green
                      statusLabel = '✓ Selesai';
                    } else if (o.status == 'cancelled') {
                      statusColor = const Color(0xFFFF6584); // red
                      statusLabel = '✕ Batal';
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13132B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Meta Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                o.orderNumber,
                                style: const TextStyle(
                                  color: Color(0xFF6C63FF),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: statusColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white10, height: 20),

                          // Store Name
                          Row(
                            children: [
                              const Icon(Icons.store, color: Color(0xFF8888AA), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                o.storeName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Items List snippet
                          if (o.items.isNotEmpty) ...[
                            Text(
                              '${o.items[0].productName} (${o.items[0].variant ?? 'Standard'})',
                              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (o.items.length > 1) ...[
                              const SizedBox(height: 4),
                              Text(
                                '+${o.items.length - 1} produk lainnya',
                                style: const TextStyle(color: Color(0xFF8888AA), fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ],
                          const SizedBox(height: 12),

                          // Shipped Meta Resi
                          if (o.status == 'shipped' && o.trackingNumber != null) ...[
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D0D1A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.local_shipping, color: Color(0xFF38F9D7), size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Resi: ${o.trackingNumber} (${o.courierShipped ?? o.courier})',
                                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Footer Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                o.createdAt.split('T')[0],
                                style: const TextStyle(color: Color(0xFF8888AA), fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Total Bayar: ',
                                    style: TextStyle(color: Color(0xFF8888AA), fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    formattedTotal,
                                    style: const TextStyle(
                                      color: Color(0xFF43E97B),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
