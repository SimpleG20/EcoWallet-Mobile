import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void goToHome() => emit(0);
  void goToWallet() => emit(1);
  void goToSettings() => emit(2);

  void goToIndex(int index) => emit(index);
}
