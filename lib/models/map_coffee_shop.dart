class MapCoffeeShop {
  String? _image;
  String? _userID;
  String? _password;
  String? _email;
  String? _locationName;
  String? _description;
  String? _contact;
  String? _officeHoursOpen;
  String? _officeHoursClose;
  String? _address;
  String? _provinceID;

  MapCoffeeShop(
      {
        String? image,
        String? userID,
        String? password,
        String? email,
        String? locationName,
        String? description,
        String? contact,
        String? officeHoursOpen,
        String? officeHoursClose,
        String? address,
        String? provinceID
      }) {
    if (image != null) {
      this._image = image;
    }
    if (userID != null) {
      this._userID = userID;
    }
    if (password != null) {
      this._password = password;
    }
    if (email != null) {
      this._email = email;
    }
    if (locationName != null) {
      this._locationName = locationName;
    }
    if (description != null) {
      this._description = description;
    }
    if (contact != null) {
      this._contact = contact;
    }
    if (officeHoursOpen != null) {
      this._officeHoursOpen = officeHoursOpen;
    }
    if (officeHoursClose != null) {
      this._officeHoursClose = officeHoursClose;
    }
    if (address != null) {
      this._address = address;
    }
    if (provinceID != null) {
      this._provinceID = provinceID;
    }
  }

  String? get image => _image;
  set image(String? image) => _image = image;
  String? get userID => _userID;
  set userID(String? userID) => _userID = userID;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get locationName => _locationName;
  set locationName(String? locationName) => _locationName = locationName;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get contact => _contact;
  set contact(String? contact) => _contact = contact;
  String? get officeHoursOpen => _officeHoursOpen;
  set officeHoursOpen(String? officeHoursOpen) =>
      _officeHoursOpen = officeHoursOpen;
  String? get officeHoursClose => _officeHoursClose;
  set officeHoursClose(String? officeHoursClose) =>
      _officeHoursClose = officeHoursClose;
  String? get address => _address;
  set address(String? address) => _address = address;
  String? get provinceID => _provinceID;
  set provinceID(String? provinceID) => _provinceID = provinceID;

  MapCoffeeShop.fromJson(Map<String, dynamic> json) {
    _image = json['Image'];
    _userID = json['User_ID'];
    _password = json['password'];
    _email = json['Email'];
    _locationName = json['Location_Name'];
    _description = json['Description'];
    _contact = json['Contact'];
    _officeHoursOpen = json['Office_Hours_Open'];
    _officeHoursClose = json['Office_Hours_close'];
    _address = json['Address'];
    _provinceID = json['Province_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Image'] = this._image;
    data['User_ID'] = this._userID;
    data['password'] = this._password;
    data['Email'] = this._email;
    data['Location_Name'] = this._locationName;
    data['Description'] = this._description;
    data['Contact'] = this._contact;
    data['Office_Hours_Open'] = this._officeHoursOpen;
    data['Office_Hours_close'] = this._officeHoursClose;
    data['Address'] = this._address;
    data['Province_ID'] = this._provinceID;
    return data;
  }

}