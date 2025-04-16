import 'package:mcp_dart/mcp_dart.dart';
import 'package:me_mcp_server/me_mcp_server.dart';

void main() async {
  final mcpServer = createMcpServer();
  mcpServer.connect(StdioServerTransport());
}
