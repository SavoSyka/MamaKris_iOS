import 'package:firebase_auth/firebase_auth.dart'; // Добавьте этот импорт
import 'package:google_sign_in/google_sign_in.dart';
final FirebaseAuth _auth = FirebaseAuth.instance; // Создайте экземпляр FirebaseAuth

Future<bool?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Возвращаем true, если пользователь новый, и false, если нет
      return userCredential.additionalUserInfo?.isNewUser;
    }
  } catch (e) {
    print(e);
  }
  return null; // В случае ошибки возвращаем null
}