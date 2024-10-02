import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sabay_ka/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PocketbaseService extends ChangeNotifier {
  late PocketBase _client;
  User? user;
  Future signInWithEmailAndPassword({required String email, required String password});
  Future signInWithGoogle();
  void signOut();
}


class PocketbaseServiceImpl extends PocketbaseService {
  PocketbaseServiceImpl._create(String url, AsyncAuthStore authStore) {
    _client = PocketBase(url, authStore: authStore);

    _client.authStore.onChange.listen((AuthStoreEvent event) {
      if (event.model is RecordModel) {
        user = User.fromJson(event.model.toJson());
        user?.token = event.token;
      } else {
        user = null;
      }
    });
  }

  static Future<PocketbaseService> create() async {
    final String? baseUrl = FlutterConfig.get('POCKETBASE_URL');
    if (baseUrl == null) {
      throw Exception('POCKETBASE_URL is not set in .env');
    }

    final prefs = await SharedPreferences.getInstance();
    final authStore = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    return PocketbaseServiceImpl._create(baseUrl, authStore);
  }

  @override
  Future signInWithEmailAndPassword({required String email, required String password}) async {
    await _client.collection('users').authWithPassword(email, password);
  }

  @override
  Future signInWithGoogle() async {
    await _client.collection('users').authWithOAuth2('google', (Uri uri) async {
      try {
        await launchUrl(uri, customTabsOptions: CustomTabsOptions(
          showTitle: true,
          urlBarHidingEnabled: true,
        ));
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void signOut() {
    _client.authStore.clear();
  }
}
