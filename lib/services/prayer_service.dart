import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:logger/logger.dart';
import 'package:eyes_care/main.dart';

class PrayerService extends ChangeNotifier {
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  PrayerTimes? prayerTimes;
  Prayer? nextPrayer;
  DateTime? nextPrayerTime;

  bool isMuslimModeEnabled = false;
  String? city;
  String? country;
  double? latitude;
  double? longitude;

  final Logger _logger = Logger();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  Timer? _uiTimer;

  // Callback to trigger UI actions like blocking the screen
  Function(bool isPlaying)? onAdhanStateChanged;

  Future<void> init() async {
    isMuslimModeEnabled =
        await PreferenceService.getBool(
          PreferenceService.muslimModeEnabledKey,
        ) ??
        false;
    city = await PreferenceService.getString(PreferenceService.cityKey);
    country = await PreferenceService.getString(PreferenceService.countryKey);
    latitude = await PreferenceService.getDouble(PreferenceService.latitudeKey);
    longitude = await PreferenceService.getDouble(
      PreferenceService.longitudeKey,
    );

    if (isMuslimModeEnabled && latitude != null && longitude != null) {
      _calculatePrayerTimes();
    }
  }

  Future<void> toggleMuslimMode(bool value) async {
    isMuslimModeEnabled = value;
    await PreferenceService.setBool(
      PreferenceService.muslimModeEnabledKey,
      value,
    );
    if (value && latitude != null && longitude != null) {
      _calculatePrayerTimes();
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  Future<bool> detectLocation({BuildContext? context}) async {
    try {
      final position = await _getDevicePosition(context: context);

      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        await _reverseGeocode(latitude!, longitude!);
      } else if (Platform.isLinux) {
        final ipLocation = await _fetchLocationFromIp();
        if (ipLocation == null) return false;
        latitude = ipLocation.lat;
        longitude = ipLocation.lon;
        city = ipLocation.city;
        country = ipLocation.country;
        if (city == null || country == null) {
          await _reverseGeocode(latitude!, longitude!);
        }
      } else {
        return false;
      }

      await _saveLocation();
      if (isMuslimModeEnabled) {
        _calculatePrayerTimes();
      }
      notifyListeners();
      return true;
    } catch (e, st) {
      _logger.e('Error fetching location', error: e, stackTrace: st);
      return false;
    }
  }

  Future<Position?> _getDevicePosition({BuildContext? context}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logger.w('Location services are disabled.');
        if (context != null && context.mounted) {
          _showLocationDisabledDialog(context);
        }
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _logger.w('Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _logger.w('Location permissions are permanently denied.');
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings:
            Platform.isLinux
                ? const LocationSettings(timeLimit: Duration(seconds: 6))
                : null,
      );
    } catch (e, st) {
      _logger.w('Geolocator failed', error: e, stackTrace: st);
      if (!Platform.isLinux) rethrow;
      return null;
    }
  }

