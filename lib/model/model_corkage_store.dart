class CorkageStore {
  int id;
  String name;
  String addr;
  String area;
  double longitude;
  double latitude;
  String desc;
  String dateUpdate;
  String website;
  String instagram;

  CorkageStore(this.id, this.name, this.addr, this.area, this.longitude,
      this.latitude, this.desc, this.dateUpdate, this.website, this.instagram);

  // factory 생성자. CorkageStore 인스턴스 반환
  factory CorkageStore.fromJson(Map<String, dynamic> json) {
    return CorkageStore(
        json['id'] as int,
        json['name'] as String,
        json['addr'] as String,
        json['area'] as String,
        json['longitude'] as double,
        json['latitude'] as double,
        json['desc'] as String,
        json['dateUpdate'] as String,
        json['website'] as String,
        json['instagram'] as String);
  }
}