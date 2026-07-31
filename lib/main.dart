import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/app/app_route.dart';
import 'package:practicletestone/data/network/client/api_provider.dart';
import 'package:practicletestone/data/network/repository/dashboard_repository.dart';
import 'package:practicletestone/ui/saved_items/saved_items_cubit.dart';
import 'package:practicletestone/ui/widgets/common_progress_indicator.dart';
import 'package:practicletestone/app/app_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiProvider>(
          create: (context) => ApiProvider(),
        ),
        RepositoryProvider<DashboardRepository>(
          create: (context) => DashboardRepository(
            RepositoryProvider.of<ApiProvider>(context),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SavedItemsCubit>(
            create: (context) => SavedItemsCubit(),
          ),
        ],
        child: ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              scrollBehavior: MyCustomScrollBehavior(),
              initialRoute: AppRoute.initialRoute,
              onGenerateRoute: AppRoute.onGenerateRoute,
              builder: (context, widget) => getMainAppViewBuilder(context, widget),
            );
          },
        ),
      ),
    );
  }

  Widget getMainAppViewBuilder(BuildContext context, Widget? widget) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: AppClass().isShowLoading,
        builder: (context, isLoading, child) {
          return IgnorePointer(
            ignoring: isLoading,
            child: Stack(
              children: [
                widget ?? const Offstage(),
                if (isLoading)
                  Container(
                    color: AppColour.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: AppColour.darkBackground1,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColour.primaryAccent.withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColour.black.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 60.r,
                              width: 60.r,
                              child: const CommonProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
