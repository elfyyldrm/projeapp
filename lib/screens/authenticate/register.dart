import 'package:flutter/material.dart';
import 'package:projeapp/services/auth.dart';
import 'package:projeapp/shared/constants.dart';
import 'package:projeapp/shared/loading.dart';
class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>(); //track our form
  //text field state
  String email='';
  String password='';
  String error='';
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title:Text('Sign up to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: (){
              widget.toggleView(); //this refers to the state object, so we use widget
            //widget refers to this widget itself
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal:50.0),
        child: Form(
          key:_formKey, //track our form, global key
          child:Column(
            children: <Widget>[
              SizedBox(height:20.0),
              TextFormField(
                decoration:textInputDecoration.copyWith(hintText:'Email'),
                validator: (val)=>val.isEmpty ? 'Enter an e-mail': null,
                onChanged: (val){ //everytime the value changes, this function is gonna run
                  setState(()=>email=val); //set user input as email
                },
              ),
              SizedBox(height:20.0),
              TextFormField(
                decoration:textInputDecoration.copyWith(hintText:'Password'),
                obscureText: true, //does not shows the password
                validator: (val)=>val.length<6 ? 'Enter a password 6+ chars long': null,
                onChanged: (val){ //every time the value changes, this function is gonna run
                  setState(()=>password=val);
                },
              ),
              SizedBox(height:20.0),
              RaisedButton(
                color:Colors.pink[400],
                child:Text('Register',
                  style:TextStyle(color: Colors.white),
                ),
                onPressed:() async{
                  if(_formKey.currentState.validate()) //we needed to create validator to work this function, to validate our form based on the current state
                    //we created validators.
                  {
                    setState(()=>loading=true);
                    dynamic result=await _auth.registerWithEmailAndPassword(email, password);
                    if(result==null){
                      setState((){error='Please supply a valid email';
                      loading=false;
                      });
                    }
                  } //if true, form is valid
                },
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color:Colors.red, fontSize:14.0)),
            ],
          ),
        ),
      ),

    );
  }
}
