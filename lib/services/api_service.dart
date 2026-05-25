import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/buyer.dart';
import '../models/order.dart';

class ApiService {
  // For android emulator, localhost is 10.0.2.2. For general physical devices, use your computer IP.
  // Port 8080 is defined in docker-compose.yml as the nginx entry for php-web (asfi-web).
  static String baseUrl = 'http://10.0.2.2:8080/api/v1';

  static Future<void> setBaseUrl(String url) async {
    baseUrl = url;
  }

  // ─── Headers helper ───
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── Auth API ───
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', decoded['token']);
        await prefs.setString('user_data', jsonEncode(decoded['user']));
        return {'success': true, 'user': Buyer.fromJson(decoded['user']), 'token': decoded['token']};
      } else {
        return {'success': false, 'message': decoded['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    final url = Uri.parse('$baseUrl/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', decoded['token']);
        await prefs.setString('user_data', jsonEncode(decoded['user']));
        return {'success': true, 'user': Buyer.fromJson(decoded['user']), 'token': decoded['token']};
      } else {
        return {'success': false, 'message': decoded['message'] ?? 'Registrasi gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi error: $e'};
    }
  }

  static Future<void> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');
    try {
      final headers = await _getHeaders();
      await http.post(url, headers: headers);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_data');
  }

  static Future<Buyer?> getMe() async {
    final url = Uri.parse('$baseUrl/auth/me');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['user'] != null) {
          return Buyer.fromJson(decoded['user']);
        }
      }
    } catch (_) {}
    return null;
  }

  // ─── Products API ───
  static Future<List<Product>> getProducts({String? query, String? category, String? sortBy}) async {
    var uriString = '$baseUrl/products?per_page=50';
    if (query != null && query.isNotEmpty) uriString += '&q=${Uri.encodeComponent(query)}';
    if (category != null && category.isNotEmpty) uriString += '&category=${Uri.encodeComponent(category)}';
    if (sortBy != null && sortBy.isNotEmpty) uriString += '&sort=$sortBy';

    final url = Uri.parse(uriString);
    try {
      final response = await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final list = decoded['data'] as List?;
        if (list != null) {
          return list.map((item) => Product.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
    return [];
  }

  static Future<Product?> getProductDetail(String slug) async {
    final url = Uri.parse('$baseUrl/products/$slug');
    try {
      final response = await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error fetching product detail: $e');
    }
    return null;
  }

  // ─── Orders API ───
  static Future<List<Order>> getOrders() async {
    final url = Uri.parse('$baseUrl/orders');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List decodedList = jsonDecode(response.body);
        return decodedList.map((item) => Order.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> createOrder({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String province,
    required String courier,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    int shippingCost = 0,
  }) async {
    final url = Uri.parse('$baseUrl/orders');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({
        'customer_name': name,
        'customer_email': email,
        'customer_phone': phone,
        'shipping_address': address,
        'shipping_city': city,
        'shipping_province': province,
        'courier': courier,
        'payment_method': paymentMethod,
        'items': items,
        'shipping_cost': shippingCost,
      });

      final response = await http.post(url, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'order_number': decoded['order_number'],
          'order_id': decoded['order_id'],
          'total': decoded['total'],
          'qris_image': decoded['qris_image'],
          'qris_number': decoded['qris_number'],
        };
      } else {
        return {'success': false, 'message': decoded['message'] ?? 'Gagal membuat pesanan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi error: $e'};
    }
  }
}
