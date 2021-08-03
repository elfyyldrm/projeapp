import 'package:flutter/material.dart';
import 'package:projeapp/models/user.dart';
import 'package:projeapp/services/database.dart';
import 'package:projeapp/shared/constants.dart';
import 'package:projeapp/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey=GlobalKey<FormState>();
  final List<String> sugars=['0', '1','2','3','4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid:user.uid).userData,
      builder: (context, snapshot) { //it is snapshot of the data down the stream, it is not the firebase snapshot
      if(snapshot.hasData){ //if snapshot does not have data, i don't wanna do anything with it

          UserData userData=snapshot.data; //artık seçtiğimiz şey UserData itemi olacak
          return Form(
            key:_formKey,
            child:Column(
              children: <Widget>[
                Text('Update your brew settings.',
                  style:TextStyle(fontSize:18.0),
                ),
                SizedBox(height:20.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator:(val)=>val.isEmpty? 'Please enter a name': null,
                  onChanged: (val)=>setState(()=>_currentName=val),
                ),
                SizedBox(height: 20.0,),
                //dropdown
                DropdownButtonFormField(
                  decoration:textInputDecoration,
                  value:_currentSugars ?? userData.sugars, //buradaki value en başta ne gösterdiğiyle ilgili. kullanıcının seçtiğini gösterir, kullanıcı henüz seçmemişse '0' gösterir.
                  items: sugars.map((sugar){
                    return DropdownMenuItem(
                      value: sugar, //burada her bir sugar değerini(1,2,3...) drop down menüye yazdırıyor.
                      child:Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val)=>setState(()=>_currentSugars=val),
                ),
                //slider
                Slider(
                  value:(_currentStrength ?? userData.strength).toDouble(), //we turned it into double because slider works with doubles.
                  activeColor: Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                  min:100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val)=>setState(()=>_currentStrength=val.round()), //when we use round, it rounds double into an integer because in slider, values are double but our strength value is int
                ),
                RaisedButton(
                    color:Colors.pink[400],
                    child:Text('Update',
                      style:TextStyle(color: Colors.white),
                    ),
                    onPressed:() async{
                      if(_formKey.currentState.validate()){
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userData.sugars,
                          _currentName ?? userData.name,
                          _currentStrength ?? userData.strength
                        );
                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          );
        }else{
          return Loading();
        }

      }
    );
  }
}
