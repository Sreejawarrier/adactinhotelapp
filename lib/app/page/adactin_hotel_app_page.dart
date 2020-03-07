import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/api/models/booking_details.dart';
import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:adactin_hotel_app/app/page/app_container_widget.dart';
import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/book_hotel/page/book_hotel_page.dart';
import 'package:adactin_hotel_app/booking_details/page/booking_details.dart';
import 'package:adactin_hotel_app/hotel_detail/page/hotel_detail_page.dart';
import 'package:adactin_hotel_app/hotels_search_list/page/hotels_search_list_page.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AdactinHotelAppPage extends StatefulWidget {
  final AppBloc appBloc;
  final AppTabBloc appTabBloc;

  AdactinHotelAppPage({@required this.appBloc, @required this.appTabBloc});

  @override
  State<StatefulWidget> createState() => _AdactinHotelAppPageState();
}

class _AdactinHotelAppPageState extends State<AdactinHotelAppPage> {
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
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          Widget screen;
          dynamic args = settings.arguments;

          switch (settings.name) {
            case AppRoutes.SELECT_HOTEL:
              if (args is List<HotelSearchResult>) {
                screen = _getHotelSearchList(hotels: args);
              }
              break;
            case AppRoutes.HOTEL_DETAIL:
              if (args is HotelSearchResult || args is BookedItinerary) {
                screen = _getHotelDetail(hotel: args);
              }
              break;
            case AppRoutes.BOOK_HOTEL:
              if (args is HotelSearchResult) {
                screen = _getBookHotel(hotel: args);
              }
              break;
            case AppRoutes.BOOKING_DETAILS:
              if (args is BookingDetails) {
                screen = _getBookingDetails(details: args);
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
    return HotelsSearchListPage(hotels: hotels);
  }

  Widget _getHotelDetail<T>({T hotel}) {
    return HotelDetailPage(appBloc: widget.appBloc, hotel: hotel);
  }

  Widget _getBookHotel({HotelSearchResult hotel}) {
    return BookHotelPage(appBloc: widget.appBloc, hotelSearchResult: hotel);
  }

  Widget _getBookingDetails({BookingDetails details}) {
    return BookingDetailsPage(details: details);
  }
}
