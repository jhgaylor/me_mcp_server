import 'dart:io';
import 'me_config.dart';

class Config {
  // Server configuration
  late final String host;
  late final int port;
  late final String environment;

  // Candidate info
  late final MeConfig me;

  // Server info
  late final String serverName;
  late final String serverVersion;

  bool _initialized = false;

  Config();

  // Get environment variable with fallback
  static String _getEnvVar(String name, String defaultValue) {
    return Platform.environment[name] ?? defaultValue;
  }

  Future<void> loadConfig() async {
    if (_initialized) return;

    final configPath = _getEnvVar('ME_CFG_PATH', 'me.yaml');
    
    stderr.writeln('Loading configuration from $configPath');
    stderr.writeln('Current working directory: ${Directory.current.path}');
    
    // Parse the structured configuration
    me = await MeConfig.fromYamlFile(configPath);
    
    // Server configuration - from environment variables
    host = _getEnvVar('HOST', '0.0.0.0');
    port = int.tryParse(_getEnvVar('PORT', '3000')) ?? 3000;
    environment = _getEnvVar('ENVIRONMENT', 'development');
    serverName = 'me-mcp-server';
    serverVersion = '1.0.0';
    
    _initialized = true;
  }

  // Static instance
  static final Config _instance = Config();
  
  // Getter for the instance that ensures config is loaded
  static Future<Config> getInstance() async {
    await _instance.loadConfig();
    return _instance;
  }
}
