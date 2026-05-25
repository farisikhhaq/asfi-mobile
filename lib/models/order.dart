class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? variant;
  final int price;
  final int qty;
  final int subtotal;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.variant,
    required this.price,
    required this.qty,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? 'Produk',
      variant: json['variant']?.toString(),
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      qty: int.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      subtotal: int.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
    );
  }
}

class Order {
  final int id;
  final String orderNumber;
  final int storeId;
  final String storeName;
  final String customerName;
  final String? customerEmail;
  final String customerPhone;
  final String shippingAddress;
  final String shippingCity;
  final String shippingProvince;
  final String courier;
  final String paymentMethod;
  final String paymentStatus;
  final int subtotal;
  final int shippingCost;
  final int discount;
  final int total;
  final String status;
  final String createdAt;
  final List<OrderItem> items;
  final String? trackingNumber;
  final String? courierShipped;
  final String? shippedAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.storeId,
    required this.storeName,
    required this.customerName,
    this.customerEmail,
    required this.customerPhone,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingProvince,
    required this.courier,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
    this.trackingNumber,
    this.courierShipped,
    this.shippedAt,
  });

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List?;
    List<OrderItem> parsedItems = list != null
        ? list.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return Order(
      id: _parseInt(json['id']),
      orderNumber: json['order_number']?.toString() ?? '',
      storeId: _parseInt(json['store_id']),
      storeName: json['store_name']?.toString() ?? 'Toko ASFI',
      customerName: json['customer_name']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString(),
      customerPhone: json['customer_phone']?.toString() ?? '',
      shippingAddress: json['shipping_address']?.toString() ?? '',
      shippingCity: json['shipping_city']?.toString() ?? '',
      shippingProvince: json['shipping_province']?.toString() ?? '',
      courier: json['courier']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      subtotal: _parseInt(json['subtotal']),
      shippingCost: _parseInt(json['shipping_cost']),
      discount: _parseInt(json['discount']),
      total: _parseInt(json['total']),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      items: parsedItems,
      trackingNumber: json['tracking_number']?.toString(),
      courierShipped: json['courier_shipped']?.toString(),
      shippedAt: json['shipped_at']?.toString(),
    );
  }
}
