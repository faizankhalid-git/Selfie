enum AppEnvironment { development, staging, production }

class AppConfig {
  const AppConfig({required this.environment, required this.applicationId});

  final AppEnvironment environment;
  final String applicationId;

  static AppConfig fromDefines() {
    final value = const String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    final environment = AppEnvironment.values.firstWhere(
      (item) => item.name == value,
      orElse: () => AppEnvironment.development,
    );
    return AppConfig(
      environment: environment,
      applicationId: const String.fromEnvironment(
        'APPLICATION_ID',
        defaultValue: 'com.company.posecoach',
      ),
    );
  }
}