  void _showLocationDisabledDialog(BuildContext context) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(loc.locationDisabled),
            content: Text(loc.enableLocationPrompt),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(loc.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Geolocator.openLocationSettings();
                },
                child: Text(loc.openSettings),
              ),
            ],
          ),
    );
  }

  Future<void> _reverseGeocode(double lat, double lon) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1';
    final response = await http
        .get(Uri.parse(url), headers: {'User-Agent': 'Taline-App/1.0'})
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final address = data['address'];
      if (address != null) {
        city =
            address['city'] ??
            address['town'] ??
            address['village'] ??
            address['county'] ??
            'Unknown';
        country = address['country'] ?? 'Unknown';
        return;
      }
    }
    city = 'Unknown';
    country = 'Unknown';
  }

  Future<({double lat, double lon, String? city, String? country})?>
  _fetchLocationFromIp() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://ipwho.is/'),
            headers: {'User-Agent': 'Taline-App/1.0'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final lat = (data['latitude'] as num?)?.toDouble();
        final lon = (data['longitude'] as num?)?.toDouble();
        if (data['success'] == true && lat != null && lon != null) {
          return (
            lat: lat,
            lon: lon,
            city: data['city'] as String?,
            country: data['country'] as String?,
          );
        }
      }
    } catch (e, st) {
      _logger.e('IP location fallback failed', error: e, stackTrace: st);
    }
    return null;
  }

  Future<void> _saveLocation() async {
    if (city != null) {
      await PreferenceService.setString(PreferenceService.cityKey, city!);
    }
    if (country != null) {
      await PreferenceService.setString(PreferenceService.countryKey, country!);
    }
    await PreferenceService.setDouble(PreferenceService.latitudeKey, latitude!);
    await PreferenceService.setDouble(
      PreferenceService.longitudeKey,
      longitude!,
    );
  }

  void _calculatePrayerTimes() {
    if (latitude == null || longitude == null) return;

    final coordinates = Coordinates(latitude!, longitude!);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final date = DateComponents.from(DateTime.now());

    prayerTimes = PrayerTimes(coordinates, date, params);
    _scheduleNextPrayer();
    notifyListeners();
  }

  void _scheduleNextPrayer() {
    _timer?.cancel();
    _uiTimer?.cancel();
    if (prayerTimes == null) return;

    final now = DateTime.now();
    final actualNextPrayer = prayerTimes!.nextPrayer();
    DateTime? actualNextPrayerTime;

    if (actualNextPrayer == Prayer.none) {
      // All prayers for today are done, schedule for tomorrow's Fajr by recalculating at midnight
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final diff = tomorrow.difference(now);
      _timer = Timer(diff, _calculatePrayerTimes);

      final tomorrowDate = DateComponents.from(tomorrow);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      final tomorrowPrayerTimes = PrayerTimes(
        Coordinates(latitude!, longitude!),
        tomorrowDate,
        params,
      );
      actualNextPrayerTime = tomorrowPrayerTimes.fajr;
    } else {
      actualNextPrayerTime = prayerTimes!.timeForPrayer(actualNextPrayer);
      if (actualNextPrayerTime != null) {
        final durationUntilNext = actualNextPrayerTime.difference(now);
        if (durationUntilNext.isNegative) {
          _calculatePrayerTimes();
          return;
        }
        _timer = Timer(durationUntilNext, _onPrayerTime);
      }
    }

    // Determine the prayer to display on the UI
    final current = prayerTimes!.currentPrayer();
    final currentTime =
        current != Prayer.none ? prayerTimes!.timeForPrayer(current) : null;

    if (currentTime != null &&
        now.difference(currentTime) < const Duration(minutes: 20) &&
        !now.difference(currentTime).isNegative) {
      // Show the current prayer for up to 20 minutes after its time
      nextPrayer = current;
      nextPrayerTime = currentTime;

      final timeToSwitch =
          const Duration(minutes: 20) - now.difference(currentTime);
      _uiTimer = Timer(timeToSwitch, () {
        nextPrayer = actualNextPrayer;
        nextPrayerTime = actualNextPrayerTime;
        notifyListeners();
      });
    } else {
      nextPrayer = actualNextPrayer;
      nextPrayerTime = actualNextPrayerTime;
    }

    notifyListeners();
  }

  bool isAdhanPlaying = false;
  LocalNotification? _adhanNotification;

  void _onPrayerTime() async {
    isAdhanPlaying = true;
    notifyListeners();

    // Play Adhan
    await _audioPlayer.play(AssetSource('audio/adhan.mp3'));

    // Listen for audio completion to reset state
    _audioPlayer.onPlayerComplete.listen((_) {
      stopAdhan();
    });

    // Show native notification
    final loc = lookupAppLocalizations(localeNotifier.value);
    _adhanNotification = LocalNotification(
      title: 'Taline',
      body: loc.timeForPrayer,
      actions: [LocalNotificationAction(text: loc.stopAdhan)],
    );

    _adhanNotification?.onClickAction = (actionIndex) {
      if (actionIndex == 0) {
        stopAdhan();
      }
    };

    _adhanNotification?.onShow = () {
      if (onAdhanStateChanged != null) {
        onAdhanStateChanged!(true);
      }
    };

    _adhanNotification?.show();

    // Schedule the next prayer
    _scheduleNextPrayer();
  }

  void stopAdhan() {
    _audioPlayer.stop();
    isAdhanPlaying = false;
    _adhanNotification?.close();
    _adhanNotification = null;
    if (onAdhanStateChanged != null) {
      onAdhanStateChanged!(false);
    }
    notifyListeners();
  }
}
