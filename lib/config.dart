import 'env/env.dart';

class Environments {
  static const String production = 'prod';
  static const String qas = 'QAS';
  static const String dev = 'dev';
  static const String local = 'local';
}

class ConfigEnvironments {
  static const String _currentEnvironments = Env.mode;
  static final List<Map<String, String>> _availableEnvironments = [
    {
      'env': Environments.local,
      'url': 'http://localhost:8080/api/',
    },
    {
      'env': Environments.dev,
      'url': '',
    },
    {
      'env': Environments.qas,
      'url': '',
    },
    {
      'env': Environments.production,
      'url': '',
    },
  ];

  static Map<String, String> getEnvironments() {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
