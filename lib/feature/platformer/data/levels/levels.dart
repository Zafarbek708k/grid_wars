import 'package:grid_wars/feature/platformer/data/levels/level_1.dart';
import 'package:grid_wars/feature/platformer/data/levels/level_2.dart';
import 'package:grid_wars/feature/platformer/data/levels/level_3.dart';
import 'package:grid_wars/feature/platformer/domain/entities/level_model.dart';

/// Builders for all playable platformer levels, in progression order.
/// Each entry is a factory (not an instance) so loading/restarting a level
/// always starts from a clean state (unused blocks, uncollected coins).
final List<LevelModel Function()> platformerLevelBuilders = [
  createLevel1,
  createLevel2,
  createLevel3,
];
