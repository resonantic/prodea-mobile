// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/helpers/navigation.dart';
import '../../domain/usecases/auth/get_current_user.dart';

part 'main_page_controller.g.dart';

class MainPageController = _MainPageControllerBase with _$MainPageController;

abstract class _MainPageControllerBase with Store {
  final GetCurrentUser _getCurrentUser;
  final List<StreamSubscription> _subscriptions = [];
  final _pageInfos = [
    PageInfo(
      route: '/main/donate',
      icon: Icons.volunteer_activism_rounded,
      title: 'Doar',
      abbrTitle: 'Doar',
    ),
    PageInfo(
      route: '/main/my-donations',
      icon: Icons.thumb_up_alt_rounded,
      title: 'Minhas Doações',
      abbrTitle: 'Minhas Doações',
    ),
    PageInfo(
      route: '/main/available-donations',
      icon: Icons.local_mall_rounded,
      title: 'Doações Disponíveis',
      abbrTitle: 'Disponíveis',
    ),
    PageInfo(
      route: '/main/requested-donations',
      icon: Icons.handshake_rounded,
      title: 'Doações Solicitadas',
      abbrTitle: 'Solicitadas',
    ),
  ];

  _MainPageControllerBase(this._getCurrentUser) {
    init();
  }

  @observable
  ObservableStream<String> _currentRoute =
      NavigationHelper.currentRoute.asObservable();

  @observable
  ObservableList<PageInfo> pageInfos = ObservableList.of([]);

  @computed
  int get currentPageIndex {
    final pageIndex =
        pageInfos.indexWhere((page) => page.route == _currentRoute.value);
    return pageIndex >= 0 ? pageIndex : 0;
  }

  @computed
  PageInfo? get currentPageInfo {
    if (pageInfos.isEmpty) return null;
    return pageInfos[currentPageIndex];
  }

  @action
  void init() {
    _currentRoute = NavigationHelper.currentRoute.asObservable();

    _subscriptions
      ..map((subscription) => subscription.cancel())
      ..clear()
      ..add(
        _getCurrentUser().listen((user) async {
          pageInfos = ObservableList.of([]);
          if (user != null) {
            if (user.isDonor) {
              pageInfos.add(_pageInfos[0]);
              pageInfos.add(_pageInfos[1]);
            }
            if (user.isBeneficiary) {
              pageInfos.add(_pageInfos[2]);
              pageInfos.add(_pageInfos[3]);
            }
          }
        }),
      );
  }

  @action
  void navigateToPage(int pageIndex) {
    final pageInfo = pageInfos[pageIndex];
    NavigationHelper.goTo(pageInfo.route, replace: true);
  }
}

class PageInfo {
  final String route;
  final IconData icon;
  final String title;
  final String abbrTitle;

  PageInfo({
    required this.route,
    required this.icon,
    required this.title,
    required this.abbrTitle,
  });
}
