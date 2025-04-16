# Me MCP Server

A MCP (Model Context Protocol) server for learning about and interacting with YOU.

## Features

This MCP server provides the following capabilities:

### Prompts
- **JobSearch** - Generate job search instructions tailored to your profile with specified salary range, location, and company type preferences.

### Resources
- **Resume Text** - Access your full resume text (`candidate-info://resume`)
- **Resume URL** - Get the URL to your resume PDF (`candidate-info://resume-url`)
- **LinkedIn Profile URL** - Access your LinkedIn profile (`candidate-info://linkedin-url`)
- **Website URL** - Get your personal website URL (`candidate-info://website-url`)
- **Website Contents** - Fetch and analyze the HTML contents of your website (`candidate-info://website-contents`)

## Running the server

### Using Docker

The easiest way to run the server is using Docker Compose:

```bash
docker-compose up -d
```

This will start the server on port 3000.

## Transport Options

This MCP server supports two different transport mechanisms:

### SSE (Server-Sent Events) Transport

The SSE transport allows the server to communicate over HTTP with clients that support server-sent events. This is useful for web-based clients or any client that can establish an HTTP connection.

To run the server with SSE transport:

```bash
dart bin/sse_server.dart
```

The SSE server will start on the configured host and port (default: 0.0.0.0:3000).

### Stdio Transport

The Stdio transport uses standard input/output streams for communication. This is ideal for integration with desktop clients like Claude Desktop that launch the MCP server as a subprocess.

To run the server with Stdio transport:

```bash
dart bin/stdio_server.dart
```

#### Configuring Claude Desktop

To use the MCP server with Claude Desktop, add the following to your Claude configuration:

```json
{
  "mcpServers": {
    "me_mcp": {
      "command": "dart",
      "args": [
        "path/to/bin/stdio_server.dart"
      ]
    }
  }
}
```

Alternatively, you can compile the server to a standalone executable:

```bash
dart compile exe bin/stdio_server.dart -o ./mcp_server
```

And then configure Claude Desktop to use the compiled version:

```json
{
  "mcpServers": {
    "me_mcp": {
      "command": "path/to/mcp_server"
    }
  }
}
```

### Environment Variables

You can customize the server by setting environment variables in several ways:

1. **Using a .env file** (recommended for local development):
   ```bash
   cp .env.example .env
   # Edit .env with your preferred values
   ```
   The server automatically loads the .env file when it starts.

2. **Using Docker Compose**:
   Modify the `environment` section in `docker-compose.yml`.

3. **Using system environment variables**:
   Set environment variables directly in your shell or deployment platform.

The application uses the following precedence for environment variables:
1. Directly passed values (when instantiating Config manually)
2. Values from .env file
3. System environment variables (automatically included)
4. Default values

### Running Locally

To run the server locally:

1. Ensure you have Dart SDK 3.7.2 or later installed
2. Install dependencies: `dart pub get`
3. Set up your configuration (optional):
   ```bash
   cp .env.example .env
   # Edit .env with your preferred values
   ```
4. Run the server with your preferred transport: 
   - SSE: `dart bin/sse_server.dart`
   - Stdio: `dart bin/stdio_server.dart`

## Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| HOST | Host address to bind to | 0.0.0.0 |
| PORT | Port to listen on | 3000 |
| ENVIRONMENT | Environment (development, production) | development |
| PROFILE_NAME | Your profile/candidate name | Jane Smith |
| ENV_VAR_FILE_PATH | Custom path to .env file | .env |
| RESUME_URL | URL to the resume | https://example.com/resume.pdf |
| LINKEDIN_URL | URL to LinkedIn profile | https://linkedin.com/in/example |
| WEBSITE_URL | URL to personal website | https://example.com |
| RESUME_TEXT | Full text content of the resume | Default resume text in config.dart |
| MIN_SALARY | Minimum salary for job search | 100000 |
| MAX_SALARY | Maximum salary for job search | 500000 |
| JOB_LOCATION | Preferred job location | Remote |
| COMPANY_TYPE | Preferred company type | Startup |
| SERVER_NAME | Name of the MCP server | me-mcp-server |
| SERVER_VERSION | Version of the MCP server | 1.0.0 |

## Development

### Building the Docker Image

```bash
docker build -t jhgaylor/me-mcp-server:local .
```

### Running the Docker Image

```bash
docker run -p 3000:3000 -e PORT=3000 jhgaylor/me-mcp-server:local
```

## Docker and Environment Variables

When using Docker, you have several options for configuring environment variables:

1. **Using docker-compose.yml**:
   ```yaml
   environment:
     - VARIABLE_NAME=value
   ```

2. **Using an env_file in docker-compose.yml**:
   ```yaml
   env_file:
     - .env
   ```

3. **Using -e when running with docker run**:
   ```bash
   docker run -p 3000:3000 -e MIN_SALARY=250000 -e MAX_SALARY=350000 jhgaylor/me-mcp-server:main
   ```

4. **Using --env-file with docker run**:
   ```bash
   docker run -p 3000:3000 --env-file .env jhgaylor/me-mcp-server:main
   ```
