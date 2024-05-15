import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final FirebaseAuth _auth = FirebaseAuth.instance; // Экземпляр FirebaseAuth, если ещё не создан

Future<bool?> signInWithApple() async {
  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final OAuthCredential credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Возвращаем true, если пользователь новый, и false, если нет
    return userCredential.additionalUserInfo?.isNewUser;
  } catch (e) {
    print(e);
    return null; // В случае ошибки возвращаем null
  }
}