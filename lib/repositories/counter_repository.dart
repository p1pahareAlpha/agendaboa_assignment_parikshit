import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CounterRepository {
  int counterA = 0;
  int counterB = 0;
  int counterC = 0;
  int selectedTab = 0;
  CounterRepository() {
    download();
  }

  download() async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('counters').doc('counters');
    DocumentSnapshot docSnap = await docRef.get();
    Map<String, dynamic> fileData = (docSnap.data()) as Map<String, dynamic>;
    if (fileData.entries.isNotEmpty && fileData.entries.length == 4) {
      counterA = fileData['counterA'];
      counterB = fileData['counterB'];
      counterC = fileData['counterC'];
      selectedTab = fileData['selectedTab'];
    }
  }

  upload() async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('counters').doc('counters');
      Map<String, dynamic> fileData = {};
      fileData['counterA'] = counterA;
      fileData['counterB'] = counterB;
      fileData['counterC'] = counterC;
      fileData['selectedTab'] = selectedTab;
      await docRef.set(fileData);
    } catch (e) {
      log(e.toString());
    }
  }

  synchronize() async {
    await upload();
    await download();
  }

  Future increment() async {
    if (selectedTab == 0) {
      ++counterA;
    } else if (selectedTab == 1) {
      ++counterB;
    } else {
      ++counterC;
    }
    await synchronize();
  }

  Future selectTab(int index) async {
    selectedTab = index;
    await synchronize();
  }

  Future resetAll() async {
    counterA = 0;
    counterB = 0;
    counterC = 0;
    await synchronize();
  }
}
