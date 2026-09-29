import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState(status: AuthStatus.unauthenticated, isLoading: true)) {
    _initSession();
  }

  Future<void> _initSession() async {
    await _authService.init();
    final user = _authService.getCurrentUser();
    if (user != null) {
      if (user.isGuest) {
        state = AuthState.guest(user);
      } else {
        state = AuthState.authenticated(user);
      }
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signInWithEmail(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signUpWithEmail(email, password, name);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> signInAsGuest() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final guest = await _authService.signInAsGuest();
      state = AuthState.guest(guest);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _authService.signOut();
    state = AuthState.unauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated || authState.status == AuthStatus.guest;
});

final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});
