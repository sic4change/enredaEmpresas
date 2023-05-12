import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;

  bool get isNullUser;

  Stream<User?> authStateChanges();

  Future<User?> signInAnonymously();

  //Future<User?> signInWithGoogle();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Future<void> changePassword();

  Future<void> changePasswordWithEmail(String email);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  bool get isNullUser => currentUser == null;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(
            email: email.trim().toLowerCase(), password: password));
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(), password: password);
    return userCredential.user;
  }

  // @override
  // Future<User?> signInWithGoogle() async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleUser = await googleSignIn.signIn();
  //   if (googleUser != null) {
  //     final googleAuth = await googleUser.authentication;
  //     if (googleAuth.idToken != null) {
  //       final userCredential = await _firebaseAuth.signInWithCredential(
  //           GoogleAuthProvider.credential(
  //               idToken: googleAuth.idToken,
  //               accessToken: googleAuth.accessToken));
  //       return userCredential.user;
  //     } else {
  //       throw FirebaseAuthException(
  //         code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
  //         message: 'Missing Google ID Token',
  //       );
  //     }
  //   } else {
  //     throw FirebaseAuthException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       message: 'Sign in aborted by user',
  //     );
  //   }
  // }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> changePassword() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      await _firebaseAuth.sendPasswordResetEmail(email: user?.email ?? '');
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> changePasswordWithEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
}
