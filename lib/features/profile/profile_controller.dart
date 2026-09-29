import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  String name = 'Alex Mercer';
  String role = 'Field Volunteer';
  String location = 'Kollam, India';
  
  bool offlineData = true;
  bool emergencyAlerts = true;
  bool nearbyAlerts = true;
  bool shelterUpdates = true;
  bool locationSharing = true;

  void updateProfile(String newName, String newRole, String newLocation) {
    name = newName;
    role = newRole;
    location = newLocation;
    notifyListeners();
  }

  void toggleLocationSharing(bool val) {
    locationSharing = val;
    notifyListeners();
  }

  void toggleOfflineData(bool val) {
    offlineData = val;
    notifyListeners();
  }

  void toggleEmergencyAlerts(bool val) {
    emergencyAlerts = val;
    notifyListeners();
  }

  void toggleNearbyAlerts(bool val) {
    nearbyAlerts = val;
    notifyListeners();
  }

  void toggleShelterUpdates(bool val) {
    shelterUpdates = val;
    notifyListeners();
  }
}
