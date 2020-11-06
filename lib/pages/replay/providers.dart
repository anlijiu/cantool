import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'models.dart';
import 'replay_view_controller.dart';

final filterMsgSignalProvider = StateProvider<Map<int, Message>>((ref) => {});
final viewControllerProvider =
    Provider.autoDispose((ref) => ReplayPageController(ref.read));
