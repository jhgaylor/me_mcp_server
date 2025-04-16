import 'package:dotenv/dotenv.dart';
import 'dart:io';

class Config {
  // Server configuration
  late final String host;
  late final int port;
  late final String environment;

  // Candidate info
  late final String profileName;
  late final String resumeText;
  late final String resumeUrl;
  late final String linkedinUrl;
  late final String websiteUrl;

  // Job search parameters
  late final String minSalary;
  late final String maxSalary;
  late final String jobLocation;
  late final String companyType;

  // Server info
  late final String serverName;
  late final String serverVersion;

  static final DotEnv _env = DotEnv(includePlatformEnvironment: true);

  static void loadEnv(String path) {
    try {
      _env.load([path]);
      stderr.writeln('Loaded environment from $path');
    } catch (e) {
      stderr.writeln(
        'No .env file found at $path, using default environment variables',
      );
    }
  }

  static String _getEnv(String key, String defaultValue) {
    return _env[key] ?? defaultValue;
  }

  Config() {
    // Load environment variables first
    final envVarFilePath = _getEnv('ENV_VAR_FILE_PATH', '.env');
    stderr.writeln('Loading environment from $envVarFilePath');
    stderr.writeln('Current working directory: ${Directory.current.path}');
    loadEnv(envVarFilePath);

    host = _getEnv('HOST', '0.0.0.0');
    port = int.tryParse(_getEnv('PORT', '3000')) ?? 3000;
    environment = _getEnv('ENVIRONMENT', 'development');
    profileName = _getEnv('PROFILE_NAME', 'Jane Smith');
    resumeText = _getEnv('RESUME_TEXT', "An empty resume.");
    resumeUrl = _getEnv('RESUME_URL', 'https://example.com/resume.pdf');
    linkedinUrl = _getEnv('LINKEDIN_URL', 'https://linkedin.com/in/example');
    websiteUrl = _getEnv('WEBSITE_URL', 'https://example.com');
    minSalary = _getEnv('MIN_SALARY', '100000');
    maxSalary = _getEnv('MAX_SALARY', '500000');
    jobLocation = _getEnv('JOB_LOCATION', 'Remote');
    companyType = _getEnv('COMPANY_TYPE', 'Startup');
    serverName = _getEnv('SERVER_NAME', 'me-mcp-server');
    serverVersion = _getEnv('SERVER_VERSION', '1.0.0');
  }

  static final Config instance = Config();
}
