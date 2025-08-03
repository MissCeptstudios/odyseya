import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/auth_user.dart';
import '../services/firebase_auth_service.dart';

class FirebaseAuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  FirebaseAuthNotifier(this._authService) : super(const AuthState()) {
    _initializeAuth();
  }

  void _initializeAuth() {
    state = state.copyWith(isLoading: true);
    
    // Listen to auth state changes
    _authSubscription = _authService.authStateChanges.listen(
      (firebase_auth.User? user) {
        final authUser = _authService.currentAuthUser;
        state = state.copyWith(
          user: authUser,
          isLoading: false,
          isInitialized: true,
          error: null,
        );
      },
      onError: (error) {
        if (mounted) {
          state = state.copyWith(
            isLoading: false,
            isInitialized: true,
            error: 'Authentication error: $error',
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          error: null,
          lastAction: AuthAction.signIn,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          error: null,
          lastAction: AuthAction.signUp,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          error: null,
          lastAction: AuthAction.signIn,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> signInWithApple() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authService.signInWithApple();

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          error: null,
          lastAction: AuthAction.signIn,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authService.signOut();
      
      state = state.copyWith(
        user: null,
        isLoading: false,
        error: null,
        lastAction: AuthAction.signOut,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _authService.sendPasswordResetEmail(email);
      
      state = state.copyWith(
        isLoading: false,
        error: 'Password reset email sent to $email',
        lastAction: AuthAction.resetPassword,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _authService.sendEmailVerification();
      
      state = state.copyWith(
        isLoading: false,
        error: 'Verification email sent',
        lastAction: AuthAction.sendEmailVerification,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _authService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      
      // Refresh user data
      final updatedUser = _authService.currentAuthUser;
      
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        error: null,
        lastAction: AuthAction.updateProfile,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> deleteAccount() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _authService.deleteAccount();
      
      state = state.copyWith(
        user: null,
        isLoading: false,
        error: null,
        lastAction: AuthAction.deleteAccount,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Legacy methods for backward compatibility
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: fullName,
    );
  }

  Future<void> resetPassword(String email) async {
    return sendPasswordResetEmail(email);
  }
}

// Service provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

// Auth state provider using Firebase
final firebaseAuthProvider = StateNotifierProvider<FirebaseAuthNotifier, AuthState>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return FirebaseAuthNotifier(authService);
});

// Validation providers (use Firebase service validation)
final emailValidationProvider = Provider.family<String?, String>((ref, email) {
  return FirebaseAuthService.validateEmail(email);
});

final passwordValidationProvider = Provider.family<String?, String>((ref, password) {
  return FirebaseAuthService.validatePassword(password);
});

final confirmPasswordValidationProvider = Provider.family<String?, Map<String, String>>((ref, passwords) {
  final password = passwords['password'] ?? '';
  final confirmPassword = passwords['confirmPassword'] ?? '';

  if (confirmPassword.isEmpty) return 'Please confirm your password';
  if (password != confirmPassword) return 'Passwords do not match';
  return null;
});

final displayNameValidationProvider = Provider.family<String?, String>((ref, name) {
  return FirebaseAuthService.validateDisplayName(name);
});

// Convenience providers
final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(firebaseAuthProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(firebaseAuthProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(firebaseAuthProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(firebaseAuthProvider).error;
});