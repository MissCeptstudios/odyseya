import 'dart:async';
import '../models/auth_user.dart';

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  final StreamController<AuthUser?> _authStateController = StreamController<AuthUser?>.broadcast();
  AuthUser? _currentUser;

  // Stream of authentication state changes
  Stream<AuthUser?> get authStateChanges => _authStateController.stream;

  // Get current user
  AuthUser? get currentUser => _currentUser;

  // Email/Password Sign Up
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate email validation
    if (!email.contains('@')) {
      throw AuthError.custom('Please enter a valid email address');
    }

    // Simulate password validation - more flexible for demo
    if (password.length < 6) {
      throw AuthError.custom('Password must be at least 6 characters long');
    }

    // Create mock user
    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: displayName ?? email.split('@')[0],
      isEmailVerified: false,
      provider: AuthProvider.email,
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  // Email/Password Sign In
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate validation
    if (!email.contains('@')) {
      throw AuthError.custom('Please enter a valid email address');
    }

    if (password.isEmpty) {
      throw AuthError.custom('Password is required');
    }

    // Demo user credentials for testing
    if (email == 'demo@gmail.com' && password == 'Demo1234') {
      final user = AuthUser(
        id: 'demo_user_123',
        email: 'demo@gmail.com',
        displayName: 'Demo User',
        isEmailVerified: true,
        provider: AuthProvider.email,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastSignIn: DateTime.now(),
      );

      _currentUser = user;
      _authStateController.add(user);
      return user;
    }

    // Create mock user
    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: email.split('@')[0],
      isEmailVerified: true,
      provider: AuthProvider.email,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastSignIn: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  // Google Sign In
  Future<AuthUser> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = AuthUser(
      id: 'google_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@gmail.com',
      displayName: 'Google User',
      photoURL: 'https://lh3.googleusercontent.com/a/default-user=s96-c',
      isEmailVerified: true,
      provider: AuthProvider.google,
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  // Apple Sign In
  Future<AuthUser> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = AuthUser(
      id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@privaterelay.appleid.com',
      displayName: 'Apple User',
      isEmailVerified: true,
      provider: AuthProvider.apple,
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock implementation - just pretend we sent an email
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (!email.contains('@')) {
      throw AuthError.custom('Please enter a valid email address');
    }
    // Mock implementation - just pretend we sent a reset email
  }

  // Sign Out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = null;
    _authStateController.add(null);
  }

  // Delete Account
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = null;
    _authStateController.add(null);
  }

  // Update Profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        displayName: displayName,
        photoURL: photoURL,
      );
      _authStateController.add(_currentUser);
    }
  }

  // Password validation - Demo-friendly
  static bool isPasswordValid(String password) {
    // Demo credentials bypass validation
    if (password == 'Demo1234') return true;
    
    return password.length >= 6 &&
           password.contains(RegExp(r'[A-Z]')) &&
           password.contains(RegExp(r'[a-z]')) &&
           password.contains(RegExp(r'[0-9]'));
  }

  static String getPasswordRequirements() {
    return 'Password must be at least 6 characters long and contain:\n'
           '• At least one uppercase letter\n'
           '• At least one lowercase letter\n'
           '• At least one number\n\n'
           'Demo: Use demo@gmail.com / Demo1234';
  }

  void dispose() {
    _authStateController.close();
  }
}