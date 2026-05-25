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
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String? ?? 'Produk',
      variant: json['variant'] as String?,
      price: (json['price'] as num).toInt(),
      qty: (json['qty'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
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

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List?;
    List<OrderItem> parsedItems = list != null
        ? list.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return Order(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      storeId: (json['store_id'] as num? ?? 0).toInt(),
      storeName: json['store_name'] as String? ?? 'Toko ASFI',
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String?,
      customerPhone: json['customer_phone'] as String? ?? '',
      shippingAddress: json['shipping_address'] as String? ?? '',
      shippingCity: json['shipping_city'] as String? ?? '',
      shippingProvince: json['shipping_province'] as String? ?? '',
      courier: json['courier'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      subtotal: (json['subtotal'] as num? ?? 0).toInt(),
      shippingCost: (json['shipping_cost'] as num? ?? 0).toInt(),
      discount: (json['discount'] as num? ?? 0).toInt(),
      total: (json['total'] as num? ?? 0).toInt(),
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] as String? ?? '',
      items: parsedItems,
      trackingNumber: json['tracking_number'] as String?,
      courierShipped: json['courier_shipped'] as String?,
      shippedAt: json['shipped_at'] as String?,
    );
  }
}
