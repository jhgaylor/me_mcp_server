import 'package:mcp_dart/mcp_dart.dart';
import 'package:me_mcp_server/me_mcp_server.dart';

void main(List<String> args) async {
  final configPath = args.isNotEmpty ? args[0] : 'me.yaml';
  final mcpServer = await createMcpServer(configPath);
  mcpServer.connect(StdioServerTransport());
}
