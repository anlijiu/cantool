import 'package:cantool/repository/repository.dart';

class AppbarBloc {
  final Repository _repository = CanRepository();

  void startSending() {
    _repository.startSending();
  }

  void stopSending() {
    _repository.stopSending();
  }

  void dispose() {
  }
}
