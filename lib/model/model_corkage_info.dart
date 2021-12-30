class CorkageInfo {
  int id;
  String desc;
  int isChecked = 0;
  String addr;
  String dateCreate;
  String user;

  CorkageInfo(this.id, this.desc, this.isChecked, this.addr, this.dateCreate,
      this.user);

  factory CorkageInfo.fromJson(Map<String, dynamic> json) {
    return CorkageInfo(
        json['id'] as int,
        json['desc'] as String,
        json['isChecked'] as int,
        json['addr'] as String,
        json['dateCreate'] as String,
        json['user'] as String);
  }
}