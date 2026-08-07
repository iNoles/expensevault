import 'package:drift/drift.dart';

class Receipts extends Table {
  TextColumn get id => text()();
  TextColumn get imagePath => text()();
  TextColumn get ocrText => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get receiptId => text().nullable()();
  TextColumn get categoryId => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get targetTable => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // insert, update, delete
  DateTimeColumn get timestamp => dateTime()();
}
