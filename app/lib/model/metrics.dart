import 'package:hm/enums/device.dart';
import 'package:hm/enums/unit.dart';

class Metric {
  final int? id;
  DateTime date;
  Device device;
  double value;
  Unit unit;
  DateTime created;
  DateTime updated;

  Metric({
    required this.id,
    required this.date,
    required this.device,
    required this.value,
    required this.unit,
    required this.created,
    required this.updated,
  });

  factory Metric.fromMap(Map<String, dynamic> json) {
    return Metric(
      id: json['id'] as int,
      date: json['date'] as DateTime,
      device: json['device'] as Device,
      value: json['value'] as double,
      unit: json['unit'] as Unit,
      created: json['created'] as DateTime,
      updated: json['update'] as DateTime,
    );
  }

  factory Metric.fromDbMap(Map<String, dynamic> db) {
    return Metric(
      id: db['id'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(db['fecha'] as int),
      device: db['dispositivo'] as Device,
      value: db['valor'] as double,
      unit: db['unidad'] as Unit,
      created: DateTime.fromMillisecondsSinceEpoch(db['creacion'] as int),
      updated: DateTime.fromMillisecondsSinceEpoch(db['actualizacion'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
    'id': id,
    'date': date.millisecondsSinceEpoch,
    'device': device.index,
    'value': value,
    'unit': unit.index,
    'created': created.millisecondsSinceEpoch,
    'updated': updated.millisecondsSinceEpoch
    };
  }

  Map<String, dynamic> toMapDb() {
    return {
      'id': id,
      'fecha': date.millisecondsSinceEpoch,
      'dispositivo': device.index,
      'valor': value,
      'unidad': unit.index,
      'creacion': created.millisecondsSinceEpoch,
      'actualizacion': updated.millisecondsSinceEpoch
    };
  }
}
