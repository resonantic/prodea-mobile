import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/dialogs/user_info_dialog.dart';
import 'package:prodea/extensions/date_time.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/models/dtos/donation_dto.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/stores/beneficiaries_store.dart';
import 'package:prodea/stores/my_donations_store.dart';

class MyDonationsPage extends StatefulWidget {
  const MyDonationsPage({Key? key}) : super(key: key);

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  final myDonationsStore = i<MyDonationsStore>();
  final beneficiariesStore = i<BeneficiariesStore>();

  @override
  void initState() {
    super.initState();
    myDonationsStore.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: myDonationsStore.fetchData,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ScopedBuilder(
          store: myDonationsStore,
          onLoading: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          onState: (context, List<Donation> state) {
            if (state.isEmpty) {
              return const Text('No momento não há doaçoes efetuadas...');
            }

            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                final donation = state[index];
                return _buildDonationCard(donation);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonationCard(Donation donation) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          FutureBuilder(
            future: myDonationsStore.getDonationPhotoURL(donation),
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
          ListTile(
            title: Text(donation.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (donation.createdAt != null)
                  Text("Data da Doação: ${donation.createdAt!.toDateStr()}"),
                if (!donation.isDelivered)
                  Text("Validade: ${donation.expiration}"),
                if (donation.beneficiaryId != null)
                  ScopedBuilder(
                    store: beneficiariesStore,
                    onState: (context, List<UserInfo> state) {
                      final beneficiary = beneficiariesStore
                          .getBeneficiaryById(donation.beneficiaryId!);

                      return Row(
                        children: [
                          Text("Destino: ${beneficiary.name} "),
                          InkWell(
                            child: const Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                            ),
                            onTap: () => showUserInfoDialog(
                              context,
                              userInfo: beneficiary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                Text("Situação: ${donation.status}"),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired &&
                    donation.beneficiaryId != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO
                      },
                      child: const Text('Marcar como Entregue'),
                    ),
                  ),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO
                      },
                      child: const Text('Cancelar Doação'),
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
