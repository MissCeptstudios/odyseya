import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';

class AuthForm extends ConsumerStatefulWidget {
  final bool isSignUp;
  final bool isLoading;
  final String? error;
  final Function(String email, String password, String? displayName) onSubmit;
  final VoidCallback onClearError;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.isLoading,
    this.error,
    required this.onSubmit,
    required this.onClearError,
  });

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showPasswordRequirements = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              print('DEBUG: Validating email: $value');
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              final emailError = ref.read(
                emailValidationProvider(value.trim()),
              );
              return emailError;
            },
            onChanged: (_) {
              if (widget.error != null) {
                widget.onClearError();
              }
            },
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            textInputAction: widget.isSignUp
                ? TextInputAction.next
                : TextInputAction.done,
            validator: (value) {
              print('DEBUG: Validating password');
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (widget.isSignUp) {
                final passwordError = ref.read(
                  passwordValidationProvider(value),
                );
                return passwordError;
              }
              return null;
            },
            onChanged: (_) {
              if (widget.error != null) {
                widget.onClearError();
              }
              if (widget.isSignUp) {
                setState(() {
                  _showPasswordRequirements =
                      _passwordController.text.isNotEmpty;
                });
              }
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: DesertColors.onSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            onFieldSubmitted: widget.isSignUp
                ? null
                : (_) {
                    print('DEBUG: Password field submitted');
                    _submitForm();
                  },
          ),

          // Password Requirements (Sign Up only)
          if (widget.isSignUp && _showPasswordRequirements) ...[
            const SizedBox(height: 8),
            _buildPasswordRequirements(),
          ],

          // Confirm Password Field (Sign Up only)
          if (widget.isSignUp) ...[
            const SizedBox(height: 16),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                final confirmError = ref.read(
                  confirmPasswordValidationProvider({
                    'password': _passwordController.text,
                    'confirmPassword': value,
                  }),
                );
                return confirmError;
              },
              onChanged: (_) {
                if (widget.error != null) {
                  widget.onClearError();
                }
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: DesertColors.onSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              onFieldSubmitted: (_) => _submitForm(),
            ),
          ],

          const SizedBox(height: 24),

          // Error Message
          if (widget.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.error!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: DesertColors.primary.withValues(
                  alpha: 0.6,
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.isSignUp ? 'Create Account' : 'Sign In',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String)? onFieldSubmitted,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(color: DesertColors.onSurface, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: DesertColors.onSecondary),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DesertColors.waterWash.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DesertColors.waterWash.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: DesertColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        fillColor: DesertColors.surface,
        filled: true,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;

    // Demo password bypass
    if (password == 'Demo1234&&') {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DesertColors.sageGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: DesertColors.sageGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, size: 16, color: DesertColors.sageGreen),
            const SizedBox(width: 8),
            Text(
              'Demo credentials valid!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: DesertColors.sageGreen,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesertColors.waterWash.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: DesertColors.waterWash.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DesertColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          _buildPasswordRequirement(
            'At least 6 characters',
            password.length >= 6,
          ),
          _buildPasswordRequirement(
            'One uppercase letter',
            password.contains(RegExp(r'[A-Z]')),
          ),
          _buildPasswordRequirement(
            'One lowercase letter',
            password.contains(RegExp(r'[a-z]')),
          ),
          _buildPasswordRequirement(
            'One number',
            password.contains(RegExp(r'[0-9]')),
          ),
          _buildPasswordRequirement(
            'One special character',
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesertColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Demo: Use demo@gmail.com / Demo1234&&',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: DesertColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 12,
          color: isMet ? DesertColors.sageGreen : DesertColors.onSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: isMet ? DesertColors.sageGreen : DesertColors.onSecondary,
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    print('DEBUG: ===== Form Submission =====');
    if (_formKey.currentState?.validate() ?? false) {
      print('DEBUG: Form validation successful');
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      print('DEBUG: Form values:');
      print('DEBUG: Email: $email');
      print('DEBUG: Password length: ${password.length}');
      print(
        'DEBUG: Password: $password',
      ); // Only for debugging, remove in production

      widget.onSubmit(email, password, null);
    } else {
      print('DEBUG: Form validation failed');
      print('DEBUG: Current values:');
      print('DEBUG: Email: ${_emailController.text}');
      print('DEBUG: Password length: ${_passwordController.text.length}');
    }
    print('DEBUG: ===== Form Submission Complete =====');
  }
}
