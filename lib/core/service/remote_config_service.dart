import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static Future<void> setupRemoteConfig() async {
    log("Remote config service setup called");
    final remoteConfig = FirebaseRemoteConfig.instance;

    remoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: const Duration(seconds: 30), minimumFetchInterval: Duration.zero),
    );

    await remoteConfig.setDefaults({
      "app_version": """
      {
      "android":{"last_version":"1.0.0","message":"Some new Features added","min_required_version":"1.0.0","title":"Grid Wars","update_type":"major"},
      "ios":{"last_version":"1.0.0","message":"Some new Features added","min_required_version":"1.0.0","title":"Grid Wars","update_type":"major"}
      }
      """,
    });
  }

  static Future<void> fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      // Handle fetch error
    }
  }
}
