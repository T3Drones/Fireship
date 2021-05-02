import 'package:fireship/services/db.dart';
import 'package:fireship/services/models.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // Data Models
  static final Map models = {
    Topic: (data) => Topic.fromMap(data),
    Quiz: (data) => Quiz.fromMap(data),
    Report: (data) => Report.fromMap(data),
  };

  // Firestore Reference for Writers.
  static final Collection<Topic> topicsRef = Collection<Topic>(path: 'topics');
  static final UserData<Report> reportRef =
      UserData<Report>(collection: 'reports');
}
