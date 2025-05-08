import 'package:flutter_test/flutter_test.dart';
import 'package:investiaflutter/providers/order_provider.dart';
import 'package:investiaflutter/models/order_model.dart';

void main() {
  group('Tests du OrderProvider', () {
    late OrderProvider provider;

    setUp(() {
      provider = OrderProvider();
    });

    test('Liste initiale vide', () {
      expect(provider.orders, isEmpty);
    });

    test('Ajout d\'un ordre', () async {
      final order = Order(
        id: '1',
        assetId: 'BTC',
        assetName: 'Bitcoin',
        amount: 0.5,
        price: 50000,
        date: DateTime.now(),
        type: OrderType.buy,
      );

      await provider.placeOrder(order);
      expect(provider.orders.length, 1);
    });
  });
}