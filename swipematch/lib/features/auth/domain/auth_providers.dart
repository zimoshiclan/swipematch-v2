import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});

// Streams every Supabase auth state change event
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Convenience: current Supabase user (null = logged out)
final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authStateStreamProvider); // rebuild when auth changes
  return Supabase.instance.client.auth.currentUser;
});
