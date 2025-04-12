import 'dart:convert';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/constants/storage_keys.dart';
import 'package:carting/data/models/notification_model.dart';
import 'package:carting/infrastructure/repo/storage_repository.dart';
import 'package:carting/src/settings/notification_servis.dart';
import 'package:carting/utils/log_service.dart';
import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveChatService {
  Client? _client;

  Future<void> connectToLiveChat(BuildContext context) async {
    // JWT token (backendchi bergan)
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjYXJ0aW5nIiwiZXhwIjoyNzQzNTI5NDc2LCJpYXQiOjE3NDM1Mjk0Nzd9.rsjSwXpJLWrF3ik4VmVNeHA5FLCyergx2nEZT257asU';

    const url = 'wss://cabinet.carting.uz/centrifugo/connection/websocket';

    // Centrifugo klientini yaratamiz
    final client = createClient(
      url,
      ClientConfig(token: token),
    );

    // Callbacklar
    // client.onConnected((ctx) {
    //   debugPrint('✅ Connected to Centrifugo');
    // });

    // client.onDisconnected((ctx) {
    //   debugPrint('❌ Disconnected: ${ctx.reason}');
    // });

    // Foydalanuvchi tokenini local storage (shared preferences) dan olish
    // final prefs = await SharedPreferences.getInstance();
    // final userToken = prefs.getString('auth_token');

    // if (userToken == null) {
    //   debugPrint('⚠️ auth_token topilmadi');
    //   return;
    // }

    final channel =
        'carting_uz_${StorageRepository.getString(StorageKeys.TOKEN)}';

    // Subscribe bo'lish
    final sub = client.newSubscription(channel);

    Log.i(sub.channel);

    sub.subscribed.listen((ctx) {
      Log.i('🟢 Subscribed to $channel');
      Log.i('🟢 Subscribed to ${ctx.data}');
    });
    sub.subscribing.listen((ctx) {
      Log.i('🟢 Subscribed to $channel');
      Log.i('🟢 Subscribed to ${ctx.code}');
      Log.i('🟢 Subscribed to ${ctx.reason}');
    });

    sub.publication.listen((ctx) {
      // UTF-8 decoding + JSON parsing
      try {
        final jsonString = utf8.decode(ctx.data);
        final decodedData = jsonDecode(jsonString);
        final model = NotificationModel.fromJson(decodedData);
        LocalNotificationService.showNotification(
          title: "💬 Yangi xabar",
          body: model.message,
        );
        if (context.mounted) {
          context
              .read<AdvertisementBloc>()
              .add(AddNotificationEvent(model: model));
        }
      } catch (e) {
        Log.e('🔴 Unsubscribed to $e');
      }
    });

    sub.leave.listen((ctx) {
      Log.i('🔴 Unsubscribed from $channel');
      Log.i('🟢 Subscribed to ${ctx.user}');
      Log.i('🟢 Subscribed to ${ctx.chanInfo}');
    });

    sub.join.listen((ctx) {
      Log.i('🔴 Unsubscribed from $channel');
      Log.i('🟢 Subscribed to ${ctx.user}');
      Log.i('🟢 Subscribed to ${ctx.chanInfo}');
    });

    sub.error.listen((ctx) {
      debugPrint('📨 Yangi xabar: ${ctx.error}');
    });

    await sub.subscribe();
    await client.connect();

    _client = client;
  }

  void disconnect() {
    _client?.disconnect();
  }
}
