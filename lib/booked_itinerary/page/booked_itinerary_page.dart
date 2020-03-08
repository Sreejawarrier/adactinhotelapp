import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/api/repo/booked_itinerary_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/base/hotel_overview/container/hotel_overview_container.dart';
import 'package:adactin_hotel_app/base/hotel_overview/model/hotel_overview_data.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/booked_itinerary/bloc/booked_itinerary_bloc.dart';
import 'package:adactin_hotel_app/booked_itinerary/content/booked_itinerary_content.dart';
import 'package:adactin_hotel_app/booked_itinerary/content/booked_itinerary_semantic_keys.dart';
import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookedItineraryPage extends StatefulWidget {
  final AppBloc appBloc;

  BookedItineraryPage({Key key, @required this.appBloc})
      : assert(appBloc != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _BookedItineraryPageState();
}

class _BookedItineraryPageState extends State<BookedItineraryPage>
    with RouteAware {
  final DateFormat _fromDateFormat = DateFormat('dd/MM/yyyy');

  BookedItineraryBloc _bookedItineraryBloc;
  List<BookedItinerary> _bookedItineraryList = [];

  @override
  void initState() {
    super.initState();

    _bookedItineraryBloc = BookedItineraryBloc(
      bookedItineraryRepository: BookedItineraryRepository(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBookings();
    });
  }

  @override
  void dispose() {
    _bookedItineraryBloc.close();
    _bookedItineraryBloc = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: widget.appBloc,
        condition: (previous, current) {
          return (current is BookedItineraryRefresh);
        },
        listener: (context, state) {
          _fetchBookings();
        },
        child: BlocProvider(
          create: (context) {
            return _bookedItineraryBloc;
          },
          child: SafeArea(
            child: BlocListener<BookedItineraryBloc, BookedItineraryState>(
              listener: (context, state) {
                if (state is BookedItineraryFailure) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        semanticLabel: BookedItinerarySemanticKeys.failureAlert,
                        title: Text(BookedItineraryContent.alertFailureTitle),
                        content: Text(state.error),
                        actions: <Widget>[
                          FlatButton(
                            child: Semantics(
                              enabled: true,
                              label: BookedItinerarySemanticKeys
                                  .failureAlertButton,
                              child: Text(BookedItineraryContent.alertButtonOk),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                    barrierDismissible: false,
                  );
                } else if (state is BookedItinerarySuccess) {
                  _bookedItineraryList = state.bookedItineraryList ?? [];
                }
              },
              child: BlocBuilder<BookedItineraryBloc, BookedItineraryState>(
                builder: (context, state) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: Semantics(
                          enabled: true,
                          label: BookedItinerarySemanticKeys.view_container,
                          child: Container(
                            color: Colors.transparent,
                            child: (_bookedItineraryList?.isNotEmpty == true)
                                ? ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Semantics(
                                        enabled: true,
                                        label:
                                            '${BookedItinerarySemanticKeys.list_container}$index',
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                          ),
                                          child: HotelOverviewContainer(
                                            hotelData: HotelOverviewData(
                                              hotelData:
                                                  _bookedItineraryList[index],
                                              name: _bookedItineraryList[index]
                                                  .hotelName,
                                              location:
                                                  _bookedItineraryList[index]
                                                      .location,
                                              fromDate:
                                                  _bookedItineraryList[index]
                                                      .arrivalDate,
                                              toDate:
                                                  _bookedItineraryList[index]
                                                      .departureDate,
                                              totalPrice:
                                                  '${globalConstants.GlobalConstants.audPriceFormat}'
                                                  '${_bookedItineraryList[index].finalPrice}',
                                            ),
                                            isInitialItem: index == 0,
                                            isLastItem: index ==
                                                (_bookedItineraryList.length -
                                                    1),
                                            fromDateFormat: _fromDateFormat,
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                    itemCount: _bookedItineraryList.length,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        BookedItineraryContent
                                            .emptyBookingMessage,
                                        semanticsLabel:
                                            BookedItinerarySemanticKeys
                                                .empty_booking_message,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      state is SearchInProcess
                          ? Spinner()
                          : const SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fetchBookings() {
    _bookedItineraryBloc?.add(
      FetchBookingsAction(appBloc: widget.appBloc),
    );
  }
}
