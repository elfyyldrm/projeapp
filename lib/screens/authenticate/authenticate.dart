import 'package:flutter/material.dart';
import 'package:projeapp/screens/authenticate/register.dart';
import 'package:projeapp/screens/authenticate/sign_in.dart';
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn=true;

  //true iken false, false iken true yapar.
  void toggleView(){
    setState(()=>showSignIn=!showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView:toggleView); //value should be the same as toggleView function, randomname: toggleview
    }
    else{
      return Register(toggleView:toggleView);
    }
  }
}
