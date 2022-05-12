import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

mixin FirebaseAuth {
  late User currentUser;

  static FirebaseAuth instance;

  signInWithCredential(AuthCredential credential) {}
}
final GoogleSignIn googleSignIn = GoogleSignIn();

mixin GoogleSignIn {
  signOut() {}
}
String name;
String email;
String imageUrl;
Future<String?> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  // ignore: non_constant_identifier_names

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;
  if (user != null) {
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;
    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    print('signInWithGoogle succeeded: $user');
    return '$user';
  }
  return null;
}

mixin User {
  // ignore: prefer_typing_uninitialized_variables
  var email;

  // ignore: prefer_typing_uninitialized_variables
  var displayName;

  // ignore: prefer_typing_uninitialized_variables
  var photoURL;

  late bool isAnonymous;

  late Object uid;

  getIdToken() {}
}

mixin UserCredential {
  var user;
}

mixin GoogleAuthProvider {
  static AuthCredential credential({accessToken, idToken}) {}
}

mixin Firebase {
  static initializeApp() {}
}

mixin GoogleSignInAccount {
  get authentication => null;
}

mixin GoogleSignInAuthentication {
  // ignore: prefer_typing_uninitialized_variables
  var accessToken;

  // ignore: prefer_typing_uninitialized_variables
  var idToken;
}

class AuthCredential {}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
}
