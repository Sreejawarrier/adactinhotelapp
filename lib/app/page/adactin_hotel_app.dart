import 'package:adactin_hotel_app/api/models/hotel_searech_result.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:adactin_hotel_app/app/page/app_container_widget.dart';
import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/hotels_search_list/page/hotels_list_page.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdactinHotelApp extends StatefulWidget {
  final AppBloc appBloc;
  final AppTabBloc appTabBloc;

  AdactinHotelApp({@required this.appBloc, @required this.appTabBloc});

  @override
  State<StatefulWidget> createState() => _AdactinHotelAppState();
}

class _AdactinHotelAppState extends State<AdactinHotelApp> {
  static const String mainTitle = 'Adactin Hotel App';

  @override
  void initState() {
    super.initState();

    widget.appBloc.add(AppStart());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) => widget.appBloc),
        BlocProvider<AppTabBloc>(create: (context) => widget.appTabBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: mainTitle,
        theme: ThemeData(
          primaryColor: Palette.primaryColor,
          primaryColorBrightness: Brightness.dark,
          cursorColor: Palette.primaryColor,
        ),
        home: AppContainerWidget(),
        onGenerateRoute: (RouteSettings settings) {
          Widget screen;
          dynamic args = settings.arguments;

          switch (settings.name) {
            case AppRoutes.SELECT_HOTEL:
              if (args is List<HotelSearchResult>) {
                screen = _getHotelSearchList(hotels: args);
              }
              break;
          }

          if (screen != null) {
            return MaterialPageRoute(
              settings: RouteSettings(name: settings.name),
              builder: (context) => screen,
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _getHotelSearchList({List<HotelSearchResult> hotels}) {
    return HotelsListPage(hotels: hotels);
  }
}
