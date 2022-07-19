class SelectManuCoffee {
  String? image;
  String? manuname;
  String? price;
  String? type;

  SelectManuCoffee(
      {this.image ,this.manuname, this.price, this.type});

  SelectManuCoffee.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    manuname = json['manuname'];
    price = json['price'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['manuname'] = this.manuname;
    data['price'] = this.price;
    data['type'] = this.type;
    return data;
  }
}