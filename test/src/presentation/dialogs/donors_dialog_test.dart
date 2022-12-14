import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/presentation/dialogs/donors_dialog.dart';
import 'package:prodea/src/presentation/stores/users_store.dart';
import 'package:mobx/mobx.dart' as mobx;

import '../../../mocks/mocks.dart';
import '../../../mocks/widgets.dart';

void main() {
  const tScaffoldKey = Key('scaffold');
  late UsersStore usersStoreMock;

  const tUser = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'Tester',
    address: 'Rua Teste',
    city: 'Cidade Teste/TESTE',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: true,
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );

  setUp(() {
    usersStoreMock = MockUsersStore();

    when(() => usersStoreMock.donors)
        .thenReturn(mobx.ObservableList.of([tUser]));

    setupTestInjector((i) {
      i.unregister<UsersStore>();
      i.registerInstance<UsersStore>(usersStoreMock);
    });
  });

  testWidgets(
    'deve mostrar um diálogo e fechar ao clicar no botão de voltar.',
    (tester) async {
      // arrange
      Finder widget;
      await tester.pumpWidget(makeDialogTestable(tScaffoldKey));
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showDonorsDialog(context);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining(tUser.name), findsOneWidget);
      expect(find.textContaining(tUser.address), findsOneWidget);
      expect(find.textContaining(tUser.city), findsOneWidget);

      // voltar
      widget = find.byType(TextButton).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
