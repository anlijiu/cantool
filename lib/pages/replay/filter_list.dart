import 'package:cantool/entity/replay_model.dart';
import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/pages/replay/providers.dart';
import 'package:cantool/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilteredMessageMapNotifier extends StateNotifier<FilteredMessageMap> {
  FilteredMessageMapNotifier(this.ref, [FilteredMessageMap? initialMap])
      : super(initialMap ?? FilteredMessageMap({}, ""));

  final Ref ref;

  void toggleStatus(Signal s) async {
    s.selected = !s.selected;

    final msgs = state.messages;
    msgs[s.mid]?.signals[s.name] = Signal(s.name, s.selected, s.mid);

    String maxLengthStr = _widestStr(msgs.values);
    state = FilteredMessageMap(msgs, maxLengthStr);
  }

  String _widestStr(Iterable<Message> messages) {
    final signalMetas = ref.read(signalMetasProvider);
    final metas = messages.fold<List<SignalMeta?>>(
        [],
        (previousValue, element) => [
              ...previousValue,
              ...element.signals.keys.map((e) => signalMetas[e]).toList()
            ]);
    return _widestOption(metas);
  }

  void removeSignal(Signal s) {
    final msgs = state.messages;

    msgs[s.mid] ??= Message({}, id: s.mid);
    msgs[s.mid]?.signals.remove(s.name);

    String maxLengthStr = _widestStr(msgs.values);
    state = FilteredMessageMap(msgs, maxLengthStr);
  }

  void addSignalByMeta(SignalMeta sm) {
    final msgs = state.messages;

    msgs[sm.mid] ??= Message({}, id: sm.mid);
    msgs[sm.mid]?.signals[sm.name] ??= Signal(sm.name, true, sm.mid);

    String maxLengthStr = _widestStr(msgs.values);
    print("addSignalByMeta   maxLengthStr: $maxLengthStr");
    state = FilteredMessageMap(msgs, maxLengthStr);
  }

  void removeSignalByMeta(SignalMeta sm) {
    final msgs = state.messages;

    msgs[sm.mid] ??= Message({}, id: sm.mid);
    msgs[sm.mid]?.signals.remove(sm.name);

    String maxLengthStr = _widestStr(msgs.values);
    state = FilteredMessageMap(msgs, maxLengthStr);
  }

  void addSignals(List<SignalMeta> ss) {
    final msgs = state.messages;
    ss.forEach((element) {
      msgs[element.mid] ??= Message({}, id: element.mid);
      msgs[element.mid]?.signals[element.name] ??=
          Signal(element.name, true, element.mid);
    });
    String maxLengthStr = _widestStr(msgs.values);
    state = FilteredMessageMap(msgs, maxLengthStr);
  }

  String _widestOption(List<SignalMeta?> signalMetas) {
    int charactersWidth = 0;
    String widest = "";

    ///从options中找到显示最宽的字符串 决定y轴宽度
    signalMetas.forEach((meta) {
      meta?.options?.entries?.forEach((entry) {
        int w = 0;
        String option = "${entry.key.toRadixString(16)} (${entry.value})";
        option.codeUnits.forEach((c) {
          var cw = characterWidthMap[String.fromCharCode(c)];
          if (cw != null) {
            w += cw;
          } else {
            w += 180;
          }
        });
        print("loop options w:$w, option is $option");
        if (charactersWidth < w) {
          charactersWidth = w;
          widest = option;
        }
      });
    });
    return widest;
  }
}

const characterWidthMap = {
  'a': 60,
  'b': 60,
  'c': 52,
  'd': 60,
  'e': 60,
  'f': 30,
  'g': 60,
  'h': 60,
  'i': 25,
  'j': 25,
  'k': 52,
  'l': 25,
  'm': 87,
  'n': 60,
  'o': 60,
  'p': 60,
  'q': 60,
  'r': 35,
  's': 52,
  't': 30,
  'u': 60,
  'v': 52,
  'w': 77,
  'x': 52,
  'y': 52,
  'z': 52,
  'A': 70,
  'B': 70,
  'C': 77,
  'D': 77,
  'E': 70,
  'F': 65,
  'G': 82,
  'H': 77,
  'I': 30,
  'J': 55,
  'K': 70,
  'L': 60,
  'M': 87,
  'N': 77,
  'O': 82,
  'P': 70,
  'Q': 82,
  'R': 77,
  'S': 70,
  'T': 65,
  'U': 77,
  'V': 70,
  'W': 100,
  'X': 70,
  'Y': 70,
  'Z': 65
};
