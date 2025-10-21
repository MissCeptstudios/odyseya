import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/auth_user.dart';
import '../services/firebase_auth_service.dart';
import '../services/revenue_cat_service.dart';

/// Real Firebase Authentication Provider
/// Replaces the mock auth provider with actual Firebase integration
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;
  final RevenueCatService _revenueCatService;

  AuthNotifier(this._authService, this._revenueCatService)
      : super(const AuthState()) {
    if (kDebugMode) {
      debugPrint('🔐 Initializing Auth Provider with Firebase');
    }
    _initializeState();
  }

  /// Initialize auth state and listen to Firebase auth changes
  Future<void> _initializeState() async {
    if (kDebugMode) {
      debugPrint('   Starting auth state initialization...');
    }

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      // Listen to Firebase auth state changes
      _authService.authStateChanges.listen((firebase_auth.User? firebaseUser) {
        if (kDebugMode) {
          debugPrint('   Auth state changed: ${firebaseUser?.email ?? "null"}');
        }

        if (firebaseUser != null) {
          // User is signed in
          final authUser = AuthUser(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName ?? '',
            photoURL: firebaseUser.photoURL,
            provider: _mapFirebaseProvider(firebaseUser),
            isEmailVerified: firebaseUser.emailVerified,
            createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
            lastSignIn: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
          );

          state = state.copyWith(
            user: authUser,
            isLoading: false,
            isInitialized: true,
            error: null,
          );

          // Identify user in RevenueCat
          _identifyUserInRevenueCat(firebaseUser.uid);
        } else {
          // User is signed out
          state = state.copyWith(
            user: null,
            isLoading: false,
            isInitialized: true,
            error: null,
          );
        }
      });

      // Check for existing session
      final currentUser = _authService.currentAuthUser;
      if (currentUser != null) {
        if (kDebugMode) {
          debugPrint('   ✅ Existing session found: ${currentUser.email}');
        }
        state = state.copyWith(
          user: currentUser,
          isLoading: false,
          isInitialized: true,
          error: null,
        );

        _identifyUserInRevenueCat(currentUser.id);
      } else {
        if (kDebugMode) {
          debugPrint('   ℹ️  No existing session');
        }
        state = state.copyWith(
          isLoading: false,
          isInitialized: true,
          error: null,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Error during initialization: $e');
      }
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        error: 'Failed to initialize: ${e.toString()}',
      );
    }
  }

  /// Map Firebase provider to AuthProvider enum
  AuthProvider _mapFirebaseProvider(firebase_auth.User user) {
    for (final info in user.providerData) {
      switch (info.providerId) {
        case 'google.com':
          return AuthProvider.google;
        case 'apple.com':
          return AuthProvider.apple;
        case 'password':
          return AuthProvider.email;
      }
    }
    return AuthProvider.email;
  }

  /// Identify user in RevenueCat for subscription tracking
  Future<void> _identifyUserInRevenueCat(String userId) async {
    try {
      // Note: This is handled in RevenueCatService.initialize()
      // but we can add explicit user login here if needed
      if (kDebugMode) {
        debugPrint('   💰 User identified in RevenueCat: $userId');
      }
      await _revenueCatService.refreshCustomerInfo();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ⚠️  RevenueCat identification failed: $e');
      }
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🔑 Sign In Attempt: $email');
      }

      state = state.copyWith(
        isLoading: true,
        error: null,
        isInitialized: true,
      );

      final authUser = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authUser != null) {
        state = state.copyWith(
          user: authUser,
          error: null,
          isInitialized: true,
          isLoading: false,
          lastAction: AuthAction.signIn,
        );

        if (kDebugMode) {
          debugPrint('   ✅ Sign in successful: ${authUser.email}');
        }

        // Identify in RevenueCat
        _identifyUserInRevenueCat(authUser.id);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Sign in failed: $e');
      }

      // DEVELOPMENT BYPASS: If Firebase is not configured, create a mock user for testing
      if (kDebugMode && e.toString().contains('API_KEY_INVALID')) {
        debugPrint('   🔧 Firebase not configured - using development bypass');
        debugPrint('   👤 Creating mock user for testing: $email');

        final mockUser = AuthUser(
          id: 'dev_${email.hashCode}',
          email: email,
          displayName: email.split('@').first.toUpperCase(),
          isEmailVerified: true,
          provider: AuthProvider.email,
          createdAt: DateTime.now(),
          lastSignIn: DateTime.now(),
        );

        state = state.copyWith(
          user: mockUser,
          error: null,
          isInitialized: true,
          isLoading: false,
          lastAction: AuthAction.signIn,
        );

        debugPrint('   ✅ Development bypass successful - logged in as mock user');
        return;
      }

      state = state.copyWith(
        error: 'Authentication failed. Please check your credentials.',
        isLoading: false,
        isInitialized: true,
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('📝 Sign Up Attempt: $email ($fullName)');
      }

      state = state.copyWith(isLoading: true, error: null);

      final authUser = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: fullName,
      );

      if (authUser != null) {
        state = state.copyWith(
          user: authUser,
          isLoading: false,
          error: null,
          lastAction: AuthAction.signUp,
          isInitialized: true,
        );

        if (kDebugMode) {
          debugPrint('   ✅ Sign up successful: ${authUser.email}');
        }

        // Send email verification
        try {
          await _authService.sendEmailVerification();
          if (kDebugMode) {
            debugPrint('   📧 Verification email sent');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('   ⚠️  Failed to send verification email: $e');
          }
        }

        // Identify in RevenueCat
        _identifyUserInRevenueCat(authUser.id);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Sign up failed: $e');
      }

      // DEVELOPMENT BYPASS: If Firebase is not configured, create a mock user for testing
      if (kDebugMode && e.toString().contains('API_KEY_INVALID')) {
        debugPrint('   🔧 Firebase not configured - using development bypass');
        debugPrint('   👤 Creating mock user for testing: $email');

        final mockUser = AuthUser(
          id: 'dev_${email.hashCode}',
          email: email,
          displayName: fullName,
          isEmailVerified: true,
          provider: AuthProvider.email,
          createdAt: DateTime.now(),
          lastSignIn: DateTime.now(),
        );

        state = state.copyWith(
          user: mockUser,
          isLoading: false,
          error: null,
          lastAction: AuthAction.signUp,
          isInitialized: true,
        );

        debugPrint('   ✅ Development bypass successful - created mock user');
        return;
      }

      state = state.copyWith(
        isLoading: false,
        error: 'Sign up failed. Please try again.',
      );
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        debugPrint('🔑 Google Sign In Attempt');
      }

      state = state.copyWith(isLoading: true, error: null);

      final authUser = await _authService.signInWithGoogle();

      if (authUser != null) {
        // Determine if this is a new user or returning user
        // For simplicity, we'll check if account age is less than 1 minute
        final isNewUser =
            DateTime.now().difference(authUser.createdAt).inMinutes < 1;

        state = state.copyWith(
          user: authUser,
          error: null,
          isInitialized: true,
          isLoading: false,
          lastAction: isNewUser ? AuthAction.signUp : AuthAction.signIn,
        );

        if (kDebugMode) {
          debugPrint('   ✅ Google sign in successful: ${authUser.email}');
        }

        // Identify in RevenueCat
        _identifyUserInRevenueCat(authUser.id);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Google sign in failed: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      if (kDebugMode) {
        debugPrint('🔑 Apple Sign In Attempt');
      }

      state = state.copyWith(isLoading: true, error: null);

      final authUser = await _authService.signInWithApple();

      if (authUser != null) {
        // Determine if this is a new user or returning user
        final isNewUser =
            DateTime.now().difference(authUser.createdAt).inMinutes < 1;

        state = state.copyWith(
          user: authUser,
          error: null,
          isInitialized: true,
          isLoading: false,
          lastAction: isNewUser ? AuthAction.signUp : AuthAction.signIn,
        );

        if (kDebugMode) {
          debugPrint('   ✅ Apple sign in successful: ${authUser.email}');
        }

        // Identify in RevenueCat
        _identifyUserInRevenueCat(authUser.id);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Apple sign in failed: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (kDebugMode) {
        debugPrint('🚪 Signing out user: ${state.user?.email}');
      }

      await _authService.signOut();

      state = const AuthState(isInitialized: true);

      if (kDebugMode) {
        debugPrint('   ✅ User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Sign out failed: $e');
      }
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      if (kDebugMode) {
        debugPrint('🔑 Password reset requested: $email');
      }

      state = state.copyWith(isLoading: true, error: null);

      await _authService.sendPasswordResetEmail(email);

      state = state.copyWith(
        isLoading: false,
        error: null, // Success - no error
      );

      if (kDebugMode) {
        debugPrint('   ✅ Password reset email sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Password reset failed: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('👤 Updating profile: $displayName, $photoUrl');
      }

      await _authService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      // Refresh current user
      final updatedUser = _authService.currentAuthUser;
      if (updatedUser != null) {
        state = state.copyWith(user: updatedUser);
      }

      if (kDebugMode) {
        debugPrint('   ✅ Profile updated');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Profile update failed: $e');
      }
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      if (kDebugMode) {
        debugPrint('🗑️  Deleting account: ${state.user?.email}');
      }

      await _authService.deleteAccount();

      state = const AuthState(isInitialized: true);

      if (kDebugMode) {
        debugPrint('   ✅ Account deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Account deletion failed: $e');
      }
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  final revenueCatService = ref.watch(revenueCatServiceProvider);
  return AuthNotifier(authService, revenueCatService);
});

// Convenience providers for common auth checks
final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(authStateProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final userIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).user?.id;
});

// Validation providers using Firebase Auth Service validation
final emailValidationProvider = Provider.family<String?, String>((ref, email) {
  return FirebaseAuthService.validateEmail(email);
});

final passwordValidationProvider = Provider.family<String?, String>((
  ref,
  password,
) {
  return FirebaseAuthService.validatePassword(password);
});

final confirmPasswordValidationProvider =
    Provider.family<String?, Map<String, String>>((ref, passwords) {
  final password = passwords['password'] ?? '';
  final confirmPassword = passwords['confirmPassword'] ?? '';

  if (confirmPassword.isEmpty) return 'Please confirm your password';
  if (password != confirmPassword) return 'Passwords do not match';
  return null;
});

final displayNameValidationProvider = Provider.family<String?, String>((
  ref,
  name,
) {
  return FirebaseAuthService.validateDisplayName(name);
});
