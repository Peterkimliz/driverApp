import 'package:equatable/equatable.dart';

abstract class InputsEvents extends Equatable {}

class SearchPackage extends InputsEvents {
  final String name;

  SearchPackage({required this.name});

  @override
  List<Object?> get props => [name];
}
