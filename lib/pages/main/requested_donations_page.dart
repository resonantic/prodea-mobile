import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prodea/components/if.dart';
import 'package:prodea/controllers/connection_state_controller.dart';
import 'package:prodea/dialogs/user_info_dialog.dart';
import 'package:prodea/extensions/date_time.dart';
import 'package:prodea/extensions/string.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/models/dtos/donation_dto.dart';
import 'package:prodea/stores/donations_store.dart';
import 'package:prodea/stores/user_infos_store.dart';

class RequestedDonationsPage extends StatefulWidget {
  const RequestedDonationsPage({Key? key}) : super(key: key);

  @override
  State<RequestedDonationsPage> createState() => _RequestedDonationsPageState();
}

class _RequestedDonationsPageState extends State<RequestedDonationsPage> {
  final cityFilterController = TextEditingController();
  final connectionStateController = i<ConnectionStateController>();
  final donationsStore = i<DonationsStore>();
  final userInfosStore = i<UserInfosStore>();

  @override
  void dispose() {
    cityFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: donationsStore.init,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (context) {
            final donations = cityFilterController.text.isNotEmpty
                ? donationsStore.requestedDonations
                    .where((donation) => userInfosStore
                        .getDonorById(donation.donorId!)
                        .city
                        .includes(cityFilterController.text))
                    .toList()
                : donationsStore.requestedDonations;

            if (donationsStore.requestedDonations.isEmpty) {
              return const Text('No momento não há doaçoes solicitadas...');
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildFilterField(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      final donation = donations[index];
                      return _buildDonationCard(donation);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterField() {
    return TextFormField(
      controller: cityFilterController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.filter_alt_rounded),
        suffixIcon: cityFilterController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    cityFilterController.clear();
                  });
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        hintText: 'Filtrar por cidade...',
      ),
    );
  }

  Widget _buildDonationCard(Donation donation) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          If(
            condition: donation.photoUrl != null,
            child: FutureBuilder(
              future: donationsStore.getDonationPhotoURL(donation),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(
                    height: 215,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    height: 215,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(snapshot.data!),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          ListTile(
            title: Text(donation.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (donation.createdAt != null)
                  Text("Data da Doação: ${donation.createdAt!.toDateStr()}"),
                if (!donation.isDelivered)
                  Text("Validade: ${donation.expiration}"),
                if (donation.donorId != null)
                  Observer(
                    builder: (context) {
                      final donor =
                          userInfosStore.getDonorById(donation.donorId!);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Doador: ${donor.name} "),
                              InkWell(
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                ),
                                onTap: () => showUserInfoDialog(
                                  context,
                                  userInfo: donor,
                                ),
                              ),
                            ],
                          ),
                          Text("Cidade: ${donor.city} "),
                        ],
                      );
                    },
                  ),
                Text("Situação: ${donation.status}"),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired)
                  SizedBox(
                    width: double.infinity,
                    child: Observer(
                      builder: (_) => OutlinedButton(
                        onPressed: connectionStateController.isConnected
                            ? () {
                                donationsStore.setDonationAsDelivered(donation);
                              }
                            : null,
                        child: const Text('Marcar como Recebida'),
                      ),
                    ),
                  ),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired)
                  SizedBox(
                    width: double.infinity,
                    child: Observer(
                      builder: (_) => OutlinedButton(
                        onPressed: connectionStateController.isConnected
                            ? () {
                                donationsStore
                                    .setDonationAsUnrequested(donation);
                              }
                            : null,
                        child: const Text('Cancelar Solicitação'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}