import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/services/auth_service.dart';
import 'package:sprachlern/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(supabaseClientProvider).auth),
);

final authStateChangesProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

/// Recomputed on every auth event, but answered from the SDK's synchronous
/// session: the stream's first event arrives asynchronously, and the router
/// must not bounce a restored session to /login in the meantime.
final isAuthenticatedProvider = Provider<bool>((ref) {
  ref.watch(authStateChangesProvider);
  return ref.watch(authServiceProvider).currentSession != null;
});

/// The signed-in user's id. Providers use `==` to filter updates, so token
/// refreshes do not notify — only an actual change of user does.
final currentUserIdProvider = Provider<String?>((ref) {
  ref.watch(authStateChangesProvider);
  return ref.watch(authServiceProvider).currentUser?.id;
});
