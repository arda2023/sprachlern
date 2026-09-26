import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around Supabase's email/password auth. Failures surface as the
/// SDK's [AuthException], whose (English) message is shown as-is for now.
class AuthService {
  AuthService(this._auth);

  final GoTrueClient _auth;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  /// Synchronous, and already restored from storage once
  /// `Supabase.initialize` has completed.
  Session? get currentSession => _auth.currentSession;

  User? get currentUser => _auth.currentUser;

  /// With email confirmation enabled on the project this creates the user but
  /// no session; [currentSession] then stays `null`.
  Future<void> signUp({required String email, required String password}) async {
    await _auth.signUp(email: email, password: password);
  }

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();
}
