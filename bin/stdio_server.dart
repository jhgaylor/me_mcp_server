import 'package:mcp_dart/mcp_dart.dart';
import 'package:me_mcp_server/me_mcp_server.dart';

void main(List<String> args) async {
  final mcpServer = await createMcpServer();
  mcpServer.connect(StdioServerTransport());
}
