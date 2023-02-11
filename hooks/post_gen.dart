import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  var progress = context.logger.progress('Running l10n auto generation');

  /// flutter gen-l10n --template-arb-file intl_en.arb --output-dir "lib/generated" --output-class 'S' --no-synthetic-package
  var result = await Process.run(
    'flutter',
    [
      'gen-l10n',
      '--template-arb-file',
      'intl_en.arb',
      '--output-dir',
      'lib/generated',
      '--output-class',
      'S',
      '--no-synthetic-package'
    ],
    runInShell: true,
  );

  if (result.exitCode == 0) {
    progress.complete('Generated l10n files.');
  } else {
    progress.fail(
        'Could not generate l10n files. you can run this command by yourself :\nflutter gen-l10n --template-arb-file intl_en.arb --output-dir "lib/generated" --output-class "S" --no-synthetic-package');
  }

  progress = context.logger
      .progress('Running build_runner for auto_route and such packages');

  /// flutter pub run build_runner build --delete-conflicting-outputs
  result = await Process.run(
    'flutter',
    [
      'pub',
      'run',
      'intl_en.arb',
      'build_runner',
      'build',
      '--delete-conflicting-outputs'
    ],
    runInShell: true,
  );

  if (result.exitCode == 0) {
    progress.complete('Successfully built routes.gr.dart');
  } else {
    progress.fail(
        'Could not generate routes.gr.dart. you can run this command by yourself :\nflutter pub run build_runner build --delete-conflicting-outputs');
  }
}
