import 'package:flutter_bloc/flutter_bloc.dart';

class SettingReloadCubit extends Cubit<bool> {
  SettingReloadCubit() : super(true);
  void reload(bool status) {
    emit(status);
  }
}