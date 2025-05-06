import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:investiaflutter/providers/auth_provider.dart';
import 'package:investiaflutter/providers/order_provider.dart';
import 'package:investiaflutter/services/auth_service.dart';
import 'package:investiaflutter/services/order_service.dart';
import 'package:investiaflutter/utils/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => OrderService()),
      ],
      child: MaterialApp(
        title: 'Investia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}