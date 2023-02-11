import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  /// Extracting variables
  String projectName = context.vars['name'];
  String description = context.vars['description'];
  String org = context.vars['org'];
  bool overwrite = context.vars['overwrite'];

  final progress = context.logger.progress(
    'Running `flutter create` command',
  );

  /// Running `flutter create` command with input parameters using [Process]
  final result = await Process.run(
    'flutter',
    [
      'create',
      projectName.pascalCase,
      '--project-name',
      projectName.snakeCase,
      '--description',
      description,
      '--org',
      org,
      // '--no-pub',
      if (overwrite) '--overwrite' else '--no-overwrite',
      '-e',
    ],
    runInShell: true,
  );

  if (result.exitCode == 0) {
    progress.complete(
        "Structured flutter project $projectName Created Successfully!");
  } else {
    progress.fail(
        'Process failed with exitCode $exitCode and Error: ${result.stderr.toString()}');
  }
}
