import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'ResQ',
      'current_location': 'Current Location',
      'locating': 'Locating...',
      'good_morning': 'Good morning.',
      'good_afternoon': 'Good afternoon.',
      'good_evening': 'Good evening.',
      'greeting_sub': 'Here is the latest status for your area.',
      'flood_risk': 'CURRENT FLOOD RISK',
      'medium_risk': 'MEDIUM',
      'risk_elevated': 'Elevated',
      'risk_desc': 'Stay alert and monitor updates. Water levels in nearby rivers are rising slowly.',
      'view_risk_map': 'View Risk Map',
      'report_incident': 'Report Incident',
      'find_shelter': 'Find Shelter',
      'emergency_contacts': 'Emergency Contacts',
      'latest_alerts': 'Latest Alerts',
      'view_all': 'View All',
      'nearby_shelters': 'Nearby Shelters',
      'road_closure': 'ROAD CLOSURE',
      'alert_desc': 'Main Street bridge is temporarily closed due to rising waters.',
      'emergency_hotlines': 'Emergency Hotlines',
      'disaster_control': 'Disaster Control Room',
      'ambulance_rescue': 'Ambulance & Rescue',
      'fire_force': 'Fire Force',
      'home': 'Home',
      'map': 'Map',
      'shelters': 'Shelters',
      'report': 'Report',
      'profile': 'Profile',
      'dark_mode': 'Dark Mode',
      'language': 'Language / ഭാഷ',
      'select_language': 'Select App Language',
      'location_sharing': 'Location Sharing',
      'active_status': 'Active Status',
      'emergency_safety': 'EMERGENCY & SAFETY',
      'app_offline_access': 'APP & OFFLINE ACCESS',
    },
    'ml': {
      'app_title': 'ResQ',
      'current_location': 'നിലവിലെ സ്ഥലം',
      'locating': 'സ്ഥലം കണ്ടെത്തുന്നു...',
      'good_morning': 'സുപ്രഭാതം.',
      'good_afternoon': 'ഉച്ചവന്ദനം.',
      'good_evening': 'സന്ധ്യാവന്ദനം.',
      'greeting_sub': 'നിങ്ങളുടെ പ്രദേശത്തെ ഏറ്റവും പുതിയ വിവരം താഴെ കാണാം.',
      'flood_risk': 'നിലവിലെ വെള്ളപ്പൊക്ക സാധ്യത',
      'medium_risk': 'മിതമായത്',
      'risk_elevated': 'ശ്രദ്ധിക്കുക',
      'risk_desc': 'ജാഗ്രത പാലിക്കുക. സമീപത്തെ പുഴകളിൽ ജലനിരപ്പ് ഉയരുന്നു.',
      'view_risk_map': 'ഭൂപടം കാണുക',
      'report_incident': 'വിവരം അറിയിക്കുക',
      'find_shelter': 'അഭയകേന്ദ്രം തിരയുക',
      'emergency_contacts': 'അടിയന്തര നമ്പറുകൾ',
      'latest_alerts': 'അടിയന്തര മുന്നറിയിപ്പുകൾ',
      'view_all': 'എല്ലാം കാണുക',
      'nearby_shelters': 'അടുത്തുള്ള അഭയകേന്ദ്രങ്ങൾ',
      'road_closure': 'റോഡ് ഗതാഗതം തടസ്സപ്പെട്ടു',
      'alert_desc': 'വെള്ളപ്പൊക്കം കാരണം പ്രധാന പാലം അടച്ചിട്ടിരിക്കുന്നു.',
      'emergency_hotlines': 'അടിയന്തര സഹായ നമ്പറുകൾ',
      'disaster_control': 'ദുരന്തനിവാരണ കൺട്രോൾ റൂം',
      'ambulance_rescue': 'ആംബുലൻസ് & രക്ഷാപ്രവർത്തനം',
      'fire_force': 'ഫയർ ഫോഴ്സ്',
      'home': 'ഹോം',
      'map': 'മാപ്പ്',
      'shelters': 'ഷെൽട്ടറുകൾ',
      'report': 'റിപ്പോർട്ട്',
      'profile': 'പ്രൊഫൈൽ',
      'dark_mode': 'ഡാർക്ക് മോഡ്',
      'language': 'ഭാഷ / Language',
      'select_language': 'ആപ്പ് ഭാഷ തിരഞ്ഞെടുക്കുക',
      'location_sharing': 'ലൊക്കേഷൻ പങ്കിടൽ',
      'active_status': 'സജീവ അവസ്ഥ',
      'emergency_safety': 'അടിയന്തര സുരക്ഷ',
      'app_offline_access': 'ആപ്പ് ക്രമീകരണങ്ങൾ',
    },
    'hi': {
      'app_title': 'ResQ',
      'current_location': 'वर्तमान स्थान',
      'locating': 'स्थान खोजा जा रहा है...',
      'good_morning': 'शुभ प्रभात।',
      'good_afternoon': 'शुभ दोपहर।',
      'good_evening': 'शुभ संध्या।',
      'greeting_sub': 'आपके क्षेत्र की नवीनतम स्थिति यहाँ है।',
      'flood_risk': 'वर्तमान बाढ़ का जोखिम',
      'medium_risk': 'मध्यम',
      'risk_elevated': 'सावधान',
      'risk_desc': 'सतर्क रहें। नजदीकी नदियों में जलस्तर धीरे-धीरे बढ़ रहा है।',
      'view_risk_map': 'जोखिम मानचित्र देखें',
      'report_incident': 'घटना की रिपोर्ट करें',
      'find_shelter': 'आश्रय स्थल खोजें',
      'emergency_contacts': 'आपतकालीन संपर्क',
      'latest_alerts': 'नवीनतम अलर्ट',
      'view_all': 'सभी देखें',
      'nearby_shelters': 'निकटतम आश्रय स्थल',
      'road_closure': 'सड़क बंद',
      'alert_desc': 'बढ़ते जलस्तर के कारण मुख्य पुल अस्थायी रूप से बंद है।',
      'emergency_hotlines': 'आपतकालीन हेल्पलाइन',
      'disaster_control': 'आपदा नियंत्रण कक्ष',
      'ambulance_rescue': 'एंबुलेंस और बचाव',
      'fire_force': 'दमकल सेवा',
      'home': 'होम',
      'map': 'मानचित्र',
      'shelters': 'आश्रय',
      'report': 'रिपोर्ट',
      'profile': 'प्रोफ़ाइल',
      'dark_mode': 'डार्क मोड',
      'language': 'भाषा / Language',
      'select_language': 'ऐप की भाषा चुनें',
      'location_sharing': 'लोकेशन शेयरिंग',
      'active_status': 'सक्रिय स्थिति',
      'emergency_safety': 'आपातकाल और सुरक्षा',
      'app_offline_access': 'ऐप और ऑफ़लाइन एक्सेस',
    },
    'ta': {
      'app_title': 'ResQ',
      'current_location': 'தற்போதைய இடம்',
      'locating': 'இடம் கண்டறியப்படுகிறது...',
      'good_morning': 'காலை வணக்கம்.',
      'good_afternoon': 'மதிய வணக்கம்.',
      'good_evening': 'மாலை வணக்கம்.',
      'greeting_sub': 'உங்கள் பகுதிக்கான சமீபத்திய நிலைமை இதோ.',
      'flood_risk': 'தற்போதைய வெள்ள ஆபத்து',
      'medium_risk': 'நடுத்தரம்',
      'risk_elevated': 'எச்சரிக்கை',
      'risk_desc': 'விழிப்புடன் இருங்கள். அருகிலுள்ள ஆறுகளில் நீர்மட்டம் உயர்கிறது.',
      'view_risk_map': 'வரைபடம் பார்க்க',
      'report_incident': 'தகவல் அளிக்கவும்',
      'find_shelter': 'முகாம் கண்டறிக',
      'emergency_contacts': 'அவசர தொடர்புகள்',
      'latest_alerts': 'சமீபத்திய எச்சரிக்கைகள்',
      'view_all': 'அனைத்தும் பார்க்க',
      'nearby_shelters': 'அருகிலுள்ள நிவாரண முகாம்கள்',
      'road_closure': 'பாதை அடைப்பு',
      'alert_desc': 'வெள்ளப்பெருக்கு காரணமாக பிரதான பாலம் மூடப்பட்டுள்ளது.',
      'emergency_hotlines': 'அவசர உதவி எண்கள்',
      'disaster_control': 'பேரிடர் கட்டுப்பாட்டு அறை',
      'ambulance_rescue': 'ஆம்புலன்ஸ் & மீட்பு படை',
      'fire_force': 'தீயணைப்பு படை',
      'home': 'முகப்பு',
      'map': 'வரைபடம்',
      'shelters': 'முகாம்கள்',
      'report': 'அறிக்கை',
      'profile': 'சுயவிவரம்',
      'dark_mode': 'டார்க் மோட்',
      'language': 'மொழி / Language',
      'select_language': 'பயன்பாட்டு மொழியைத் தேர்ந்தெடுக்கவும்',
      'location_sharing': 'இடப் பகிர்வு',
      'active_status': 'செயலில் உள்ள நிலை',
      'emergency_safety': 'அவசரம் மற்றும் பாதுகாப்பு',
      'app_offline_access': 'செயலி அமைப்புகள்',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ml', 'hi', 'ta'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
