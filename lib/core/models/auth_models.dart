import 'dart:convert';

enum AuthStatus {
  unauthenticated,
  authenticated,
  guest,
}

class AuthUser {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool isGuest;
  final String? token;
  final DateTime? createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.isGuest = false,
    this.token,
    this.createdAt,
  });

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    bool? isGuest,
    String? token,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isGuest: isGuest ?? this.isGuest,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'isGuest': isGuest,
      'token': token,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      avatarUrl: map['avatarUrl'],
      isGuest: map['isGuest'] ?? false,
      token: map['token'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(json.decode(source));

  static AuthUser createGuest() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return AuthUser(
      id: 'guest_$timestamp',
      email: 'guest@arc.app',
      displayName: 'Guest Warrior',
      isGuest: true,
      createdAt: DateTime.now(),
    );
  }
}

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  factory AuthState.authenticated(AuthUser user) {
    return AuthState(status: AuthStatus.authenticated, user: user);
  }

  factory AuthState.guest(AuthUser user) {
    return AuthState(status: AuthStatus.guest, user: user);
  }

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
