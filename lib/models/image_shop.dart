class ImageShop {
  String? _image;

  ImageShop(
      {String? image,}) {
    if (image != null) {
      this._image = image;
    }
  }

  String? get image => _image;
  set image(String? image) => _image = image;

  ImageShop.fromJson(Map<String, dynamic> json) {
    _image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Image'] = this._image;
    return data;
  }
}