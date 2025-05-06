import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<RebalanceRecommendation> _rebalanceRecommendations = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  List<RebalanceRecommendation> get rebalanceRecommendations => _rebalanceRecommendations;
  bool get isLoading => _isLoading;

  final OrderService _orderService = OrderService();

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _orders = await _orderService.getUserOrders();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRebalanceRecommendations() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _rebalanceRecommendations = await _orderService.getRebalanceRecommendations();
    } catch (e) {
      debugPrint('Error fetching rebalance recommendations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> placeOrder(Order order) async {
    try {
      final newOrder = await _orderService.placeOrder(order);
      _orders.insert(0, newOrder);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error placing order: $e');
      return false;
    }
  }

  Future<bool> executeRebalance(List<Order> rebalanceOrders) async {
    try {
      final results = await Future.wait(
        rebalanceOrders.map((order) => _orderService.placeOrder(order))
      );
      _orders.insertAll(0, results);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error executing rebalance: $e');
      return false;
    }
  }
}