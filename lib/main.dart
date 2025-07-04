import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:noob_chat/providers/flag_provider.dart';
import 'package:noob_chat/screens/chat_screen.dart';
import 'package:noob_chat/screens/chatbot_screen.dart';
import 'package:noob_chat/screens/home_screen.dart';
import 'package:noob_chat/screens/profile_screen.dart';
import 'package:noob_chat/screens/search_screen.dart';
import 'package:noob_chat/screens/login_screen.dart';
import 'package:noob_chat/screens/register_screen.dart';
import 'package:noob_chat/screens/splash_screen.dart';
import 'package:noob_chat/services/notification_service.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationService().init();
  await messaging.requestPermission();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => FlagProvider())
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/chat': (context) => const ChatScreen(),
        '/chatBot': (context) => const ChatBotScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
