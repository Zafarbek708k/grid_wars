import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_session_cubit/ocean_session_cubit.dart';

void main() {
  group('OceanSessionCubit', () {
    late OceanSessionCubit cubit;
    setUp(() => cubit = OceanSessionCubit()..start());
    tearDown(() => cubit.close());

    test('10 ta plastikdan keyin level 2 bo\'ladi', () {
      var leveledUp = false;
      for (var i = 0; i < 10; i++) {
        leveledUp = cubit.collectTrash();
      }
      expect(cubit.state.level, 2);
      expect(leveledUp, isTrue);
    });

    test('qalqon bor bo\'lsa dushman o\'yinni tugatmaydi', () {
      cubit.updateShield(3);
      expect(cubit.hitEnemy(), isFalse);
      expect(cubit.state.status, OceanStatus.playing);
    });

    test('pauzada ochko qo\'shilmaydi', () {
      cubit.pause();
      cubit.collectTrash();
      expect(cubit.state.score, 0);
    });

    test('qalqonsiz dushmanga tegilsa o\'yin tugaydi', () {
      expect(cubit.hitEnemy(), isTrue);
      expect(cubit.state.status, OceanStatus.gameOver);
    });

    test('menyuga qaytish holatni to\'liq tozalaydi', () {
      for (var i = 0; i < 15; i++) {
        cubit.collectTrash();
      }
      cubit.backToMenu();
      expect(cubit.state.status, OceanStatus.menu);
      expect(cubit.state.score, 0);
      expect(cubit.state.level, 1);
    });

    test('pauza faqat playing holatida ishlaydi', () {
      cubit.pause();
      expect(cubit.state.status, OceanStatus.paused);

      // Pausing again (already paused) must be a no-op.
      cubit.pause();
      expect(cubit.state.status, OceanStatus.paused);

      cubit.resume();
      expect(cubit.state.status, OceanStatus.playing);
    });
  });
}
