# Me MCP Server

A MCP (Machine Chat Protocol) server for learning about and interacting with Jake Gaylor.

## Running the server

### Using Docker

The easiest way to run the server is using Docker Compose:

```bash
docker-compose up -d
```

This will start the server on port 3000.

### Environment Variables

You can customize the server by setting environment variables. See `.env.example` for all available options.

When using Docker Compose, modify the `environment` section in `docker-compose.yml`.

When running locally, you can create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
# Edit .env with your preferred values
```

### Running Locally

To run the server locally:

1. Ensure you have Dart SDK 3.7.2 or later installed
2. Install dependencies: `dart pub get`
3. Run the server: `dart bin/server.dart`

## Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| HOST | Host address to bind to | 0.0.0.0 |
| PORT | Port to listen on | 3000 |
| ENVIRONMENT | Environment (development, production) | development |
| RESUME_URL | URL to the resume | https://jakegaylor.com/JakeGaylor_resume.pdf |
| LINKEDIN_URL | URL to LinkedIn profile | https://linkedin.com/in/jhgaylor |
| WEBSITE_URL | URL to personal website | https://jakegaylor.com |
| RESUME_TEXT | Full text content of the resume | Default resume text in config.dart |
| MIN_SALARY | Minimum salary for job search | 200000 |
| MAX_SALARY | Maximum salary for job search | 300000 |
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
