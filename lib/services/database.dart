import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeapp/models/brew.dart';
import 'package:projeapp/models/user.dart';
class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference brewCollection=Firestore.instance.collection('brews');
  //if collection does not exists, it does not matter because firestore will create it when we run the code

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      //it is gonna create that document with uid. so that firebase knows that
      //a person with specific uid has this file.
      'sugars':sugars,
      'name':name,
      'strength':strength,
    });
  }

  //brew list from snapshot  //underscore to make it private
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){ //doc refers to each single document
      return Brew(
        name: doc.data['name'] ?? '', //if does not exists then name: ''
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? '0'
      );
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name:snapshot.data['name'],
      sugars:snapshot.data['sugars'],
      strength:snapshot.data['strength']
    );
  }

  //get brews stream
  Stream<List<Brew>>get brews{
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return brewCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot); //takes document snapshot and turn it into userData object.
  }

}