import 'dart:async';

import 'package:sprachlern/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-memory [AuthService] for widget tests — no Supabase, no network.
///
/// [signIn] succeeds unless [signInError] is set, and waits for
/// [pendingAuthCall] when that is given, to observe the loading state.
class FakeAuthService implements AuthService {
  FakeAuthService({bool signedIn = false})
    : _session = signedIn ? _testSession : null;

  final _events = StreamController<AuthState>.broadcast();

  Session? _session;

  AuthException? signInError;

  /// When set, sign-up succeeds without a session (email confirmation on).
  bool signUpNeedsConfirmation = false;

  Completer<void>? pendingAuthCall;

  int signOutCalls = 0;

  static final _testSession = Session(
    accessToken: 'test-access-token',
    tokenType: 'bearer',
    user: const User(
      id: 'test-user',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: '2026-01-01T00:00:00Z',
    ),
  );

  @override
  Stream<AuthState> get authStateChanges => _events.stream;

  @override
  Session? get currentSession => _session;

  @override
  User? get currentUser => _session?.user;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await pendingAuthCall?.future;
    if (signInError case final error?) throw error;
    _setSession(_testSession, AuthChangeEvent.signedIn);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await pendingAuthCall?.future;
    if (!signUpNeedsConfirmation) {
      _setSession(_testSession, AuthChangeEvent.signedIn);
    }
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _setSession(null, AuthChangeEvent.signedOut);
  }

  void _setSession(Session? session, AuthChangeEvent event) {
    _session = session;
    _events.add(AuthState(event, session));
  }
}
