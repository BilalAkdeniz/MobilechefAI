import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './viewmodels/prefer_viewmodel.dart';
import './viewmodels/chat_viewmodel.dart';
import './viewmodels/login_viewmodel.dart';
import './core/repositories/repository.dart';
import './core/services/auth.dart';
import './core/services/firestore_service.dart';
import './core/services/gemini_service.dart';
import './theme/responsive.dart';

import './views/chat_view/chat_page.dart';
import './views/prefer/prefer_page.dart';
import './views/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  await dotenv.load(fileName: ".env");

  final authService = AuthService();
  final firestoreService = FirestoreService();
  final geminiService =
      GeminiService(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');

  final repository = Repository(
    authService: authService,
    firestoreService: firestoreService,
    geminiService: geminiService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(repository)),
        ChangeNotifierProvider(
          create: (_) => PreferViewModel(repository),
        ),
        ChangeNotifierProvider(create: (_) => ChatViewModel(repository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<LoginViewModel>(
        builder: (context, loginViewModel, _) {
          if (loginViewModel.currentUser == null) {
            return const LoginPage();
          }
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                const ChatPage(),
                PreferPage(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  selectedItemColor: Colors.orange.shade600,
                  unselectedItemColor: Colors.grey.shade500,
                  selectedFontSize: Responsive.font(context, 0.032),
                  unselectedFontSize: Responsive.font(context, 0.03),
                  iconSize: Responsive.width(context, 0.06),
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: Container(
                        padding:
                            EdgeInsets.all(Responsive.width(context, 0.02)),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? Colors.orange.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _selectedIndex == 0
                              ? Icons.chat
                              : Icons.chat_outlined,
                          color: _selectedIndex == 0
                              ? Colors.orange.shade600
                              : Colors.grey.shade500,
                        ),
                      ),
                      label: "Tarif Al",
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding:
                            EdgeInsets.all(Responsive.width(context, 0.02)),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? Colors.orange.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _selectedIndex == 1
                              ? Icons.settings
                              : Icons.settings_outlined,
                          color: _selectedIndex == 1
                              ? Colors.orange.shade600
                              : Colors.grey.shade500,
                        ),
                      ),
                      label: "Tercihler",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
