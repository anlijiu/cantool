import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:can/can.dart' as can;

part 'replay_file_entity.freezed.dart';
part 'replay_file_entity.g.dart';

@freezed
class ReplayFileEntity with _$ReplayFileEntity {
  factory ReplayFileEntity({
    @required String? path,
  }) = _ReplayFileEntity;

  factory ReplayFileEntity.fromJson(Map<String, dynamic> json) =>
      _$ReplayFileEntityFromJson(json);
}

class ReplayFile extends StateNotifier<ReplayFileEntity?> {
  final Reader read;

  ReplayFile(this.read, [ReplayFileEntity? entity]) : super(entity);

  void load() async {
    final file_selector.XTypeGroup typeGroup = file_selector.XTypeGroup(
      label: 'blf/asc',
      extensions: ['blf', 'asc'],
    );
    final List<file_selector.XFile> files =
        await file_selector.openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isEmpty) {
      // Operation was canceled by the user.
      return;
    }
    final file_selector.XFile file = files[0];
    final String fileName = file.name;
    final String filePath = file.path;

    await can.setReplayFile(filePath);
    state = ReplayFileEntity(path: filePath);
  }
}
