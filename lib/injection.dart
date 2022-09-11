import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/controllers/connection_state_controller.dart';
import 'package:prodea/repositories/contracts/auth_repo.dart';
import 'package:prodea/repositories/contracts/city_repo.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/repositories/firebase_auth_repo.dart';
import 'package:prodea/repositories/firebase_donation_repo.dart';
import 'package:prodea/repositories/firebase_user_info_repo.dart';
import 'package:prodea/repositories/local_city_repo.dart';
import 'package:prodea/routes.dart';
import 'package:prodea/services/asuka_notification_service.dart';
import 'package:prodea/services/connectivity_connection_service.dart';
import 'package:prodea/services/contracts/connection_service.dart';
import 'package:prodea/services/contracts/navigation_service.dart';
import 'package:prodea/services/contracts/notification_service.dart';
import 'package:prodea/services/contracts/photo_service.dart';
import 'package:prodea/services/image_picker_photo_service.dart';
import 'package:prodea/services/seafarer_navigation_service.dart';
import 'package:prodea/stores/cities_store.dart';
import 'package:prodea/stores/donation_store.dart';
import 'package:prodea/stores/donations_store.dart';
import 'package:prodea/stores/user_info_store.dart';
import 'package:prodea/stores/user_infos_store.dart';
import 'package:seafarer/seafarer.dart';

final i = GetIt.instance;

Future<void> setupInjection() async {
  // Firebase
  i.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  i.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  i.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  i.registerLazySingleton<Connectivity>(() => Connectivity());
  i.registerLazySingleton<ImagePicker>(() => ImagePicker());
  i.registerLazySingleton<Seafarer>(() => Routes.seafarer);

  // Services
  i.registerFactory<INotificationService>(
    () => AsukaNotificationService(),
  );
  i.registerFactory<INavigationService>(
    () => SeafarerNavigationService(i()),
  );
  i.registerFactory<IPhotoService>(
    () => ImagePickerPhotoService(i()),
  );
  i.registerFactory<IConnectionService>(
    () => ConnectivityConnectionService(i()),
  );

  // Repos
  i.registerFactory<IAuthRepo>(
    () => FirebaseAuthRepo(i(), i(), i()),
  );
  i.registerFactory<IDonationRepo>(
    () => FirebaseDonationRepo(i(), i(), i(), i()),
  );
  i.registerFactory<IUserInfoRepo>(
    () => FirebaseUserInfoRepo(i(), i(), i()),
  );
  i.registerFactory<ICityRepo>(
    () => LocalCityRepo(),
  );

  // Controllers
  i.registerSingleton<AuthController>(AuthController(i(), i(), i()));
  i.registerSingleton<ConnectionStateController>(
    ConnectionStateController(i(), i()),
  );

  // Stores
  i.registerSingleton<DonationsStore>(DonationsStore(i()));
  i.registerSingleton<UserInfosStore>(UserInfosStore(i()));
  i.registerSingleton<CitiesStore>(CitiesStore(i()));
  i.registerFactory<DonationStore>(
    () => DonationStore(i(), i(), i()),
  );
  i.registerFactory<UserInfoStore>(
    () => UserInfoStore(),
  );
}
