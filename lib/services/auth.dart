import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeapp/models/user.dart';
import 'package:projeapp/services/database.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;  //object of FirebaseAuth class, inside this class we can use _auth property

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    //user null değilse User class'ının instance'ına ait uid= user.uid(id firebase tarafından tanımlanmıştı, onu alıp User instance ının bir özelliği olarak belirttik)
    //null ise bir şey yapma.
    return user !=null? User(uid: user.uid) : null;
  }
  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
       // .map((FirebaseUser user)=> _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }


  //sign in anonymously:
  Future signInAnon() async{
    try{
      AuthResult result=await _auth.signInAnonymously();
      FirebaseUser user=result.user;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with e mail and password:
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      //builtin firebase method
      AuthResult result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=result.user; //firebase user'ımız bu email ve şifreye sahip olan user

      //create document for user with uid
      await DatabaseService(uid:user.uid).updateUserData('0','new crew member',100); //firebase'te e-mail ve password'le oluşturduğumuz kullanıcının id'sini alıyoruz ve onu
      //database.dart'taki updateUserData fonksiyonuna gönderiyoruz.
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  //register with e-mail and password:
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      //builtin firebase method
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=result.user;
      return _userFromFirebaseUser(user);//firebase user'ının id'sini kendi sistemimizde de belirtiyoruz User classının bir objesi olarak.
    }
    catch(e){
    print(e.toString());
    return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}