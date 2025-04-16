# Use latest stable channel SDK.
FROM dart:3.7.2

WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN dart pub get

# Copy the rest of the application
COPY . .

# Ensure the application has all dependencies
RUN dart pub get --offline

# Default environment variables (these will be used if not provided at runtime or in .env)
ENV HOST=0.0.0.0
ENV PORT=3000
ENV ENVIRONMENT=production
ENV RESUME_URL=https://jakegaylor.com/JakeGaylor_resume.pdf
ENV LINKEDIN_URL=https://linkedin.com/in/jhgaylor
ENV WEBSITE_URL=https://jakegaylor.com
ENV MIN_SALARY=200000
ENV MAX_SALARY=300000
ENV JOB_LOCATION=Remote
ENV COMPANY_TYPE=Startup
ENV SERVER_NAME=me-mcp-server
ENV SERVER_VERSION=1.0.0
# Resume text is defined in the config.dart file and can be overridden here if needed
# ENV RESUME_TEXT="Custom resume text"

# Start the server
CMD ["dart", "bin/server.dart"]

# Document that the container listens on port 3000
EXPOSE 3000
