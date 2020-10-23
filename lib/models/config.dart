class Config {
  int _id;
  String _gistId;
  String _accessToken;
  String _vaultd;
  String _uniqued;
  String _pin;

  Config(this._gistId,  this._accessToken, this._vaultd, this._uniqued, this._pin);
  Config.withId(this._id, this._gistId, this._accessToken, this._vaultd, this._uniqued, this._pin);

  int get id => _id;
  String get gistId => _gistId;
  String get accessToken => _accessToken;
  String get vaultd => _vaultd;
  String get uniqued => _uniqued;
  String get pin => _pin;

  set gistId(String newGistId) {
    this._gistId = newGistId;
  }

  set accessToken(String newAccessToken) {
    this._accessToken = newAccessToken;
  }

  set vaultd(String newCreated) {
    this._vaultd = newCreated;
  }

  set uniqued(String newModified) {
    this._uniqued = newModified;
  }

  set pin(String newPin) {
    this._pin = newPin;
  }



	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['gistId'] = _gistId;
		map['accessToken'] = _accessToken;
		map['vaultd'] = _vaultd;
    map['uniqued'] = _uniqued;
    map['pin'] = _pin;
		return map;
	}

	Config.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
		this._gistId = map['gistId'];
		this._accessToken = map['accessToken'];
		this._vaultd = map['vaultd'];
    this._uniqued = map['uniqued'];
    this._pin = map['pin'];
	}
}