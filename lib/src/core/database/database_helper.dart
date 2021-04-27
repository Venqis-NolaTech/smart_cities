import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/util/string_util.dart';

enum TableNames {
  room,
  user,
  message,
  postCommentNotification,
}

extension TableNamesExtension on TableNames {
  String get name => this.toString().split('.').last.capitalize;
}

class DatabaseHelper {
  static final _databaseName = "elevenAppPerisitence.db";
  static final _databaseVersion = 5;

  // Creando singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // Inicializando la base de datos en el primer acceso
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // creando las tablas
  Future _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion <= 1) {
      // Agregando la columna sendStatus a la version 1
      await db.execute(
          "ALTER TABLE Message ADD COLUMN sendStatus TEXT DEFAULT 'SENT';");
    }
    if (oldVersion <= 2) {
      // Agregando la columna partnerId a la version 2 y su índice
      await db.execute("ALTER TABLE Room ADD COLUMN partnerId TEXT;");
      await db.execute('CREATE INDEX room_partnerId_index ON Room(partnerId);');
    }
    if (oldVersion <= 3) {
      // Creating table PostComment
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableNames.postCommentNotification.name}
        (
          _id TEXT PRIMARY KEY,
          channel_id TEXT,
          channel_name TEXT,
          channel_pictureURL TEXT,      
          post_id TEXT,
          post_content TEXT,
          createdBy_id TEXT,
          createdBy_displayName TEXT,
          createdBy_photoURL TEXT,
          createdAt TEXT,
          comment TEXT
        );
      ''');
    }

    if (oldVersion <= 4) {
      // Agregando la columna openRoom a la version 4
      await db.execute(
          "ALTER TABLE ${TableNames.message.name} ADD COLUMN openRoom INTEGER DEFAULT 0;");
    }
  }

  Future _createTables(Database db) async {
    // Creando table Room
    try {
      await db.execute('''
          CREATE TABLE Room 
          (
            roomId TEXT PRIMARY KEY,
            partnerId TEXT,
            name TEXT,
            pictureUrl TEXT,
            unreadMessages INTEGER,
            canWrite INTEGER,
            isGroup INTEGER,
            lastMsg TEXT,
            isPinned INTEGER,
            description TEXT,
            lastMessage TEXT,
            lastMessageDate TEXT
          );
          ''');
    } catch (e) {}

    // Creando indices de la tabla Room
    try {
      await db.execute(
          'CREATE INDEX room_lastMessageDate_index ON Room(lastMessageDate);');
      await db.execute('CREATE INDEX room_partnerId_index ON Room(partnerId);');
    } catch (e) {
      print(e);
    }

    // Creando tabla User
    try {
      await db.execute('''
    CREATE TABLE User
    (
      userId TEXT PRIMARY KEY,
      name TEXT,
      profession TEXT,
      photoURL TEXT,
      phoneNumber TEXT
    );
    ''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
    CREATE TABLE Message
    (
      msgId TEXT PRIMARY KEY,
      senderId TEXT,
      senderName TEXT,
      roomId TEXT,
      isResent INTEGER,
      msgType TEXT,
      message TEXT,
      sticker TEXT,
      animatedSticker TEXT,
      gif TEXT,
      image TEXT,
      video TEXT,
      downloadSize TEXT,
      link TEXT,
      linkImage TEXT,
      linkTitle TEXT,
      linkBrief TEXT,
      linkOriginDomain TEXT,
      responseMessageId TEXT,
      responseUserId TEXT,
      responseUserName TEXT,
      responseMessageBrief TEXT,
      responseMessageImage TEXT,
      responseMessageType TEXT,
      poll TEXT,
      pollName TEXT,
      msgLife TEXT,
      isUpdated INTEGER,
      createdAt TEXT,
      counter REAL,
      read INTEGER,
      sendStatus TEXT
    );
    ''');
    } catch (e) {
      print(e);
    }

    // Creando índices
    await db.execute('CREATE INDEX message_msgId_index ON Message(msgId);');
    await db.execute('CREATE INDEX message_counter_index ON Message(counter);');
    await db.execute('CREATE INDEX message_roomId_index ON Message(roomId);');

    await db
        .execute('CREATE INDEX message_senderId_index ON Message(senderId);');
    await db
        .execute('CREATE INDEX message_createdAt_index ON Message(createdAt);');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableNames.postCommentNotification.name}
        (
          _id TEXT PRIMARY KEY,
          channel_id TEXT,
          channel_name TEXT,
          channel_pictureURL TEXT,      
          post_id TEXT,
          post_content TEXT,
          createdBy_id TEXT,
          createdBy_displayName TEXT,
          createdBy_photoURL TEXT,
          createdAt TEXT,
          comment TEXT
        );
      ''');
  }

  Future _deleteTables(Database db) async {
    // Eliminando tablas
    TableNames.values.forEach((table) async =>
        await db.execute('DROP TABLE IF EXISTS ${table.name};'));

    final List<String> indexName = [
      'room_lastMessageDate_index',
      'message_counter_index',
      'message_roomId_index',
      'message_senderId_index',
      'message_createdAt_index',
    ];

    indexName.forEach(
        (element) async => await db.execute(' DROP INDEX IF EXISTS $element;'));
  }

  Future<bool> recreateDatabase() async {
    try {
      Database db = await instance.database;
      await _deleteTables(db);
      await _createTables(db);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
