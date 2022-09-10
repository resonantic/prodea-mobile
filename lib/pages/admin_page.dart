import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prodea/controllers/connection_state_controller.dart';
import 'package:prodea/dialogs/no_connection_dialog.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/stores/user_infos_store.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final connectionStateController = i<ConnectionStateController>();
  final userInfosStore = i<UserInfosStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor:
              !connectionStateController.isConnected ? Colors.redAccent : null,
          title: Row(
            children: const [
              Icon(Icons.admin_panel_settings_rounded),
              SizedBox(width: 12),
              Text('Administração'),
            ],
          ),
          actions: [
            if (!connectionStateController.isConnected)
              IconButton(
                onPressed: () => showNoConnectionDialog(context),
                icon: const Icon(Icons.wifi_off_rounded),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Observer(
            builder: (context) {
              final userInfos = userInfosStore.users;

              if (userInfos.isEmpty) {
                return const Text(
                  'Infelizmente não há usuários cadastrados...',
                );
              }

              return ListView.builder(
                itemCount: userInfos.length,
                itemBuilder: (context, index) {
                  final userInfo = userInfos[index];
                  return _buildUserInfoCard(userInfo);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(UserInfo userInfo) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userInfo.name),
            Text("CNPJ: ${userInfo.cnpj}"),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Endereço: ${userInfo.address}"),
            Text("Cidade: ${userInfo.city}"),
            Text("Email: ${userInfo.email}"),
            Text("Telefone: ${userInfo.phoneNumber}"),
            Text("Nome do Responsável: ${userInfo.responsibleName}"),
            Text("CPF do Responsável: ${userInfo.responsibleCpf}"),
            Text("Sobre: ${userInfo.about}"),
            if (userInfo.isDonor && userInfo.isBeneficiary)
              const Text('Perfil: Doador(a) e Beneficiário(a)'),
            if (userInfo.isDonor && !userInfo.isBeneficiary)
              const Text('Perfil: Doador(a)'),
            if (!userInfo.isDonor && userInfo.isBeneficiary)
              const Text('Perfil: Beneficiário(a)'),
            if (userInfo.status == AuthorizationStatus.waiting)
              const Text('Situação: Aguardando Verificação'),
            if (userInfo.status == AuthorizationStatus.authorized)
              const Text('Situação: Autorizado'),
            if (userInfo.status == AuthorizationStatus.denied)
              const Text('Situação: Não Autorizado'),
            const SizedBox(height: 8),
            if (userInfo.status == AuthorizationStatus.waiting ||
                userInfo.status == AuthorizationStatus.denied)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: connectionStateController.isConnected
                      ? () {
                          userInfosStore.setUserAsAuthorized(userInfo);
                        }
                      : null,
                  child: const Text('Autorizar'),
                ),
              ),
            if (userInfo.status == AuthorizationStatus.waiting ||
                userInfo.status == AuthorizationStatus.authorized)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: connectionStateController.isConnected
                      ? () {
                          userInfosStore.setUserAsDenied(userInfo);
                        }
                      : null,
                  child: const Text('Negar Autorização'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
