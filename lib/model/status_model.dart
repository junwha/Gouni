class StatusModel {
  int pos = 0;
  int neg = 0;

  StatusModel.fromJson(Map json)
      : pos = json['pos']!,
        neg = json['neg']!;
}
