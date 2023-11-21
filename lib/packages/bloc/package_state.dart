import 'package:equatable/equatable.dart';

import '../package.dart';

abstract class PackageState extends Equatable {}

class InitialState extends PackageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingState extends PackageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedState extends PackageState {
   List<Package> packages;

  LoadedState({required this.packages});

  @override
  // TODO: implement props
  List<Object?> get props => [packages];
}
