import 'dart:io';
import 'package:me_mcp_server/me_mcp_server.dart';

/// CLI utility to create a default me.yaml configuration file
Future<void> main(List<String> args) async {
  final path = args.isNotEmpty ? args[0] : 'me.yaml';
  
  print('Initializing Me MCP Server configuration...');
  print('Configuration file will be created at: $path');
  
  try {
    await MeConfig.createDefaultConfig(path);
    print('Configuration initialized successfully!');
    print('You can now edit $path with your personal information.');
  } catch (e) {
    stderr.writeln('Error initializing configuration: $e');
    exitCode = 1;
  }
} 