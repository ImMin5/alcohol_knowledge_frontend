class WineInfoForm{
  String nameKor;
  String nameEng;
  int price;
  int vintage;
  String datePurchase;
  String description;
  String store;
  String region;
  String sizeBottle;

  WineInfoForm(this.nameEng,this.nameKor,this.price,this.vintage,
      this.datePurchase, this.description, this.region, this.sizeBottle, this.store);

  WineInfoForm.fromMap(Map<String,dynamic> map)
      : nameKor = map['nameKor'],
        nameEng = map['nameEng'],
        price = map['price'],
        vintage = map['vintage'],
        datePurchase = map['datePurchase'],
        description = map['description'],
        store = map['store'],
        region = map['region'],
        sizeBottle = map['sizeBottle'];

  WineInfoForm.fromJson(Map<String, dynamic> json)
      : nameKor = json['nameKor'] as String,
        nameEng = json['nameEng'] as String,
        price = json['price'] as int,
        vintage = json['vintage'] as int,
        datePurchase = json['datePurchase'] as String,
        description = json['description'] as String,
        store = json['store'] as String,
        region = json['region'] as String,
        sizeBottle = json['sizeBottle'] as String ;

  Map<String, dynamic> toJson() =>
      {
        'nameKor' : nameKor,
        'nameEng' :nameEng,
        'price' : price,
        'vintage' : vintage,
        'datePurchase' : datePurchase,
        'description' : description,
        'store' : store,
        'region' : region,
        'sizeBottle' : sizeBottle,
      };


}