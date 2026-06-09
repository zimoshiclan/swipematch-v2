import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/constants/supabase_constants.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  // Add google-services.json (Android) and GoogleService-Info.plist (iOS) before enabling
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase config files not yet added — safe during development
  }

  runApp(const ProviderScope(child: SwipeMatchApp()));
}
