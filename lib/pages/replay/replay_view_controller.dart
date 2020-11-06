import 'package:cantool/entity/signal_meta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers.dart';
import 'models.dart';

class ReplayPageController {
  final Reader read;
  ReplayPageController(this.read);

  void toggleStatus(Signal s) async {
    s.selected = !s.selected;
    final msgsState = read(filterMsgSignalProvider);
    final msgs = msgsState.state;
    msgs[s.mid].signals[s.name] = Signal(s.name, s.selected, mid: s.mid);

    msgsState.state = msgs;
  }

  void removeSignal(Signal s) {
    final msgsState = read(filterMsgSignalProvider);
    final msgs = msgsState.state;

    msgs[s.mid] ??= Message({}, id: s.mid);
    msgs[s.mid].signals.remove(s.name);

    msgsState.state = msgs;
  }

  void addSignalByMeta(SignalMeta sm) {
    final msgsState = read(filterMsgSignalProvider);
    final msgs = msgsState.state;

    msgs[sm.mid] ??= Message({}, id: sm.mid);
    msgs[sm.mid].signals[sm.name] ??= Signal(sm.name, true, mid: sm.mid);

    msgsState.state = msgs;
  }

  void removeSignalByMeta(SignalMeta sm) {
    final msgsState = read(filterMsgSignalProvider);
    final msgs = msgsState.state;

    msgs[sm.mid] ??= Message({}, id: sm.mid);
    msgs[sm.mid].signals.remove(sm.name);

    msgsState.state = msgs;
  }

  void addSignals(List<SignalMeta> ss) {
    final msgsState = read(filterMsgSignalProvider);
    final msgs = msgsState.state;
    ss.forEach((element) {
      msgs[element.mid] ??= Message({}, id: element.mid);
      msgs[element.mid].signals[element.name] ??=
          Signal(element.name, true, mid: element.mid);
    });
    msgsState.state = msgs;
  }
}
