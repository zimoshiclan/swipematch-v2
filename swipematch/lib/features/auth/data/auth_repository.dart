import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';

class AuthRepository {
  AuthRepository(this._supabase);

  final SupabaseClient _supabase;

  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> sendOtp(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      shouldCreateUser: true,
    );
  }

  Future<void> verifyOtp(String email, String token) async {
    await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
  }

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) async {
    await _supabase.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: SupabaseConstants.authRedirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
