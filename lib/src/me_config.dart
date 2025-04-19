import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:mustache_template/mustache_template.dart';

/// Configuration structure for me.yaml
class MeConfig {
  /// Personal information
  final String name;
  final String? resumeUrl;
  final String? websiteUrl;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? resumeText;
  final String? websiteText;
  
  /// Job search preferences
  final JobSearchConfig? jobSearch;
  
  MeConfig({
    required this.name,
    this.resumeUrl,
    this.websiteUrl,
    this.linkedinUrl,
    this.githubUrl,
    this.resumeText,
    this.websiteText,
    this.jobSearch,
  });
  
  /// Create MeConfig from parsed YAML map
  factory MeConfig.fromMap(Map<String, dynamic> map) {
    return MeConfig(
      name: map['name'] as String? ?? 'Jane Smith',
      resumeUrl: map['resume_url'] as String?,
      websiteUrl: map['website_url'] as String?,
      linkedinUrl: map['linkedin_url'] as String?,
      githubUrl: map['github_url'] as String?,
      resumeText: map['resume_text'] as String?,
      websiteText: map['website_text'] as String?,
      jobSearch: map['job_search'] != null 
          ? JobSearchConfig.fromMap(map['job_search'] as Map<String, dynamic>) 
          : null,
    );
  }
  
  /// Render a template string using this config as context
  String renderTemplate(String template) {
    final renderer = Template(template, lenient: true);
    return renderer.renderString(toMap());
  }
  
  /// Get rendered job search prompt
  String getJobSearchPrompt() {
    if (jobSearch?.prompt != null && jobSearch!.prompt!.isNotEmpty) {
      return renderTemplate(jobSearch!.prompt!);
    } else {
      const defaultTemplate = 'Search for jobs that {{name}} will excel at.'
          '{{#job_search.min_salary}} Minimum salary: {{job_search.min_salary}}.{{/job_search.min_salary}}'
          '{{#job_search.max_salary}} Maximum salary: {{job_search.max_salary}}.{{/job_search.max_salary}}'
          '{{#job_search.location}} Location: {{job_search.location}}.{{/job_search.location}}'
          '{{#job_search.company_type}} Company type: {{job_search.company_type}}.{{/job_search.company_type}}'
          '{{#job_search.industry}} Industry: {{job_search.industry}}.{{/job_search.industry}}'
          '{{#job_search.description}} Additional details: {{job_search.description}}.{{/job_search.description}}';
      
      return renderTemplate(defaultTemplate);
    }
  }
  
  /// Load MeConfig from a YAML file
  static Future<MeConfig> fromYamlFile(String path) async {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        stderr.writeln('No me.yaml file found at $path, using default values');
        return MeConfig(name: 'Jane Smith');
      }
      
