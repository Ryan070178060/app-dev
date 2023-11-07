import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:appsbyreezy/global/global.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = currentFirebaseUser;
    DatabaseReference CustomersRef = FirebaseDatabase.instance
        .ref()
        .child("customers")
        .child(currentFirebaseUser!.uid);

    CustomersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
    //  UserModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }
 // static Future<String> searchAddressForGeographicCoordinates(Position position,context)async{}

 
}
