import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:todos/presentation/constants/keys.dart';

void main() {
  group('Todos App', () {
    final branchCardFinder = find.byType('BranchCard');
    final todoCardFinder = find.byType('TodoCard');
    final addBranchButtonFinder = find.byType('RaisedButton');
    final addTodoButtonFinder = find.byType('FloatingActionButton');
    final acceptButtonFinder = find.byValueKey(Keys.acceptButton);
    final textFormFieldFinder = find.byType('TextFormField');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('создает ветку и задачу и переходит между экранами', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(addBranchButtonFinder);
        await driver.tap(textFormFieldFinder);
        await driver.enterText('Branch Title');
        await driver.tap(acceptButtonFinder);
        await driver.tap(branchCardFinder);
      });

      await driver.tap(addTodoButtonFinder);
      await driver.tap(textFormFieldFinder);
      await driver.enterText('Todo Title');
      await driver.tap(acceptButtonFinder);
      await driver.tap(todoCardFinder);

      await driver.waitFor(find.text('Todo Title'));
    });
  });
}
