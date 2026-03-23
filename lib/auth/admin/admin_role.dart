class AdminRole {
  AdminRole._();

  static const String admin = 'admin';

  static bool isAdmin(String? role) => role == admin;
}
