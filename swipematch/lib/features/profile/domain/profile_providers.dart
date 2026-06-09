import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile_repository.dart';
import 'profile_model.dart';
import '../../auth/domain/auth_providers.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client);
});

final currentProfileProvider = FutureProvider<ProfileModel?>((ref) async {
  // Re-evaluate whenever the auth session changes (login / logout / refresh)
  ref.watch(authStateStreamProvider);
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;
  return ref.read(profileRepositoryProvider).fetchProfile(user.id);
});
