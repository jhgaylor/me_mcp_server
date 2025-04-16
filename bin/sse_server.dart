import 'dart:async';
import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:me_mcp_server/me_mcp_server.dart';

Future<void> main() async {
  final config = Config.instance;
  final mcpServer = createMcpServer();

  final sseServerManager = SseServerManager(mcpServer);
  try {
    // Configure HTTP server with parameters for concurrent connections
    final server = await HttpServer.bind(
      config.host == '0.0.0.0'
          ? InternetAddress.anyIPv4
          : InternetAddress(config.host),
      config.port,
      shared: true, // Allow multiple isolates to share this server
    );
    
    print('Server listening on http://${config.host}:${config.port}');

    // Handle requests without awaiting to allow multiple concurrent connections
    server.listen(
      (HttpRequest request) {
        // Process each request in its own zone to isolate errors
        runZonedGuarded(
          () {
            // Process request without awaiting to allow concurrent handling
            sseServerManager.handleRequest(request).catchError((error) {
              print('Error in handleRequest: $error');
              _tryCloseWithError(request);
            });
          },
          (error, stackTrace) {
            print('Error handling request: $error');
            print(stackTrace);
            _tryCloseWithError(request);
          },
        );
      },
      onError: (error) {
        print('Server listen error: $error');
      },
    );
    
    // Keep the server running indefinitely
    print('Server is now ready for multiple concurrent connections');
    
  } catch (e) {
    print('Error starting server: $e');
    exitCode = 1;
  }
}

/// Try to send an error response if possible
void _tryCloseWithError(HttpRequest request) {
  try {
    // Check if the response hasn't been sent yet
    if (request.response.connectionInfo != null) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Internal Server Error');
        
      request.response.close().catchError((e) {
        print('Error closing response: $e');
      });
    }
  } catch (e) {
    print('Error while sending error response: $e');
  }
}
