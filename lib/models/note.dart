class Note {
  int _id;
  String _title;
  String _text;
  String _created;
  String _modified;
  bool _private;

  Note(this._title,  this._text, this._created, this._modified, this._private);
  Note.withId(this._id, this._title,  this._text, this._created, this._modified, this._private);

  int get id => _id;
  String get title => _title;
  String get text => _text;
  String get created => _created;
  String get modified => _modified;
  bool get private => _private;

  set title(String newTitle) {
    this._title = newTitle;
  }

  set text(String newText) {
    this._text = newText;
  }

  set created(String newCreated) {
    this._created = newCreated;
  }

  set modified(String newModified) {
    this._modified = newModified;
  }

  set private(bool newPrivate) {
    this._private = newPrivate;
  }



	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['text'] = _text;
		map['created'] = _created;
    map['modified'] = _modified;
    map['private'] = _private;
		return map;
	}

	Note.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
		this._text = map['text'];
		this._created = map['created'];
    this._modified = map['modified'];
    this._private = map['private']==1?true:false;
	}
}