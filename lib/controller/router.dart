import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view/views.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: HomeView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/new',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: TaskEditView(
            editMode: EditMode.create,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: SettingsView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: 'theme',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: ThemeView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
              path: 'appearance',
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: AppearanceView(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                  ),
              routes: [
                GoRoute(
                  path: 'listtype',
                  pageBuilder: (context, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: ListTileType(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                  ),
                ),
              ]),
        ],
      ),
    ],
  );
  return router;
});
