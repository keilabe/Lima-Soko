import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/supabase_service.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'presentation/providers/user_provider.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/farmer/farmer_home_page.dart';
import 'pages/home_page.dart';
import 'pages/marketplace_page.dart';
import 'pages/checkout_page.dart';
import 'data/repositories/mpesa_service_impl.dart';
import 'domain/repositories/mpesa_service.dart';
import 'presentation/providers/payment_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lima_soko/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  
  final supabaseService = await SupabaseService.getInstance();
  final initialRoute = await _getInitialRoute(supabaseService);

  runApp(MyApp(supabaseService: supabaseService, initialRoute: initialRoute));
}

Future<String> _getInitialRoute(SupabaseService supabaseService) async {
  final currentUser = supabaseService.client.auth.currentUser;
  if (currentUser != null) {
    try {
      final response = await supabaseService.client
          .from('profiles')
          .select('role')
          .eq('id', currentUser.id)
          .single();
      final role = response['role'] as String;
      if (role == 'farmer') {
        return '/farmer-home';
      } else if (role == 'buyer') {
        return '/home';
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }
  return '/login';
}

class MyApp extends StatefulWidget {
  final SupabaseService supabaseService;
  final String initialRoute;

  const MyApp({super.key, required this.supabaseService, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.supabaseService.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedOut) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.initialSession) {
        _redirect();
      }
    });
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final currentUser = widget.supabaseService.client.auth.currentUser;
    if (currentUser != null) {
      try {
        final response = await widget.supabaseService.client
            .from('profiles')
            .select('role')
            .eq('id', currentUser.id)
            .single();
        final role = response['role'] as String;
        if (role == 'farmer') {
          if (mounted) Navigator.of(context).pushReplacementNamed('/farmer-home');
        } else if (role == 'buyer') {
          if (mounted) Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        print('Error fetching user role on auth state change: $e');
        if (mounted) Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => UserRepositoryImpl(widget.supabaseService.client),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        Provider<ProductRepositoryImpl>(
          create: (_) => ProductRepositoryImpl(widget.supabaseService.client),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductRepositoryImpl>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        Provider<MpesaService>(
          create: (context) => MpesaServiceImpl(widget.supabaseService.client, widget.supabaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentProvider(
            mpesaService: context.read<MpesaService>(),
            supabaseService: widget.supabaseService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Lima Soko',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: widget.initialRoute,
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/farmer-home': (context) => const FarmerHomePage(),
              '/home': (context) => const HomePage(),
              '/marketplace': (context) => const MarketplacePage(),
              '/checkout': (context) => const CheckoutPage(),
            },
          );
        },
      ),
    );
  }
}

