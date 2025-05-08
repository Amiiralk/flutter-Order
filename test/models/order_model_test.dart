import 'package:flutter_test/flutter_test.dart';
import 'package:investiaflutter/models/order_model.dart';

void main() {
  group('Tests du modèle Order', () {
    test('Création d\'un ordre d\'achat', () {
      final order = Order(
        id: '1',
        assetId: 'BTC',
        assetName: 'Bitcoin',
        amount: 0.5,
        price: 50000,
        date: DateTime.now(),
        type: OrderType.buy,
      );

      expect(order.type, OrderType.buy);
      expect(order.status, OrderStatus.pending);
    });

    test('Création d\'un ordre de vente', () {
      final order = Order(
        id: '2',
        assetId: 'ETH',
        assetName: 'Ethereum',
        amount: 2.0,
        price: 2000,
        date: DateTime.now(),
        type: OrderType.sell,
      );

      expect(order.type, OrderType.sell);
      expect(order.amount, greaterThan(0));
    });
  });
}