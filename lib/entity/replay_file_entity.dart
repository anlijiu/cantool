import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:can/can.dart' as can;

part 'replay_file_entity.freezed.dart';
part 'replay_file_entity.g.dart';

@freezed
abstract class ReplayFileEntity with _$ReplayFileEntity {
  factory ReplayFileEntity({
    @nullable @required String path,
  }) = _ReplayFileEntity;

  factory ReplayFileEntity.fromJson(Map<String, dynamic> json) =>
      _$ReplayFileEntityFromJson(json);
}

class ReplayFile extends StateNotifier<ReplayFileEntity> {
  final Reader read;

  ReplayFile(this.read, [ReplayFileEntity entity]) : super(entity ?? null);

  Future<void> load() async {
    final result = await file_chooser.showSavePanel(
      allowedFileTypes: const [
        file_chooser.FileTypeFilterGroup(
          fileExtensions: ['blf', 'asc'],
        )
      ],
    );

    if (!result.canceled) {
      print("replay file name :" + result.paths[0]);
      await can.setReplayFile(result.paths[0]);
      state = ReplayFileEntity(path: result.paths[0]);
      print("replay file fileAttributs :" + state.toString());
    }
  }
}
