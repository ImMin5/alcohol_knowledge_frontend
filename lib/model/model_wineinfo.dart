class WineInfo{
  int pk;
  String nameKor;
  String nameEng;
  int price;
  int vintage;
  int dateCreated;
  int datePurchase;
  String description;
  String store;
  String region;
  String sizeBottle;

  WineInfo(this.pk,this.nameEng,this.nameKor,this.price,this.vintage,
      this.dateCreated, this.datePurchase, this.description, this.region, this.sizeBottle, this.store);

  WineInfo.fromMap(Map<String,dynamic> map)
      : pk = map['pk'],
        nameKor = map['nameKor'],
        nameEng = map['nameEng'],
        price = map['price'],
        vintage = map['vintage'],
        dateCreated = map['dateCreated'],
        datePurchase = map['datePurchase'],
        description = map['description'],
        store = map['store'],
        region = map['region'],
        sizeBottle = map['sizeBottle'];

  WineInfo.fromJson(Map<String, dynamic> json)
      : pk = json['pk'] as int,
        nameKor = json['nameKor'] as String,
        nameEng = json['nameEng'] as String,
        price = json['price'] as int,
        vintage = json['vintage'] as int,
        dateCreated = json['dateCreated'] as int,
        datePurchase = json['datePurchase'] as int,
        description = json['description'] as String,
        store = json['store'] as String,
        region = json['region'] as String,
        sizeBottle = json['sizeBottle'] as String ;

}