import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../services/notification_service.dart';

class RebalanceScreen extends StatelessWidget {
  const RebalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    if (orderProvider.isLoading && orderProvider.rebalanceRecommendations.isEmpty) {
      orderProvider.fetchRebalanceRecommendations();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'AI Portfolio Rebalancing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: orderProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: orderProvider.rebalanceRecommendations.length,
                    itemBuilder: (context, index) {
                      final recommendation = orderProvider.rebalanceRecommendations[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recommendation.assetName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Current: ${recommendation.currentPercentage}%'),
                                  Text('Target: ${recommendation.targetPercentage}%'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Action: ${recommendation.amountToAdjust > 0 ? 'BUY' : 'SELL'} ${recommendation.amountToAdjust.abs()}',
                                style: TextStyle(
                                  color: recommendation.amountToAdjust > 0 
                                    ? Colors.green 
                                    : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {

              final orders = orderProvider.rebalanceRecommendations.map((rec) {
                return Order(
                  id: '',
                  assetId: rec.assetId,
                  assetName: rec.assetName,
                  amount: rec.amountToAdjust.abs(),
                  price: 0,
                  date: DateTime.now(),
                  type: rec.amountToAdjust > 0 ? OrderType.buy : OrderType.sell,
                );
              }).toList();
              
              final success = await orderProvider.executeRebalance(orders);
              if (success && mounted) {
                NotificationService.showRebalanceNotification(
                  context, 
                  orders.length,
                );
              }
            },
            child: const Text('Execute Rebalance'),
          ),
        ],
      ),
    );
  }
}