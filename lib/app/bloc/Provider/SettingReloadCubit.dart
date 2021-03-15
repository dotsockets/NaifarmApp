import 'package:flutter_bloc/flutter_bloc.dart';

class SettingReloadCubit extends Cubit<bool> {
  SettingReloadCubit() : super(true);
  void reload(bool status) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      emit(status);
    });
  }
}
