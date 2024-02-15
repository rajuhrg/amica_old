import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/repositories/common_firebase_storage_repository.dart';
import '../../../models/user_model.dart';
import '../../../utils/utils.dart';

// import '../../../common/repositories/common_firebase_storage_repository.dart';
// import '../../../models/mobile_layout_screen.dart';
// import '../../../models/user_model.dart';
// import '../../../util/utils.dart';
// import '../screens/otp_screen.dart';
// import '../screens/user_information_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    prefs: getPrefs(),
    firestore: FirebaseFirestore.instance,
  ),
);

getPrefs() async {
  return await SharedPreferences.getInstance();
}

class AuthRepository {
  final SharedPreferences prefs;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.prefs,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    print("----- going to getUserData from firebase");
    var userData =
        await firestore.collection('users').doc(prefs.getString("uid")).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    print("----- going to getUserData and returned");
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      //   await auth.verifyPhoneNumber(
      //     phoneNumber: phoneNumber,
      //     verificationCompleted: (PhoneAuthCredential credential) async {
      //       await auth.signInWithCredential(credential);
      //     },
      //     verificationFailed: (e) {
      //       showSnackBar(context: context, content: e.message!);
      //       throw Exception(e.message);
      //     },
      //     codeSent: ((String verificationId, int? resendToken) async {
      //       Navigator.pushNamed(
      //         context,
      //         OTPScreen.routeName,
      //         arguments: verificationId,
      //       );
      //     }),
      //     codeAutoRetrievalTimeout: (String verificationId) {},
      //   );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //   verificationId: verificationId,
      //   smsCode: userOTP,
      // );
      // await auth.signInWithCredential(credential);
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   UserInformationScreen.routeName,
      //   (route) => false,
      // );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
    // required SharedPreferences prefs,
  }) async {
    try {
      String uid = prefs.getString("uid") ?? "";
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      var d = {
        "name": name,
        "uid": uid,
        "profilePic": photoUrl,
        "isOnline": true,
        "phoneNumber": prefs.getString("mobno") ?? "",
        "groupId": [],
      };

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: prefs.getString("mobno") ?? "",
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const MobileLayoutScreen(),
      //   ),
      //   (route) => false,
      // );
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(
          prefs.getString("uid"),
        )
        .update({
      'isOnline': isOnline,
    });
  }
}
