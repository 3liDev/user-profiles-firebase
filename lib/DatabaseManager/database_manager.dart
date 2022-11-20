import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');

  Future<void> createUserData(
      String name, String gender, int score, String uid) async {
    return await profileList
        .doc(uid)
        .set({'name': name, 'gender': gender, 'score': score});
    // ,SetOptions(merge: true)
  }

  Future updateUserList(
      String name, String gender, int score, String uid) async {
    return await profileList
        .doc(uid)
        .update({'name': name, 'gender': gender, 'score': score});
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {
        // querySnapshot.docs.forEach((element) {
        //   itemsList.add(element.data);
        // });

        for (var element in querySnapshot.docs) {
          itemsList.add(element.data);
        }
      });
      return itemsList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
