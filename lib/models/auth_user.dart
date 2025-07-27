// import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final AuthProvider provider;
  final DateTime createdAt;
  final DateTime? lastSignIn;

  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
    required this.provider,
    required this.createdAt,
    this.lastSignIn,
  });

  // Commented out for now - will re-enable with Firebase
  // factory AuthUser.fromFirebaseUser(User user) {
  //   AuthProvider provider = AuthProvider.email;
  //
  //   for (final providerData in user.providerData) {
  //     switch (providerData.providerId) {
  //       case 'google.com':
  //         provider = AuthProvider.google;
  //         break;
  //       case 'apple.com':
  //         provider = AuthProvider.apple;
  //         break;
  //       case 'password':
  //       default:
  //         provider = AuthProvider.email;
  //         break;
  //     }
  //   }

  //   return AuthUser(
  //     id: user.uid,
  //     email: user.email,
  //     displayName: user.displayName,
  //     photoURL: user.photoURL,
  //     isEmailVerified: user.emailVerified,
  //     provider: provider,
  //     createdAt: user.metadata.creationTime ?? DateTime.now(),
  //     lastSignIn: user.metadata.lastSignInTime,
  //   );
  // }

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isEmailVerified,
    AuthProvider? provider,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isEmailVerified': isEmailVerified,
      'provider': provider.name,
      'createdAt': createdAt.toIso8601String(),
      'lastSignIn': lastSignIn?.toIso8601String(),
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      provider: AuthProvider.values.firstWhere(
        (p) => p.name == json['provider'],
        orElse: () => AuthProvider.email,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastSignIn: json['lastSignIn'] != null
          ? DateTime.parse(json['lastSignIn'])
          : null,
    );
  }
}

enum AuthProvider {
  email,
  google,
  apple,
  guest;

  String get displayName {
    switch (this) {
      case AuthProvider.email:
        return 'Email';
      case AuthProvider.google:
        return 'Google';
      case AuthProvider.apple:
        return 'Apple';
      case AuthProvider.guest:
        return 'Guest';
    }
  }

  String get iconPath {
    switch (this) {
      case AuthProvider.email:
        return 'assets/icons/email.svg';
      case AuthProvider.google:
        return 'assets/icons/google.svg';
      case AuthProvider.apple:
        return 'assets/icons/apple.svg';
      case AuthProvider.guest:
        return 'assets/icons/guest.svg';
    }
  }
}

class AuthState {
  final AuthUser? user;
  final bool isLoading;
  final bool isInitialized;
  final String? error;
  final AuthAction? lastAction;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.lastAction,
  });

  bool get isAuthenticated => user != null && isInitialized;
  bool get isGuest => user?.provider == AuthProvider.guest;
  bool get needsEmailVerification =>
      user != null &&
      !user!.isEmailVerified &&
      user!.provider == AuthProvider.email;
  bool get isReady => isInitialized && !isLoading;

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    bool? isInitialized,
    String? error,
    AuthAction? lastAction,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: clearError ? null : (error ?? this.error),
      lastAction: lastAction ?? this.lastAction,
    );
  }

  @override
  String toString() {
    return 'AuthState(user: ${user?.email}, isLoading: $isLoading, isInitialized: $isInitialized, isAuthenticated: $isAuthenticated, error: $error, lastAction: $lastAction)';
  }
}

enum AuthAction {
  signIn,
  signUp,
  signOut,
  deleteAccount,
  sendEmailVerification,
  resetPassword,
  updateProfile,
  linkProvider,
  unlinkProvider,
}

class AuthError {
  final String code;
  final String message;
  final AuthAction? action;
  final DateTime timestamp;

  const AuthError({
    required this.code,
    required this.message,
    this.action,
    required this.timestamp,
  });

  factory AuthError.fromFirebaseAuthException(
    dynamic exception, {
    AuthAction? action,
  }) {
    String userMessage;
    String code = 'unknown-error';

    // Handle both FirebaseAuthException and generic exceptions
    if (exception.runtimeType.toString().contains('FirebaseAuthException')) {
      code = exception.code ?? 'unknown-error';

      switch (code) {
        case 'user-not-found':
          userMessage = 'No account found with this email address.';
          break;
        case 'wrong-password':
          userMessage = 'Incorrect password. Please try again.';
          break;
        case 'email-already-in-use':
          userMessage = 'An account already exists with this email address.';
          break;
        case 'weak-password':
          userMessage =
              'Password is too weak. Please choose a stronger password.';
          break;
        case 'invalid-email':
          userMessage = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          userMessage =
              'This account has been disabled. Please contact support.';
          break;
        case 'too-many-requests':
          userMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'network-request-failed':
          userMessage =
              'Network error. Please check your connection and try again.';
          break;
        case 'requires-recent-login':
          userMessage = 'Please sign in again to complete this action.';
          break;
        case 'invalid-credential':
          userMessage = 'The provided credentials are invalid.';
          break;
        case 'operation-not-allowed':
          userMessage = 'This sign-in method is not enabled.';
          break;
        default:
          userMessage = exception.message ?? 'An unexpected error occurred.';
      }
    } else {
      userMessage = exception.toString();
    }

    return AuthError(
      code: code,
      message: userMessage,
      action: action,
      timestamp: DateTime.now(),
    );
  }

  factory AuthError.custom(String message, {AuthAction? action}) {
    return AuthError(
      code: 'custom-error',
      message: message,
      action: action,
      timestamp: DateTime.now(),
    );
  }
}
