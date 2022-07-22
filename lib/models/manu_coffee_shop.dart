class SelectManuCoffee {
  String? email_id;
  String? image;
  String? manuname;
  String? price;
  String? type;

  SelectManuCoffee(
      {this.email_id, this.image ,this.manuname, this.price, this.type});

  SelectManuCoffee.fromJson(Map<String, dynamic> json) {
    email_id = json['email_id'];
    image = json['image'];
    manuname = json['manuname'];
    price = json['price'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.email_id;
    data['image'] = this.image;
    data['manuname'] = this.manuname;
    data['price'] = this.price;
    data['type'] = this.type;
    return data;
  }
}