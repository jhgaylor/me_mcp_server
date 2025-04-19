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

# Start the server
CMD ["dart", "bin/streamable_http_server.dart"]

# Document that the container listens on port 3000
EXPOSE 3000
