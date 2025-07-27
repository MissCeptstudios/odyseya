import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';

// Mock auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    // Initializing AuthNotifier
    _initializeState();
  }

  Future<void> _initializeState() async {
    // Starting state initialization
    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      // Simulate checking for stored credentials
      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize with no user but mark as initialized
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        error: null,
      );
      // State initialized successfully
    } catch (e) {
      // Error during initialization: $e
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        error: 'Failed to initialize: ${e.toString()}',
      );
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Sign In Attempt
      // Email: $email
      // Password length: ${password.length}
      // Current state - ${state.toString()}

      // Set loading state
      state = state.copyWith(isLoading: true, error: null, isInitialized: true);
      // Set loading state - ${state.toString()}

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Demo credentials
      if (email == 'demo@gmail.com' && password == 'Demo1234&&') {
        // Demo credentials match!
        final user = AuthUser(
          id: 'demo_user_123',
          email: 'demo@gmail.com',
          displayName: 'Demo User',
          isEmailVerified: true,
          provider: AuthProvider.email,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          lastSignIn: DateTime.now(),
        );

        // Created demo user object
        state = state.copyWith(
          user: user,
          error: null,
          isInitialized: true,
          isLoading: false,
          lastAction: AuthAction.signIn,
        );
        // Updated state with demo user - ${state.toString()}
        return;
      }

      // Demo credentials did not match
      // Expected: demo@gmail.com / Demo1234&&
      // Received: $email / [password-length: ${password.length}]

      // Invalid credentials
      state = state.copyWith(
        error:
            'Invalid email or password. Please use demo@gmail.com / Demo1234&&',
        isLoading: false,
        isInitialized: true,
      );
      // Set error state - ${state.toString()}
    } catch (e) {
      // Login error: $e
      state = state.copyWith(
        error: 'Login failed: ${e.toString()}',
        isLoading: false,
        isInitialized: true,
      );
    } finally {
      // Sign In Attempt Complete
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Sign Up Attempt
      // Email: $email
      // Full Name: $fullName
      
      state = state.copyWith(isLoading: true, error: null);
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Demo registration
      final user = AuthUser(
        id: "user_${DateTime.now().millisecondsSinceEpoch}",
        email: email,
        displayName: fullName,
        isEmailVerified: false,
        provider: AuthProvider.email,
        createdAt: DateTime.now(),
        lastSignIn: DateTime.now(),
      );
      
      state = state.copyWith(
        user: user,
        isLoading: false,
        error: null,
        lastAction: AuthAction.signUp,
        isInitialized: true,
      );
      
      // Sign up successful
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final user = AuthUser(
      id: 'mock-google-user-id',
      email: 'user@gmail.com',
      displayName: 'Google User',
      isEmailVerified: true,
      provider: AuthProvider.google,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(user: user, error: null, isInitialized: true);
  }

  Future<void> signInWithApple() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final user = AuthUser(
      id: 'mock-apple-user-id',
      email: 'user@privaterelay.appleid.com',
      displayName: 'Apple User',
      isEmailVerified: true,
      provider: AuthProvider.apple,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(user: user, error: null, isInitialized: true);
  }

  Future<void> signOut() async {
    // Signing out user
    await Future.delayed(const Duration(milliseconds: 500));
    state = AuthState(isInitialized: true);
    // User signed out successfully
  }

  Future<void> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(error: 'Password reset email sent to $email');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Validation providers
final emailValidationProvider = Provider.family<String?, String>((ref, email) {
  if (email.isEmpty) return 'Email is required';
  if (!email.contains('@')) return 'Please enter a valid email';
  return null;
});

final passwordValidationProvider = Provider.family<String?, String>((
  ref,
  password,
) {
  if (password.isEmpty) return 'Password is required';

  // Demo password bypass
  if (password == 'Demo1234&&') return null;

  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!password.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!password.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character';
  }
  return null;
});

final confirmPasswordValidationProvider =
    Provider.family<String?, Map<String, String>>((ref, passwords) {
      final password = passwords['password'] ?? '';
      final confirmPassword = passwords['confirmPassword'] ?? '';

      if (confirmPassword.isEmpty) return 'Please confirm your password';
      if (password != confirmPassword) return 'Passwords do not match';
      return null;
    });
