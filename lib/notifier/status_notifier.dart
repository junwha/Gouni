import 'package:flutter/material.dart';
import 'dart:io';

import 'package:makerthon/api/api.dart';
import 'package:makerthon/model/status_model.dart';

class StatusNotifier extends ChangeNotifier {
  String _characterName = "Default name";
  String _rewardName1 = "Default name";
  String _rewardName2 = "Default name";
  String _rewardName3 = "Default name";
  File? _rewardImage1;
  File? _rewardImage2;
  File? _rewardImage3;
  int _point = 0;
  int _currentLevel = 0;
  double _currentPercentage = 0;
  List<int> _targets = [10, 20, 30];

  String get characterName => _characterName;
  String get rewardName1 => _rewardName1;
  String get rewardName2 => _rewardName2;
  String get rewardName3 => _rewardName3;
  File? get rewardImage1 => _rewardImage1;
  File? get rewardImage2 => _rewardImage2;
  File? get rewardImage3 => _rewardImage3;
  int get point => _point;
  int get currentLevel => _currentLevel;
  double get currentPercentage => _currentPercentage;
  int get target1 => _targets[0];
  int get target2 => _targets[1];
  int get target3 => _targets[2];
  set target1(int t) {
    _targets[0] = t;
  }

  set target2(int t) {
    _targets[1] = t;
  }

  set target3(int t) {
    _targets[2] = t;
  }

  void calculateLevelAndPercentage() {
    print("${_targets[0]} ${_targets[1]} ${_targets[2]}");
    if (_point < _targets[0]) {
      _currentLevel = 1;
      _currentPercentage = (_point / _targets[0]);
    } else if (_point < _targets[1]) {
      _currentLevel = 2;
      _currentPercentage = (_point - _targets[0]) / (_targets[1] - _targets[0]);
    } else if (_point < _targets[2]) {
      _currentLevel = 3;
      _currentPercentage = (_point - _targets[1]) / (_targets[2] - _targets[1]);
    } else {
      _currentLevel = 4;
      _currentPercentage = 1;
    }
  }

  void updateCharacterName(String newName) {
    _characterName = newName;
    notifyListeners();
  }

  void updateRewardName(String re1, String re2, String re3) {
    _rewardName1 = re1;
    _rewardName2 = re2;
    _rewardName3 = re3;
    notifyListeners();
  }

  void updateRewardImage(File? im1, File? im2, File? im3) {
    _rewardImage1 = im1;
    _rewardImage2 = im2;
    _rewardImage3 = im3;
    notifyListeners();
  }

  void updateRewardTargets(int t1, int t2, int t3) {
    if (t1 < t2 && t2 < t3) {
      _targets = [t1, t2, t3];
    }
  }

  void fetchCounts() async {
    final StatusModel? model = await Api.getStatusFromAPI();
    if (model != null) {
      int diff = model.pos - model.neg;
      if (_point + diff < 0) {
        _point = 0;
      } else {
        _point += diff;
      }
      print("diff: $diff");
      print("point: $_point");
      calculateLevelAndPercentage();
      print("level: $_currentLevel");
      print("percentage: $_currentPercentage");
      notifyListeners();
    }
  }
}
