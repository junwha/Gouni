import 'package:flutter/material.dart';
import 'dart:io';

import 'package:makerthon/api/api.dart';
import 'package:makerthon/model/status_model.dart';

class StatusNotifier extends ChangeNotifier {
  String _characterName = "Default name";
  List<String> _rewardNames = ["레벨1", "레벨2", "레벨3"];
  List<File?> _rewardImages = [null, null, null];

  int _point = 0;
  int _currentLevel = 0;
  double _currentPercentage = 0;
  List<int> _targets = [10, 20, 30];

  String get characterName => _characterName;
  List<String> get rewardNames => _rewardNames;
  File? get rewardImage1 => _rewardImages[0];
  File? get rewardImage2 => _rewardImages[1];
  File? get rewardImage3 => _rewardImages[2];
  List<File?> get rewardImages => _rewardImages;
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

  void updateRewardName(List<String> newNames) {
    _rewardNames = newNames;
    notifyListeners();
  }

  void updateRewardImage(List<File?> newImages) {
    _rewardImages = newImages;
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
