
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';


class HomeMenuIndex extends Cubit<int>{
  HomeMenuIndex() : super(0);
  void onSelect(int index) {
    NaiFarmLocalStorage.saveNowPage(index).then((value) => emit(index));
  }
}