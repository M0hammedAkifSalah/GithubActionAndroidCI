import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/admin-mode/admin-mode-states.dart';

class AdminModeCubit extends Cubit<AdminModeState> {
  AdminModeCubit() : super(AdminModeDisabled());
  bool status = false;
  void enableAdminMode() {
    emit(AdminModeEnabled());
  }

  void disableAdminMode() {
    emit(AdminModeDisabled());
  }

  bool get checkStatus => status;
}
