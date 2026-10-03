# Grid Wars — Application Documentation

A Flutter-based multi-game hub ("Game Hub") for Android and iOS. This document covers the app's architecture, folder structure, theming, localization/storage, every game's rules and controls, and a developer guide for extending the codebase.

**Package:** `grid_wars` · **Version:** see `pubspec.yaml` (`version:`) · **Flutter/Dart SDK:** `^3.9.2`

---

## Table of Contents

1. [Tech Stack](#1-tech-stack)
2. [App Structure & Architecture Pattern](#2-app-structure--architecture-pattern)
3. [Folder Structure](#3-folder-structure)
4. [Theme System](#4-theme-system)
5. [Localization](#5-localization)
6. [Storage & Persistence](#6-storage--persistence)
7. [Navigation](#7-navigation)
8. [App Startup Flow](#8-app-startup-flow)
9. [Games — Architecture & How to Play](#9-games--architecture--how-to-play)
10. [Daily Challenge](#10-daily-challenge)
11. [Game History (Profile)](#11-game-history-profile)
12. [Developer Guide](#12-developer-guide)

---

## 1. Tech Stack

| Concern | Package |
|---|---|
| State management | `flutter_bloc` (Bloc + Cubit), `equatable` |
| Navigation | Custom `onGenerateRoute` (`AppRouter`) + a hand-rolled bottom-tab `Navigator`-per-tab system |
| Localization | `easy_localization` (JSON translation files) |
| Local storage | `shared_preferences` (wrapped by `StorageRepository`) |
| Backend/remote | `firebase_core`, `firebase_analytics`, `firebase_remote_config` |
| Icons/images | `flutter_svg` (all icons are SVG), local raster images for memory-match cards |
| Animation | Flutter's own `AnimationController`/`Tween` system; `animate_do` is a listed dependency but not yet used anywhere |
| Haptics | `flutter/services.dart` `HapticFeedback` (iOS) + `vibration` package (Android) |
| Misc | `url_launcher`, `top_snackbar_flutter`, `get_it` (declared, not actively used for DI in the reviewed code) |

---

## 2. App Structure & Architecture Pattern

The app follows a **feature-first**, loosely clean-architecture layout: `lib/core` holds cross-cutting concerns, and everything else lives under `lib/feature/<name>/`. Each game/feature is self-contained — its own folder, own Bloc, own pages — so features can be added or removed without touching unrelated code.

Within a feature, the convention (introduced consistently across every game added in recent work, and matching the pre-existing `settings` feature) is:

```
lib/feature/<feature_name>/
  domain/
    entities/      # plain data classes / enums — no Flutter, no Bloc
    services/      # pure logic (generators, solvers, physics/collision) — no Flutter, no Bloc
  data/             # only where a feature has "data sources" (currently just platformer's levels)
  presentation/
    blocs/          # flutter_bloc Bloc or Cubit — the only layer allowed to hold UI-facing state
    pages/          # full-screen widgets (routed to)
    widgets/        # feature-local reusable widgets
```

**Why the domain/presentation split matters here:** every generator/solver (Sudoku's backtracking solver, the 2048 merge engine, Minesweeper's flood-fill, the Word Search word-placement algorithm, the platformer's collision engine) is a **pure, static, Flutter-free class** under `domain/services/`. This is what makes them unit-testable without a widget test harness — see `test/*.dart`, which tests these engines directly.

Not every feature needs every layer — simple features (e.g. `x_and_o`, `nard`) skip `domain/` entirely and keep everything in the Bloc, since there's no meaningful pure-logic layer to separate out.

---

## 3. Folder Structure

```
lib/
├── main.dart                        # Entry point: Firebase, EasyLocalization, StorageRepository init
├── firebase_options.dart            # Generated Firebase config
│
├── core/                            # Cross-cutting, shared by every feature
│   ├── constants/
│   │   ├── app_colors.dart          # Named Color palette + gradients
│   │   ├── app_icons.dart           # SVG asset path constants
│   │   ├── app_images.dart          # Raster image path constants (memory-match art)
│   │   ├── locale_keys.dart         # Generated easy_localization key constants
│   │   ├── storage_keys.dart        # SharedPreferences key constants (legacy/general keys)
│   │   └── firebase_remote_config_keys.dart
│   ├── enums/                       # HomeScreenApps, GameItemTypeEnum, LanguageEnum, ThemeEnum, ...
│   ├── extensions/
│   │   └── context_extension.dart   # context.textTheme / context.themeExtension / context.locale helpers
│   ├── router/
│   │   └── app_router.dart          # Every game's route name + onGenerateRoute switch
│   ├── service/
│   │   ├── storage_service.dart     # StorageRepository — SharedPreferences wrapper (see §6)
│   │   └── remote_config_service.dart
│   ├── theme/
│   │   ├── dark.dart / light.dart   # ThemeData + full TextTheme per mode
│   │   └── theme_extension.dart     # AppThemeExtension (custom semantic colors)
│   └── widgets/
│       ├── app_scope.dart           # EasyLocalization wrapper (root of the widget tree)
│       ├── grid_wars_game.dart       # MaterialApp + all root BlocProviders
│       └── buttons/animated_button.dart
│
└── feature/
    ├── init/                       # Splash screen (+ a legacy unused Menu widget)
    ├── navigation/                 # Bottom-tab shell: MainNavigation, per-tab Navigators, NavBarEnum
    ├── home/                       # Home tab: game grid, streak teaser
    ├── daily_challenge/            # "Games" tab: streak-tracked daily featured game
    ├── profile/                    # Profile tab: language, share, daily-challenge summary, game history
    ├── settings/                   # App config/version-check Blocs, shared AppScreen/CustomAppBar chrome
    │
    ├── x_and_o/                    # Tic Tac Toe
    ├── memory_match/                # Memory Match
    ├── mental/                     # Mental Math
    ├── platformer/                 # Super Platformer (Mario-style)
    ├── puzzle15/                   # 15 Puzzle (4x4/5x5/6x6 sliding puzzle)
    ├── sudoku/                     # Sudoku
    ├── nard/                       # Nard (dice-count companion)
    ├── word_search/                # Word Search
    ├── game_2048/                  # 2048
    ├── minesweeper/                # Minesweeper
    └── game_stats/                 # Cross-game play-history service (no UI of its own)
```

Every game feature internally follows the `domain/{entities,services}` + `presentation/{blocs,pages,widgets}` layout from §2. See §9 for each one's specific files.

---

## 4. Theme System

- **Colors** — `lib/core/constants/app_colors.dart`: a flat palette of named `Color` constants (`AppColors.cyan`, `.white`, `.black`, `.grey`, …) plus two reusable gradients (`cyanToPurple`, `disabledGradient`). Almost every screen in the app uses the same hand-picked dark gradient background: `[Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)]`, top-left → bottom-right (sometimes rotated).
- **ThemeData** — `lib/core/theme/dark.dart` and `light.dart`: each defines a full Material `TextTheme` (all 15 slots — display/headline/body/label/title × large/medium/small) using the **"Exo"** font family, plus `ThemeData.extensions`.
- **AppThemeExtension** (`theme_extension.dart`) — a custom `ThemeExtension` with three semantic colors that flip between modes: `whiteToDark`, `darkToWhite`, `whiteToCyan`. Accessed everywhere via `context.themeExtension.whiteToCyan` (see `context_extension.dart`). This is how e.g. the same icon renders white in one mode and cyan in another without `if` statements at every call site.
- **Current behavior:** `GridWarsGame` (in `grid_wars_game.dart`) sets `themeMode: ThemeMode.dark` unconditionally — the app always renders in dark mode today regardless of the user's saved theme preference in `AppSettingBloc`, even though both `Dark.theme()` and `Light.theme()` exist and the Profile screen has no theme picker exposed yet (only a language picker).
- **Bottom navigation bar** — not a Material `BottomNavigationBar`; it's a custom "liquid glass" pill built from `BackdropFilter(ImageFilter.blur(...))` + a translucent gradient border, with a glowing cyan pill that slides (via `AnimatedAlign` + `Curves.easeOutBack`) to sit behind whichever tab is active. See `lib/feature/navigation/main_navigation.dart`.

---

## 5. Localization

- Package: `easy_localization`. Root wrapper: `GridWarsAppScope` (`core/widgets/app_scope.dart`):
  ```dart
  EasyLocalization(
    supportedLocales: [Locale('en'), Locale('ru'), Locale('uz')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),
    saveLocale: true,
  )
  ```
- Translation files: `assets/translations/{en,ru,uz}.json` — flat key→string maps (e.g. `"play_now": "Play now"`). `LocaleKeys` (`core/constants/locale_keys.dart`) is a generated Dart file exposing each JSON key as a `static const String`, so call sites use `LocaleKeys.playNow.tr()` instead of raw string keys (typo-safe, IDE-discoverable).
- **`saveLocale: true`** means the chosen language persists automatically between app launches (easy_localization stores it internally via its own SharedPreferences key — this is separate from `StorageRepository`).
- Changing language: Profile screen → Language card → `context.setLocale(Locale(code))` + `AppSettingBloc.add(ChangeLanguageEvent(...))` (the Bloc event exists so the rest of the app's Bloc-driven UI reacts to the change, not just the raw `easy_localization` locale).
- **Coverage note:** localization is inconsistent across the app. Older screens (`home_screen.dart`, `profile_screen.dart`, navigation labels) use `LocaleKeys.xxx.tr()`. Every game added in the most recent development pass (Puzzle15, Sudoku, 2048, Minesweeper, Word Search, Nard, and the Daily Challenge/Game History Profile cards) uses **hardcoded English strings** instead — they were built to match the existing house style of `x_and_o`/`memory_match`/`platformer`, which also mix hardcoded strings with `LocaleKeys` (e.g. "GAME OVER", "PLAY", "Wins" are literal strings; `LocaleKeys.resetGame`/`.youWin`/`.playAgain`/`.backToHome` are the ones actually localized). None of the new games' UI text has `ru`/`uz` translations yet.

---

## 6. Storage & Persistence

Everything persists through **`StorageRepository`** (`lib/core/service/storage_service.dart`) — a thin static wrapper over a single cached `SharedPreferences` instance:

```dart
await StorageRepository.getInstance();   // called once, in main.dart, before runApp
StorageRepository.getInt(key, {defValue});
StorageRepository.putInt(key, value);     // returns Future<bool>?
StorageRepository.getString / putString / getBool / putBool / getDouble / putDouble / getList / putList
StorageRepository.deleteInt / deleteString / deleteBool / deleteList / deleteDouble
```

If `getInstance()` hasn't resolved yet, every getter safely returns its `defValue` and every setter is a no-op (returns `null`) rather than throwing — so nothing crashes even if a call happens unusually early.

Three things are built on top of `StorageRepository`, each owning its own key namespace:

1. **`DailyChallengeService`** (`feature/daily_challenge/domain/services/`) — streak tracking. Keys: `daily_challenge_last_date`, `daily_challenge_current_streak`, `daily_challenge_longest_streak`, `daily_challenge_total_completed`, `daily_challenge_history` (a capped list of the last 14 completed dates, used to render the 7-day dot strip).
2. **`GameStatsService`** (`feature/game_stats/domain/services/`) — per-game play history. Keys are namespaced per game id: `game_stats_<id>_times`, `game_stats_<id>_last_played`, `game_stats_<id>_best`.
3. **2048's best score** — `game_2048_best_score`, set directly inside `Game2048Bloc` (predates `GameStatsService`; kept separate since it's read synchronously into the Bloc's own state on every new game).

Both services store dates as plain `yyyy-MM-dd` strings (via `intl`'s `DateFormat`) rather than epoch timestamps, specifically so "same calendar day" comparisons ("did I already complete today?") don't need timezone-aware datetime math.

**This is all on-device only.** There is no backend account system, no cloud sync, and no real leaderboard — "rank"/history is purely local to the device (confirmed as the intended design, not a limitation to fix).

---

## 7. Navigation

Two navigation layers:

1. **Bottom-tab shell** (`feature/navigation/`) — `MainNavigation` hosts a 3-tab `TabBarView` (`NavBarEnum.home / games / profile`), each tab wrapping its **own** `Navigator` (`TabNavigator`, keyed per tab) so each tab keeps its own push/pop history independently, and `AutomaticKeepAliveClientMixin` keeps all three tabs' widget trees alive simultaneously (switching tabs never rebuilds from scratch). Tapping a nav icon calls `BottomNavigationBarCubit.changeIndex(i)`; a `BlocListener` in `MainNavigation` reacts by animating the `TabController` and then resetting the cubit's index back to `-1` (so the same tab can be tapped again later and still fire the listener).
   - The **games** tab currently renders `DailyChallengeScreen`, not a generic "all games" list (that screen, `GameScreen`, was removed as redundant with Home's grid — see §10).
2. **Root-level game routes** (`core/router/app_router.dart`) — every actual game is pushed via `Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.xxx)`, i.e. **above** the bottom-tab shell entirely (games are full-screen and hide the bottom bar; there is no bottom bar visible while playing). `AppRouter.onGenerateRoute` is a single `switch` mapping each route name to a `MaterialPageRoute`, wrapping the page in a `BlocProvider` that constructs that game's Bloc.

| Route constant | Screen |
|---|---|
| `AppRouter.platformer` | Super Platformer |
| `AppRouter.xAndO` | Tic Tac Toe |
| `AppRouter.memoryMatch` | Memory Match |
| `AppRouter.mental` | Mental Math |
| `AppRouter.puzzle15` | 15 Puzzle |
| `AppRouter.sudoku` | Sudoku |
| `AppRouter.nard` | Nard |
| `AppRouter.game2048` | 2048 |
| `AppRouter.minesweeper` | Minesweeper |
| `AppRouter.wordSearch` | Word Search |

---

## 8. App Startup Flow

```
main()
 → runZonedGuarded(...)                       # catches otherwise-uncaught async errors app-wide
 → WidgetsFlutterBinding.ensureInitialized()
 → EasyLocalization.ensureInitialized()
 → Firebase.initializeApp(...)
 → StorageRepository.getInstance()             # must resolve before any game reads/writes stats
 → runApp(GridWarsAppScope(child: GridWarsGame(analytics: ...)))
      GridWarsAppScope   → wraps everything in EasyLocalization
      GridWarsGame       → MultiBlocProvider (BottomNavigationBarCubit, AppSettingBloc, AppConfigBloc)
                          → MaterialApp(home: Splash())
Splash (feature/init/pages/splash.dart)
 → fires AppConfigBloc's InitializeConfigEvent (remote config / version-check)
 → plays a ~1.7s staged entrance animation (logo pop, orbiting game icons, text, loading dots)
 → after a fixed 2.6s delay, replaces itself with MainNavigation
```

---

## 9. Games — Architecture & How to Play

Every game below follows the same page chrome: a `Scaffold` with a translucent `AppBar` (back button via `AnimatedButton`), the shared dark gradient background, and (where applicable) a center-docked reset `FloatingActionButton`. Win/lose feedback is a `Dialog` shown via `showDialog`.

> **Provider gotcha (already fixed, but relevant if you add a new game):** `showDialog`'s route is a *sibling* of the page's `BlocProvider`, not a descendant — a dialog declared as its own widget class calling `context.read<SomeBloc>()` on its own fresh `BuildContext` will throw `ProviderNotFoundException`. The fix used throughout this codebase: capture the bloc in the *listener's* context (which does have the provider) and wrap the dialog's `builder` result in `BlocProvider.value(value: bloc, child: ...)`.

### 9.1 Tic Tac Toe (`feature/x_and_o/`)
- **Files:** `presentation/blocs/x_and_o_bloc/` (`XOBloc`, no domain layer needed), `presentation/pages/x_and_o.dart`.
- **State:** a 9-cell `List<GameItemTypeEnum>` board, current player, winner, winning line.
- **How to play:** two players share one device, tapping cells alternately (X first). Filling any row/column/diagonal with the same symbol wins; a full board with no winner is a draw. Tap the reset button to clear the board.

### 9.2 Memory Match (`feature/memory_match/`)
- **Files:** `domain/entities/memory_card.dart`, `presentation/blocs/memory_match_bloc/`, `presentation/pages/memory_match.dart`.
- **State:** 16 face-down cards (8 space-themed images, each duplicated), which two are currently flipped, whether input is temporarily blocked.
- **How to play:** tap two cards to flip them. Matching pair → both stay face-up. Non-matching pair → they flip back after ~1 second (input is blocked during that delay). Match all 8 pairs to win.

### 9.3 Mental Math (`feature/mental/`)
- **Files:** `domain/entities/{answer,mental_question}.dart`, `presentation/blocs/mental_bloc/`, `presentation/pages/mental.dart`, `presentation/widgets/` (answer button, answers grid, math text, result dialog, time progress bar).
- **State:** a rolling list of generated questions (+, −, ×, ÷, with the unknown randomly in any position: `? + 3 = 7`, `3 + ? = 7`, or `3 + 4 = ?`), a 10-second per-question timer, correct-answer streak.
- **How to play:** pick the correct answer from 4 options before the timer runs out. Every correct answer resets the 10-second timer and advances to the next question; difficulty (the number range) increases every 10 questions. One wrong answer or a timeout ends the run and shows your final correct-answer count.

### 9.4 Super Platformer (`feature/platformer/`)
The most complex game — a real-time physics game, not a Bloc-driven turn-based one.
- **Files:**
  - `config/game_config.dart` — every tunable physics/scoring constant (gravity, jump force, player size, colors).
  - `domain/entities/{level_model, platform_model, player_model, coin_model, power_up_model}.dart`
  - `domain/physics/collision_engine.dart` — pure AABB collision math: `isLandingOnTop`, `isHittingFromBelow` (ceiling/head-bump), `isColliding`.
  - `data/levels/{level_1,level_2,level_3,levels}.dart` — 3 hand-built levels (`platformerLevelBuilders`, a list of *factory functions* so restarting a level always starts from clean, unused-block state).
  - `presentation/controllers/game_controller.dart` — a `ChangeNotifier`-based real-time game loop (`Ticker`, ~60fps), not a Bloc (physics doesn't fit request/response state transitions well).
  - `presentation/pages/{platformer_home_screen, platformer_game_page}.dart`, `presentation/widgets/` (HUD, controls, overlays, platform/player/coin/power-up rendering).
- **How to play:** on-screen left/right buttons + a jump button (or arrow keys/Space on a physical keyboard) move Mario-style through a side-scrolling level. Standing on top of any block is always safe; jumping into the underside of a block stops your ascent (head bump) instead of passing through it. **Question blocks** (marked `?`) only sometimes hide a reward — hit one from below to reveal it: a coin (adds to your coin count/score) or a mushroom (grows you permanently for that life, increasing both jump height and move speed). Collect scattered coins directly in the level too. Reach the flag to clear the level; clearing the last level shows "ALL LEVELS CLEAR" instead of a "Next Level" button. Falling into a pit or running out of time costs a life (and shrinks you back to small size on respawn); losing all lives ends the run.

### 9.5 15 Puzzle (`feature/puzzle15/`)
- **Files:** `presentation/blocs/puzzle15_bloc/`, `presentation/pages/puzzle15.dart` (no domain layer — board state is simple enough to live directly in the Bloc).
- **How to play:** choose a 4×4, 5×5, or 6×6 grid size. Tap any numbered tile adjacent to the blank space to slide it into the gap. Arrange all numbers in order (with the blank last) to win. The shuffle algorithm replays random *valid* slides from the solved state (not a raw random permutation), which guarantees every puzzle is solvable.

### 9.6 Sudoku (`feature/sudoku/`)
- **Files:** `domain/entities/{sudoku_difficulty, sudoku_puzzle}.dart`, `domain/services/sudoku_generator.dart` (bitmask-based backtracking solver/generator), `presentation/blocs/sudoku_bloc/`, `presentation/pages/sudoku.dart`.
- **How to play:** pick Easy / Medium / Hard. Tap an empty cell, then tap a number 1–9 (or the backspace icon to clear it) to fill it in. Wrong entries are highlighted red and increment a mistake counter, but don't end the game. Fill every cell to match the unique solution to win. Generation removes clues from a fully solved grid one at a time, keeping each removal only if the puzzle still has exactly one solution (verified via a bounded solution-counter) — so every generated puzzle is guaranteed uniquely solvable, never ambiguous.

### 9.7 2048 (`feature/game_2048/`)
- **Files:** `domain/entities/swipe_direction.dart`, `domain/services/game_2048_engine.dart` (pure slide/merge/spawn/game-over logic), `presentation/blocs/game2048_bloc/`, `presentation/pages/game_2048.dart`.
- **How to play:** swipe up/down/left/right to slide every tile in that direction; equal adjacent tiles merge into one (double the value, once per tile per move), and a new tile (90% a "2", 10% a "4") spawns after any move that actually changed the board. Reach a 2048 tile to win (you can keep playing after); the game ends when the board is full with no possible merges. Your best score persists between sessions.

### 9.8 Minesweeper (`feature/minesweeper/`)
- **Files:** `domain/entities/{mine_cell, minesweeper_difficulty}.dart`, `domain/services/minesweeper_engine.dart` (generation, flood-fill reveal, win detection), `presentation/blocs/minesweeper_bloc/`, `presentation/pages/minesweeper.dart`.
- **How to play:** choose Beginner (9×9, 10 mines) or Intermediate (12×12, 20 mines). Tap a cell to reveal it — the very first tap is always guaranteed safe (mines are placed only after that first reveal, never on it or its neighbors). A revealed cell with no adjacent mines automatically cascades open its whole connected safe area; a numbered cell tells you how many mines touch it. Long-press a cell to flag/unflag it as a suspected mine (flagged cells can't be accidentally revealed). Reveal every non-mine cell to win; revealing a mine ends the game immediately.
- ⚠️ *This game previously had a real bug where taps after the first one silently did nothing until you eventually hit a mine — see §12's "known pitfalls" for why, since it's relevant to any future Bloc work involving mutable objects.*

### 9.9 Word Search (`feature/word_search/`)
- **Files:** `domain/entities/word_search_puzzle.dart`, `domain/services/word_search_generator.dart` (places a themed word list into a grid across all 8 directions), `presentation/blocs/word_search_bloc/`, `presentation/pages/word_search.dart`.
- **How to play:** a 10×10 grid of letters hides 6 space-themed words (SUN, MOON, STAR, MARS, EARTH, COMET, ORBIT, ROCKET, PLANET, VENUS, SATURN, GALAXY — 6 picked at random each game). Drag your finger in a straight line (horizontal, vertical, or diagonal, either direction) across a word's letters and release to check it; a correct selection highlights permanently and crosses the word off the list below the grid. Find every word to win.

### 9.10 Nard (`feature/nard/`)
- **Files:** `presentation/blocs/nard_bloc/`, `presentation/pages/nard.dart` (no domain layer — deliberately simple).
- **Not a full digital backgammon board.** This is a *dice-count companion* for two people playing physical Nard (backgammon) at the same table: it has no board or pieces at all. Tap "Roll Dice" to roll two dice for whoever's turn it is; the sum adds to that player's running total and the turn automatically passes to the other player. Reset clears both scores and starts over. (This scope was explicitly confirmed — a full backgammon rules engine was considered and rejected as out of scope.)

---

## 10. Daily Challenge

Replaces what used to be a redundant "all games" grid on the middle tab (`GameScreen`, since removed) with a streak mechanic, in `feature/daily_challenge/`:

- **`domain/entities/daily_challenge_game.dart`** — a fixed list (`dailyChallengeGames`) of the 9 games that have a clear win condition (Nard is excluded — it has no win/lose state). Each entry has a stable `id`, `title`, `description`, `icon`, and route.
- **`domain/services/daily_challenge_service.dart`** — `todayGame` is computed purely from the date (`day-of-year % 9`, no storage needed — every device shows the same featured game on the same calendar day). `notifyGameCompleted(gameId)` is the single write path, called from each eligible game's win-detection code the moment it fires; it no-ops unless `gameId` matches today's featured game and today hasn't already been credited, then updates the streak (continues if the last completed day was yesterday, otherwise resets to 1), longest streak, total count, and a 14-day history buffer.
- **`presentation/blocs/daily_challenge_cubit.dart`** + **`presentation/pages/daily_challenge_screen.dart`** — shows today's featured game card with a PLAY button, current/longest/total streak stats, and a 7-day dot strip. Refreshes when the tab is (re)entered and again after returning from the pushed game.
- A small **streak teaser** on the Home tab (`_StreakTeaser` in `home_screen.dart`) surfaces the current streak and links to this tab, so the mechanic isn't hidden.

---

## 11. Game History (Profile)

`feature/game_stats/` is a small, UI-free service layer (`GameStatsService` + `GameStatDefinition`/`GameStatSnapshot`, see §6) that every game — all 10, including Nard — reports into on each meaningful completion. The Profile screen (`feature/profile/presentation/`) renders it via two widgets:

- **`daily_challenge_summary_card.dart`** — condensed streak/longest/total numbers (a read-only summary; the interactive view lives on the Daily Challenge tab).
- **`game_history_card.dart`** — one row per game: icon, title, a "last played today/yesterday/N days ago" line, a play/win count (label varies per game — "Wins", "Completed", "Solved", "Games Played", "Rolls"), and where meaningful, a best-value line ("Fewest Moves", "Fewest Mistakes", "Best Score", "Best Correct Answers").

Both are wrapped in a `BlocBuilder<BottomNavigationBarCubit, ...>` specifically so switching to the Profile tab re-reads storage and shows fresh numbers — **that wrapping must never be `const`** (a `const Column` there previously froze the displayed stats permanently after the first render, since Flutter skips rebuilding a subtree when the exact same canonicalized widget instance is handed back — see §12).

---

## 12. Developer Guide

### Running the app
```bash
flutter pub get
flutter run                 # or: flutter run -d chrome / -d <device-id>
```
iOS builds need Xcode selected (`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`) before the simulator will boot.

### Testing
```bash
flutter analyze lib test    # must be clean before considering any change done
flutter test                # unit tests live in test/, one file per pure engine/service + a couple of Bloc-level regression tests
```
Pure logic (Sudoku generator/solver, 2048 engine, Minesweeper engine, Word Search generator/placement, 15-puzzle solvability, `DailyChallengeService`/`GameStatsService` streak math) is tested directly, without a widget harness, precisely because it lives in Flutter-free `domain/services/` classes. Add tests there first when changing any game's rules.

### Adding a new game
1. Create `lib/feature/<name>/` following the `domain/{entities,services}` + `presentation/{blocs,pages,widgets}` layout (§2).
2. Add a route constant + `switch` case in `core/router/app_router.dart`, wrapping the page in a `BlocProvider`.
3. Add a `HomeScreenApps` enum entry (`core/enums/home_screen_apps.dart`) with `isActive: true` and an icon (reuse an existing `AppIcons` entry rather than adding new SVG assets unless truly needed).
4. Add a `(item, route)` tuple to `_HomeScreenState._activeGames` in `home_screen.dart` — the Home grid is data-driven from that list.
5. If the game has a real win condition, add it to `dailyChallengeGames` (`daily_challenge_game.dart`) and call `DailyChallengeService.notifyGameCompleted('yourId')` at the win site.
6. Call `GameStatsService.recordCompletion('yourId', value: ..., lowerIsBetter: ...)` at the same site (or wherever "a play worth counting" happens), and add a matching `GameStatDefinition` entry.
7. If showing a result dialog, remember the `BlocProvider.value` gotcha from §9's callout.

### Known pitfalls (learned the hard way — worth knowing before touching Bloc state)

1. **`Bloc`/`Cubit` silently skip emitting a state that's `Equatable`-equal to the current one.** If a state holds a mutable nested object (e.g. a grid of cells) and you mutate those objects *in place* and reuse the same references across emissions, two different-looking transitions can end up comparing as fully equal (since Equatable's list/element comparison sees the same object instances, mutated or not) — Bloc then drops the emit, and the UI silently stops updating even though your logic ran correctly. This exact bug hit `MinesweeperBloc`: after the first reveal (which changed `firstClickDone`), every *subsequent* reveal mutated the same `MineCell` objects in place with no other field changing, so nothing after the first tap ever reached the screen until a mine flipped `isGameOver`. **Fix:** always build a fresh deep copy of any mutable nested structure before mutating it for a new state (see `MinesweeperBloc._copyBoard`). `Puzzle15Bloc`, `SudokuBloc`, and `Game2048Bloc` never had this problem because they already copy into new lists before mutating.
2. **A `const` widget handed back from a `builder:` callback defeats its own refresh.** `BlocBuilder`'s `builder` gets re-invoked on every state change, but if it always returns the *same canonicalized `const` widget instance*, Flutter's element diffing sees `identical(old, new) == true` and skips rebuilding that subtree's children entirely — so anything reading live data inside a `const` child (like `GameStatsService.getStats()` inside `GameHistoryCard`) freezes at whatever it showed on the very first build. Never mark the widget directly returned by a `builder:` callback `const` if anything inside it needs to reflect data that can change between rebuilds.
3. **`showDialog`'s route is a sibling of the page's `BlocProvider`, not a descendant** (§9's callout) — `context.read<Bloc>()` inside a separately-declared dialog widget throws `ProviderNotFoundException`; capture the bloc from the *listener's* context and pass it down via `BlocProvider.value`.

### Conventions to follow
- Page chrome: `Scaffold` + translucent `AppBar` (back button = `AnimatedButton` + `Icons.arrow_back_ios`) + the shared dark gradient body (`[0xFF0F2027, 0xFF203A43, 0xFF2C5364]`) + center-docked reset FAB. Copy an existing simple game page (`puzzle15.dart` or `sudoku.dart`) as a starting template rather than writing this from scratch.
- Win/lose dialogs: a private `_WinDialog`/`_ResultDialog` widget class per page, styled with the same gradient, using `LocaleKeys.youWin`/`.playAgain`/`.backToHome` where the concept matches (don't invent new hardcoded strings for things that already have a translation key).
- Random number generators should be constructor-injectable (`Bloc({Random? random}) : _random = random ?? Random()`) purely so tests can pass a seeded `Random` for deterministic behavior — every game Bloc in this codebase already does this.
- Prefer extending an existing `HomeScreenApps` enum entry / `AppIcons` constant over adding new assets when a close-enough icon already exists.
