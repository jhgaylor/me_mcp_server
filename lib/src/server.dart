import 'package:mcp_dart/mcp_dart.dart';
import 'config.dart';

/// Creates and configures the MCP server with all resources
Future<McpServer> createMcpServer([String? configFilePath]) async {
  final config = Config(configFilePath);
  await config.loadConfig();

  final mcpServer = McpServer(
    Implementation(name: config.serverName, version: config.serverVersion),
    options: ServerOptions(capabilities: ServerCapabilities()),
  );

  // TODO: once this is all wrapped up, make an mcp server that "deploys" a me-mcp by rendering an mcp.yaml file.
  // TODO: -> then make a tool that takes an mcp.yaml file and runs it it in fly.io using flycd. profit.
  mcpServer.prompt(
    "Job Search for ${config.me.name}",
    description:
        "Make instructions for a job search that this candidate will excel at",
    callback: (args, extra) async {
      // Use the template from config
      final promptText = config.me.getJobSearchPrompt();
      return GetPromptResult(
        messages: [
          PromptMessage(
            role: PromptMessageRole.user,
            content: TextContent(
              text: promptText,
            ),
          ),
        ],
      );
    },
  );

  // Resume Text resource
  if (config.me.resumeText != null) {
    mcpServer.resource(
      "${config.me.name} Resume Text",
      "candidate-info://resume-text",
      (uri, extra) async {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: "candidate-info://resume-text",
              mimeType: "text/plain",
              text: config.me.resumeText!,
            ),
          ],
        );
      },
    );
  }

  // Resume url resource
  if (config.me.resumeUrl != null) {
    mcpServer.resource(
      "${config.me.name} Resume URL",
      "candidate-info://resume-url",
      (uri, extra) async {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: "candidate-info://resume-url",
              mimeType: "text/plain",
              text: config.me.resumeUrl!,
            ),
          ],
        );
      },
    );
  }

  // LinkedIn profile resource
  if (config.me.linkedinUrl != null) {
    mcpServer.resource(
      "${config.me.name} LinkedIn Profile URL",
      "candidate-info://linkedin-url",
      (uri, extra) async {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: "linkedin-url",
              mimeType: "text/plain",
              text: config.me.linkedinUrl!,
            ),
          ],
        );
      },
    );
  }

  // GitHub profile resource
  if (config.me.githubUrl != null) {
    mcpServer.resource(
      "${config.me.name} GitHub Profile URL",
      "candidate-info://github-url",
      (uri, extra) async {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: "github-url",
              mimeType: "text/plain",
              text: config.me.githubUrl!,
            ),
          ],
        );
      },
    );
  }

  // Website url resource
  if (config.me.websiteUrl != null) {
    mcpServer.resource(
      "${config.me.name} Website URL",
      "candidate-info://website-url",
      (uri, extra) async {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: "candidate-info://website-url",
              mimeType: "text/plain",
              text: config.me.websiteUrl!,
            ),
          ],
        );
      },
    );
  }

  // Website resource
  if (config.me.websiteText != null) {
    mcpServer.resource(
      "${config.me.name} Website Text",
      "candidate-info://website-text",
      (uri, extra) async {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: "candidate-info://website-text",
              mimeType: "text/plain",
              text: config.me.websiteText!,
            ),
          ],
        );
      },
    );
  }

  return mcpServer;
}
