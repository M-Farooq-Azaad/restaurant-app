import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../mock/mock_data.dart';

enum AuthStatus { unauthenticated, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final MockUser? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.authenticated(MockUser user)
      : this(status: AuthStatus.authenticated, user: user);
  const AuthState.error(String msg)
      : this(status: AuthStatus.error, errorMessage: msg);
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState.unauthenticated();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged_in') == true) {
      state = const AuthState.authenticated(MockData.currentUser);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    state = const AuthState.authenticated(MockData.currentUser);
  }

  Future<void> loginWithPhone(String phone) async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    state = const AuthState.unauthenticated();
  }

  Future<bool> verifyOtp(String otp) async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(seconds: 1));
    if (otp.length == 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      state = const AuthState.authenticated(MockData.currentUser);
      return true;
    }
    state = const AuthState.error('Invalid OTP');
    return false;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    state = const AuthState.authenticated(MockData.currentUser);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AuthState.unauthenticated();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
