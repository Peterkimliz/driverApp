import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiri/packages/bloc/package_events.dart';
import 'package:safiri/packages/bloc/package_state.dart';

import '../../repositories/package_repository.dart';
import '../package.dart';

class PackageBloc extends Bloc<InputsEvents, PackageState> {
  PackageRepository packageRepository;

  PackageBloc({required this.packageRepository}) : super(InitialState()) {
    on<SearchPackage>((event, emit) async {
      emit(LoadingState());
      List<Package> packages =
          await packageRepository.getPackages(type: event.name);
      emit(LoadedState(packages: packages));
    });
  }
}
