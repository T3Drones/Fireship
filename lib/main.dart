import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireship/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fireship/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [StreamProvider<User>.value(value: AuthService().user)],
      child: MaterialApp(
        // Firebase Analytics
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],

        routes: {
          '/': (context) => LoginScreen(),
          '/topics': (context) => TopicsScreen(),
          '/profile': (context) => ProfileScreen(),
          '/about': (context) => AboutScreen(),
        },

        // Theme
        theme: ThemeData(
          // your customizations here
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
