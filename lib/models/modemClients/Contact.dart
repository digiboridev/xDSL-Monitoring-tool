import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Some.dart';

part 'Contact.g.dart';

@HiveType(typeId: 11) // use Hive to generate a type adapter
class Contact extends HiveObject {
  // Define variables

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String email;

  @HiveField(3)
  List somes = [new Some(), new Some()];

  List getList() {
    return somes;
  }

  // Constructor
  Contact({@required this.name, this.phone, this.email});
}
