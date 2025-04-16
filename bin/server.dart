import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<void> main() async {
  final config = Config.instance;
  
  final mcpServer = McpServer(
    Implementation(name: config.serverName, version: config.serverVersion),
    options: ServerOptions(capabilities: ServerCapabilities()),
  );

  mcpServer.prompt(
    "JobSearch",
    description: "Make instructions for a job search that this candidate will excel at",
    callback: (args, extra) async {
      return GetPromptResult(
        messages: [
          PromptMessage(
            role: PromptMessageRole.user,
            content: TextContent(
              text:
                  'Search for jobs that the candidate will excel at, with a minimum salary of ${config.minSalary} and a maximum salary of ${config.maxSalary}, in the location of ${config.jobLocation}, and the company type of ${config.companyType}.',
            ),
          ),
        ],
      );
    },
  );

  // Resume Text resource
  mcpServer.resource("${config.profileName} Resume Text", "candidate-info://resume", (uri, extra) async {
    return ReadResourceResult(
      contents: [
        TextResourceContents(
          uri: "candidate-info://resume",
          mimeType: "text/plain",
          text: config.resumeText,
        ),
      ],
    );
  });

  // Resume url resource
  mcpServer.resource("${config.profileName} Resume URL", "candidate-info://resume-url", (uri, extra) async {
    return ReadResourceResult(
      contents: [
        TextResourceContents(uri: "candidate-info://resume-url", mimeType: "text/plain", text: config.resumeUrl),
      ],
    );
  });

  // LinkedIn profile resource
  mcpServer.resource("${config.profileName} LinkedIn Profile URL", "candidate-info://linkedin-url", (uri, extra) async {
    stderr.writeln("LinkedIn resource requested");
    return ReadResourceResult(
      contents: [
        TextResourceContents(
          uri: "linkedin-url",
          mimeType: "text/plain",
          text: config.linkedinUrl,
        ),
      ],
    );
  });

  // Website url resource
  mcpServer.resource("${config.profileName} Website URL", "candidate-info://website-url", (uri, extra) async {
    return ReadResourceResult(
      contents: [
        TextResourceContents(uri: "candidate-info://website-url", mimeType: "text/plain", text: config.websiteUrl),
      ],
    );
  });

  // Website resource
  mcpServer.resource("${config.profileName} Website Contents", "candidate-info://website-contents", (uri, extra) async {
    final response = await http.get(Uri.parse(config.websiteUrl));
    if (response.statusCode == 200) {
      return ReadResourceResult(
        contents: [
          TextResourceContents(
            uri: "candidate-info://website-contents",
            mimeType: "text/html",
            text: response.body,
            additionalProperties: {
              'type': 'html',
              'url': config.websiteUrl,
            },
          ),
        ],
      );
    }
    throw Exception('Failed to fetch website content');
  });

  final sseServerManager = SseServerManager(mcpServer);
  try {
    final server = await HttpServer.bind(config.host == '0.0.0.0' ? InternetAddress.anyIPv4 : InternetAddress(config.host), config.port);
    print('Server listening on http://${config.host}:${config.port}');

    await for (final request in server) {
      sseServerManager.handleRequest(request);
    }
  } catch (e) {
    print('Error starting server: $e');
    exitCode = 1;
  }
}