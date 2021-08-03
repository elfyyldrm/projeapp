import 'package:flutter/material.dart';
import 'package:projeapp/screens/authenticate/authenticate.dart';
import 'package:projeapp/screens/home/home.dart';
import 'package:projeapp/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    print(user);

    //return Home or Authenticate;

    //if there is no valid user info, send logged out or new user to authenticate screen
    if(user==null) {
      return Authenticate();
    }
    //if user info is not null, send the user to the home screen
    else{
      return Home();
    }
  }
}
