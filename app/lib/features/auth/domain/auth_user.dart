class AuthUser {
  final String uid;
  final String? email;
  final bool isAnonymous;

  AuthUser({required this.uid, this.email, required this.isAnonymous});
}
