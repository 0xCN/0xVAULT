import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';
import '../models/config.dart';


class DatabaseHelper {
	static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

	String noteTable = 'note_table';
	String colId = 'id';
	String colTitle = 'title';
	String colText = 'text';
	String colCreated = 'created';
  String colModified = 'modified';
  String colPrivate = 'private';

  // configs
  String configTable = 'config'; // table
  String gistId = 'gistId';
  String accessToken = 'accessToken';
  String vaultd = 'vaultd';
  String unique = 'uniqued';
  String pin = 'pin';


	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {
		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelper;
	}
  

	Future<Database> get database async {
		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}


	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'notes.db';

		// Open/create the database at a given path
		var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
		return notesDatabase;
	}

	void _createDb(Database db, int newVersion) async {
		await db.execute('''
      CREATE TABLE $noteTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT,
        $colText TEXT,
        $colCreated TEXT,
        $colModified TEXT,
        $colPrivate BOOLEAN)
    ''');

    await db.execute('''
      CREATE TABLE $configTable (
        id INTEGER,
        $gistId TEXT,
        $accessToken TEXT,
        $vaultd TEXT,
        $unique TEXT,
        $pin TEXT)
    ''');

    // default settings
    Config conf = Config.withId(1, 'gistID', 'gistAT', 'vaultd', 'unique', '000000');
    await db.insert(configTable, conf.toMap());
	}


	// Fetch Operation: Get all note objects from database
	Future<List<Map<String, dynamic>>> getNoteMapList() async {
		Database db = await this.database;

	//	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colTitle ASC');
		var result = await db.query(noteTable, orderBy: "CASE $colModified WHEN '' THEN $colCreated ELSE $colModified END DESC");
		return result;
	}


	// Insert Operation: Insert a note object to database
  Future<int> insertNote(Note note) async {
		Database db = await this.database;
		var result = await db.insert(noteTable, note.toMap());
		return result;
	}

	// Update Operation: Update a note object and save it to database
	Future<int> updateNote(Note note) async {
		var db = await this.database;
		var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
		return result;
	}

  Future<int> updateNoteCompleted(Note note) async {
		var db = await this.database;
		var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
		return result;
	}


	// Update Operation: Update the config object and save it to database
	Future<int> updateConfig(Config conf) async {
		var db = await this.database;
		var result = await db.update(configTable, conf.toMap(), where: 'id = 1');
		return result;
	}

  Future<int> updateConfigCompleted(Config conf) async {
		var db = await this.database;
		var result = await db.update(configTable, conf.toMap(), where: 'id = 1');
		return result;
	}


	// Delete Operation: Delete a note object from database
	Future<int> deleteNote(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
		return result;
	}

	// Get number of note objects in database
	Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

  // Get the 'Map List' [ List<Map> ] and convert it to 'note List' [ List<note> ]
	Future<List<Note>> getNoteList() async {
		var noteMapList = await getNoteMapList(); // Get 'Map List' from database
		int count = noteMapList.length;         // Count the number of map entries in db table
		List<Note> noteList = List<Note>();
		// For loop to create a 'note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			noteList.add(Note.fromMapObject(noteMapList[i]));
		}
		return noteList;
	}

	Future<Config> getConfig() async {
    Database db = await this.database;
		var configList = await db.query(configTable); // Get 'Map List' from database
		Config conf = Config.fromMapObject(configList[0]);
		return conf;
	}

}