      final yamlString = await file.readAsString();
      return fromYamlString(yamlString);
    } catch (e) {
      stderr.writeln('Error loading YAML config: $e');
      return MeConfig(name: 'Jane Smith');
    }
  }
  
  /// Load MeConfig from a YAML string
  static MeConfig fromYamlString(String yamlString) {
    final yamlMap = loadYaml(yamlString) as Map;
    final map = _convertYamlToMap(yamlMap);
    return MeConfig.fromMap(map);
  }
  
  /// Create a default configuration file at the specified path
  static Future<void> createDefaultConfig(String path) async {
    final file = File(path);
    
    // Don't overwrite existing file
    if (file.existsSync()) {
      stderr.writeln('Configuration file already exists at $path');
      return;
    }
    
    // Create a default configuration
    final defaultConfig = MeConfig(
      name: 'Jane Smith',
      resumeUrl: 'https://example.com/resume.pdf',
      websiteUrl: 'https://example.com',
      linkedinUrl: 'https://linkedin.com/in/example',
      githubUrl: 'https://github.com/example',
      resumeText: '''Jane Smith
Software Engineer

Experience:
- Example Company (2020-Present)
  Senior Software Engineer

Skills:
- Programming Languages: Dart, JavaScript, TypeScript
- Technologies: Flutter, React, Node.js
''',
      jobSearch: JobSearchConfig(
        minSalary: 100000,
        maxSalary: 200000,
        location: 'Remote',
        companyType: 'Startup',
        industry: 'Technology',
        description: 'Looking for senior engineering roles',
        prompt: '''Search for jobs that {{name}} will excel at.

Requirements:
- Salary range: {{job_search.min_salary}} to {{job_search.max_salary}}
- Location: {{job_search.location}}
- Company type: {{job_search.company_type}}
- Industry: {{job_search.industry}}

Additional details:
{{job_search.description}}''',
      ),
    );
    
    // Write to file
    await defaultConfig.writeToFile(path);
    
    stderr.writeln('Created default configuration at $path');
  }
  
  // Helper function to convert YamlMap to regular Map
  static Map<String, dynamic> _convertYamlToMap(Map yamlMap) {
    final result = <String, dynamic>{};
    
    for (final key in yamlMap.keys) {
      final value = yamlMap[key];
      
      if (value is Map) {
        // Recursively convert nested maps
        result[key.toString()] = _convertYamlToMap(value);
      } else if (value is List) {
        // Convert lists and their potential map elements
        result[key.toString()] = value.map((item) {
          if (item is Map) {
            return _convertYamlToMap(item);
          }
          return item;
        }).toList();
      } else {
        // Regular value
        result[key.toString()] = value;
      }
    }
    
    return result;
  }
  
  /// Create a map representation of this config
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (resumeUrl != null) 'resume_url': resumeUrl,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (linkedinUrl != null) 'linkedin_url': linkedinUrl,
      if (githubUrl != null) 'github_url': githubUrl,
      if (resumeText != null) 'resume_text': resumeText,
      if (websiteText != null) 'website_text': websiteText,
      if (jobSearch != null) 'job_search': jobSearch!.toMap(),
    };
  }
  
  /// Convert to YAML string
  String toYaml() {
    final buffer = StringBuffer();
    _writeMapToYaml(toMap(), buffer);
    return buffer.toString();
  }
  
  /// Write config to YAML file
  Future<void> writeToFile(String path) async {
    final file = File(path);
    await file.writeAsString('# Me MCP Server Configuration\n\n${toYaml()}');
  }
  
  // Helper method to convert map to YAML format
  static void _writeMapToYaml(Map<String, dynamic> map, StringBuffer buffer, {int indent = 0}) {
    final indentStr = ' ' * indent;
    
    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        buffer.writeln('$indentStr$key:');
        _writeMapToYaml(value, buffer, indent: indent + 2);
      } else if (value is List) {
        buffer.writeln('$indentStr$key:');
        for (final item in value) {
          buffer.writeln('$indentStr- $item');
        }
      } else if (value is String && value.contains('\n')) {
        // Multi-line string
        buffer.writeln('$indentStr$key: |');
        for (final line in value.split('\n')) {
          buffer.writeln('$indentStr  $line');
        }
      } else {
        buffer.writeln('$indentStr$key: $value');
      }
    });
  }
}

/// Configuration for job search preferences
class JobSearchConfig {
  final String? description;
  final num? minSalary;
  final num? maxSalary;
  final String? location;
  final String? companySize;
  final String? industry;
  final String? companyType;
  final String? prompt;

  JobSearchConfig({
    this.description,
    this.minSalary,
    this.maxSalary,
    this.location,
    this.companySize,
    this.industry,
    this.companyType,
    this.prompt,
  });

  /// Create JobSearchConfig from parsed YAML map
  factory JobSearchConfig.fromMap(Map<String, dynamic> map) {
    return JobSearchConfig(
      description: map['description'] as String?,
      minSalary: map['min_salary'] as num?,
      maxSalary: map['max_salary'] as num?,
      location: map['location'] as String?,
      companySize: map['company_size'] as String?,
      industry: map['industry'] as String?,
      companyType: map['company_type'] as String?,
      prompt: map['prompt'] as String?,
    );
  }

  /// Create a map representation of this config
  Map<String, dynamic> toMap() {
    return {
      if (description != null) 'description': description,
      if (minSalary != null) 'min_salary': minSalary,
      if (maxSalary != null) 'max_salary': maxSalary,
      if (location != null) 'location': location,
      if (companySize != null) 'company_size': companySize,
      if (industry != null) 'industry': industry,
      if (companyType != null) 'company_type': companyType,
      if (prompt != null) 'prompt': prompt,
    };
  }
} 