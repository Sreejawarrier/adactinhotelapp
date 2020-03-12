import 'package:adactin_hotel_app/api/models/hotel_search.dart';
import 'package:adactin_hotel_app/api/repo/hotel_search_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/base/ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/home/bloc/home_bloc.dart';
import 'package:adactin_hotel_app/home/constants/home_content.dart';
import 'package:adactin_hotel_app/home/constants/home_semantic_keys.dart';
import 'package:adactin_hotel_app/theme/images.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final AppBloc appBloc;

  HomePage({Key key, @required this.appBloc})
      : assert(appBloc != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const double appBarContentHeight = 140;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _locationTextFieldController =
      TextEditingController();
  final FocusNode _locationTextFieldFocusNode = FocusNode();
  final TextEditingController _hotelsTextFieldController =
      TextEditingController();
  final FocusNode _hotelsTextFieldFocusNode = FocusNode();
  final TextEditingController _roomTypeTextFieldController =
      TextEditingController();
  final FocusNode _roomTypeTextFieldFocusNode = FocusNode();
  final TextEditingController _numberOfRoomsTextFieldController =
      TextEditingController();
  final FocusNode _numberOfRoomsTextFieldFocusNode = FocusNode();
  final TextEditingController _checkInDateTextFieldController =
      TextEditingController();
  final FocusNode _checkInDateTextFieldFocusNode = FocusNode();
  final TextEditingController _checkOutDateTextFieldController =
      TextEditingController();
  final FocusNode _checkOutDateTextFieldFocusNode = FocusNode();
  final TextEditingController _adultsPerRoomTextFieldController =
      TextEditingController();
  final FocusNode _adultsPerRoomTextFieldFocusNode = FocusNode();
  final TextEditingController _childrenPerRoomTextFieldController =
      TextEditingController();
  final FocusNode _childrenPerRoomTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _locationTextFieldFocusNode.addListener(_locationFieldInputDisplay);
    _hotelsTextFieldFocusNode.addListener(_hotelsFieldInputDisplay);
    _roomTypeTextFieldFocusNode.addListener(_roomTypeFieldInputDisplay);
    _numberOfRoomsTextFieldController.text =
        HomeContent().numberOfRoomsValues().first;
    _numberOfRoomsTextFieldFocusNode
        .addListener(_numberOfRoomsFieldInputDisplay);
    _checkInDateTextFieldController.text = _dateFormat.format(DateTime.now());
    _checkInDateTextFieldFocusNode.addListener(_checkInDateFieldInputDisplay);
    _checkOutDateTextFieldController.text =
        _dateFormat.format(DateTime.now().add(Duration(days: 1)));
    _checkOutDateTextFieldFocusNode.addListener(_checkOutDateFieldInputDisplay);
    _adultsPerRoomTextFieldController.text =
        HomeContent().personsPerRoomValues().first;
    _adultsPerRoomTextFieldFocusNode
        .addListener(_adultsPerRoomFieldInputDisplay);
    _childrenPerRoomTextFieldFocusNode
        .addListener(_childrenPerRoomFieldInputDisplay);
  }

  @override
  void dispose() {
    _locationTextFieldController.dispose();
    _locationTextFieldFocusNode.removeListener(_locationFieldInputDisplay);
    _locationTextFieldFocusNode.dispose();
    _hotelsTextFieldController.dispose();
    _hotelsTextFieldFocusNode.removeListener(_hotelsFieldInputDisplay);
    _hotelsTextFieldFocusNode.dispose();
    _roomTypeTextFieldController.dispose();
    _roomTypeTextFieldFocusNode.removeListener(_roomTypeFieldInputDisplay);
    _roomTypeTextFieldFocusNode.dispose();
    _numberOfRoomsTextFieldController.dispose();
    _numberOfRoomsTextFieldFocusNode
        .removeListener(_numberOfRoomsFieldInputDisplay);
    _numberOfRoomsTextFieldFocusNode.dispose();
    _checkInDateTextFieldController.dispose();
    _checkInDateTextFieldFocusNode
        .removeListener(_checkInDateFieldInputDisplay);
    _checkInDateTextFieldFocusNode.dispose();
    _checkOutDateTextFieldController.dispose();
    _checkOutDateTextFieldFocusNode
        .removeListener(_checkOutDateFieldInputDisplay);
    _checkOutDateTextFieldFocusNode.dispose();
    _adultsPerRoomTextFieldController.dispose();
    _adultsPerRoomTextFieldFocusNode
        .removeListener(_adultsPerRoomFieldInputDisplay);
    _adultsPerRoomTextFieldFocusNode.dispose();
    _childrenPerRoomTextFieldController.dispose();
    _childrenPerRoomTextFieldFocusNode
        .removeListener(_childrenPerRoomFieldInputDisplay);
    _childrenPerRoomTextFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: BlocProvider(
        create: (context) {
          return HomeBloc(
            hotelSearchRepository: HotelSearchRepository(),
          );
        },
        child: SafeArea(
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HotelSearchSuccess) {
                Navigator.of(context).pushNamed(
                  AppRoutes.SELECT_HOTEL,
                  arguments: state.hotelSearchResultList,
                );
              } else if (state is HotelSearchFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: HomeSemanticKeys.failureAlert,
                      title: Text(HomeContent.alertFailureTitle),
                      content: Text(state.error),
                      actions: <Widget>[
                        FlatButton(
                          child: Semantics(
                            enabled: true,
                            label: HomeSemanticKeys.failureAlertButton,
                            child: Text(HomeContent.alertButtonOk),
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
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _removeFocus(),
                      child: Container(
                        color: Colors.white,
                        child: _getHotelSearchForm(context),
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
    );
  }

  /// --- --- --- App Bar --- --- ---

  /// Appbar of preferred size with adactin white logo at the centre of it
  PreferredSize _getAppBar() {
    return PreferredSize(
      child: AppBar(
        backgroundColor: Palette.primaryColor,
        flexibleSpace: Semantics(
          label: HomeSemanticKeys.logo,
          enabled: true,
          child: SvgPicture.asset(
            Images.logoSVGWhite,
            width: appBarContentHeight,
            height: appBarContentHeight,
          ),
        ),
      ),
      preferredSize: Size.fromHeight(appBarContentHeight),
    );
  }

  /// --- --- --- Search Form --- --- ---

  Widget _getHotelSearchForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 2),
            _getWelcomeMessage(),
            const SizedBox(height: 18),
            _getFormTitle(),
            const SizedBox(height: 20),
            _getLocationLabel(context),
            const SizedBox(height: 6),
            _getLocationFormField(context),
            const SizedBox(height: 20),
            _getHotelsLabel(context),
            const SizedBox(height: 6),
            _getHotelsFormField(context),
            const SizedBox(height: 20),
            _getRoomTypeLabel(context),
            const SizedBox(height: 6),
            _getRoomTypeFormField(context),
            const SizedBox(height: 18),
            _getNumberOfRoomsLabel(context),
            const SizedBox(height: 6),
            _getNumberOfRoomsFormField(context),
            const SizedBox(height: 18),
            _getCheckInDateLabel(context),
            const SizedBox(height: 6),
            _getCheckInDateFormField(context),
            const SizedBox(height: 18),
            _getCheckOutDateLabel(context),
            const SizedBox(height: 6),
            _getCheckOutDateFormField(context),
            const SizedBox(height: 18),
            _getAdultsPerRoomLabel(context),
            const SizedBox(height: 6),
            _getAdultsPerRoomFormField(context),
            const SizedBox(height: 20),
            _getChildrenPerRoomLabel(context),
            const SizedBox(height: 6),
            _getChildrenPerRoomFormField(context),
            const SizedBox(height: 20),
            _getButtons(context),
            const SizedBox(height: 10),
            _getMandatoryMessage(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// --- --- --- Welcome message --- --- ---

  Widget _getWelcomeMessage() {
    return Text(
      HomeContent.welcomeMessage.replaceAll(
        HomeContent.welcomeUserNameKey,
        widget.appBloc.userDetails.username,
      ),
      textAlign: TextAlign.left,
      semanticsLabel: HomeSemanticKeys.welcome_user,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Palette.primaryColor,
      ),
    );
  }

  /// --- --- --- Form title --- --- ---

  Widget _getFormTitle() {
    return Text(
      HomeContent.searchHotel,
      semanticsLabel: HomeSemanticKeys.searchHotel,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// --- --- --- Location --- --- ---

  Widget _getLocationLabel(BuildContext context) {
    return _getLabel(context, HomeContent.location, isRequiredField: true);
  }

  Widget _getLocationFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.location,
      _locationTextFieldController,
      _locationTextFieldFocusNode,
      HomeContent.locationHint,
      validator: (String value) {
        return (value == null || value.isEmpty)
            ? HomeContent.errorLocation
            : null;
      },
    );
  }

  void _locationFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: HomeContent().locationValues(),
      textEditingController: _locationTextFieldController,
      title: HomeContent.locationHint,
    );
  }

  /// --- --- --- Hotels --- --- ---

  Widget _getHotelsLabel(BuildContext context) {
    return _getLabel(
      context,
      HomeContent.hotels,
    );
  }

  Widget _getHotelsFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.hotels,
      _hotelsTextFieldController,
      _hotelsTextFieldFocusNode,
      HomeContent.hotelsHint,
    );
  }

  void _hotelsFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: HomeContent().hotelValues(),
      textEditingController: _hotelsTextFieldController,
      title: HomeContent.hotelsHint,
    );
  }

  /// --- --- --- Room Type --- --- ---

  Widget _getRoomTypeLabel(BuildContext context) {
    return _getLabel(
      context,
      HomeContent.roomType,
    );
  }

  Widget _getRoomTypeFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.roomType,
      _roomTypeTextFieldController,
      _roomTypeTextFieldFocusNode,
      HomeContent.roomTypeHint,
    );
  }

  void _roomTypeFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: HomeContent().roomTypeValues(),
      textEditingController: _roomTypeTextFieldController,
      title: HomeContent.roomTypeHint,
    );
  }

  /// --- --- --- Number of Rooms --- --- ---

  Widget _getNumberOfRoomsLabel(BuildContext context) {
    return _getLabel(context, HomeContent.numberOfRooms, isRequiredField: true);
  }

  Widget _getNumberOfRoomsFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.numberOfRooms,
      _numberOfRoomsTextFieldController,
      _numberOfRoomsTextFieldFocusNode,
      HomeContent.numberOfRoomsHint,
      validator: (String value) {
        return (value == null || value.isEmpty)
            ? HomeContent.errorNumberOfRooms
            : null;
      },
    );
  }

  void _numberOfRoomsFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: HomeContent().numberOfRoomsValues(),
      textEditingController: _numberOfRoomsTextFieldController,
      title: HomeContent.numberOfRoomsHint,
    );
  }

  /// --- --- --- Check-in Date --- --- ---

  Widget _getCheckInDateLabel(BuildContext context) {
    return _getLabel(context, HomeContent.checkInDate, isRequiredField: true);
  }

  Widget _getCheckInDateFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.checkInDate,
      _checkInDateTextFieldController,
      _checkInDateTextFieldFocusNode,
      HomeContent.checkInDateHint,
      validator: (String value) {
        return (value == null || value.isEmpty)
            ? HomeContent.errorCheckInDate
            : null;
      },
    );
  }

  void _checkInDateFieldInputDisplay() {
    _removeFocus();
    _showDatePicker(
      textEditingController: _checkInDateTextFieldController,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(Duration(days: (3650))),
      onDatePickerConfirm: (DateTime date) {
        final DateTime currentCheckOutDate =
            _dateFormat.parse(_checkOutDateTextFieldController.text);
        final DateTime checkOutDate = _dateFormat
            .parse(_checkInDateTextFieldController.text)
            .add(Duration(days: 1));

        if (currentCheckOutDate.difference(checkOutDate).inDays < 0) {
          _checkOutDateTextFieldController.text =
              _dateFormat.format(checkOutDate);
        }
      },
    );
  }

  /// --- --- --- Check-out Date --- --- ---

  Widget _getCheckOutDateLabel(BuildContext context) {
    return _getLabel(context, HomeContent.checkOutDate, isRequiredField: true);
  }

  Widget _getCheckOutDateFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.checkOutDate,
      _checkOutDateTextFieldController,
      _checkOutDateTextFieldFocusNode,
      HomeContent.checkOutDateHint,
      validator: (String value) {
        return (value == null || value.isEmpty)
            ? HomeContent.errorCheckOutDate
            : null;
      },
    );
  }

  void _checkOutDateFieldInputDisplay() {
    _removeFocus();
    _showDatePicker(
      textEditingController: _checkOutDateTextFieldController,
      minDate: (_checkInDateTextFieldController.text?.isEmpty == true)
          ? DateTime.now().add(Duration(days: 1))
          : _dateFormat
              .parse(_checkInDateTextFieldController.text)
              .add(Duration(days: 1)),
      maxDate: DateTime.now().add(Duration(days: (3650))),
    );
  }

  /// --- --- --- Adults per Room --- --- ---

  Widget _getAdultsPerRoomLabel(BuildContext context) {
    return _getLabel(context, HomeContent.adultsPerRoom, isRequiredField: true);
  }

  Widget _getAdultsPerRoomFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.adultsPerRoom,
      _adultsPerRoomTextFieldController,
      _adultsPerRoomTextFieldFocusNode,
      HomeContent.adultsPerRoomHint,
      validator: (String value) {
        return (value == null || value.isEmpty)
            ? HomeContent.errorAdultsPerRoom
            : null;
      },
    );
  }

  void _adultsPerRoomFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: HomeContent().personsPerRoomValues(),
      textEditingController: _adultsPerRoomTextFieldController,
      title: HomeContent.adultsPerRoomHint,
    );
  }

  /// --- --- --- Children per Room --- --- ---

  Widget _getChildrenPerRoomLabel(BuildContext context) {
    return _getLabel(
      context,
      HomeContent.childrenPerRoom,
    );
  }

  Widget _getChildrenPerRoomFormField(BuildContext context) {
    return _getTextFormField(
      context,
      HomeSemanticKeys.childrenPerRoom,
      _childrenPerRoomTextFieldController,
      _childrenPerRoomTextFieldFocusNode,
      HomeContent.childrenPerRoomHint,
    );
  }

  void _childrenPerRoomFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: HomeContent().personsPerRoomValues(),
      textEditingController: _childrenPerRoomTextFieldController,
      title: HomeContent.childrenPerRoomHint,
    );
  }

  /// --- --- --- Label --- --- ---

  Widget _getLabel(
    BuildContext context,
    String label, {
    bool isRequiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Semantics(
        enabled: true,
        label: label,
        child: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Palette.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: isRequiredField
                ? [
                    TextSpan(
                      text: HomeContent.asterisk,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  /// --- --- --- Text form field --- --- ---

  Widget _getTextFormField(
    BuildContext context,
    String semanticLabel,
    TextEditingController textEditingController,
    FocusNode textFocusNode,
    String hintText, {
    FormFieldValidator<String> validator,
  }) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      child: EnsureVisibleWhenFocused(
        focusNode: textFocusNode,
        child: TextFormField(
          controller: textEditingController,
          focusNode: textFocusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 22,
            ),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }

  /// --- --- --- Bottom modal sheet --- --- ---

  void _showBottomModalSheet({
    @required List<String> values,
    @required TextEditingController textEditingController,
    @required String title,
  }) {
    final Widget modalSheet = _buildBottomMenu(
      title,
      values,
      textEditingController,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Semantics(
          enabled: true,
          label: HomeSemanticKeys.bottomSheet,
          child: Container(
            color: Color(0xFF737373),
            child: Wrap(
              children: <Widget>[
                Container(
                  child: modalSheet,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30),
                      topRight: const Radius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomMenu(
    String title,
    List<String> values,
    TextEditingController textEditingController,
  ) {
    return Semantics(
      enabled: true,
      label: HomeSemanticKeys.bottomSheetOptionsColumn,
      child: Column(
        children: <Widget>[
          _getTitleOfSheet(title),
          _getBottomSheetOptions(values, textEditingController),
          _getBottomModalSheetButton(),
        ],
      ),
    );
  }

  Widget _getTitleOfSheet(String title) {
    if (title.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 8,
        ),
        child: Text(
          title,
          semanticsLabel: '${HomeSemanticKeys.bottomOptionTitle}$title',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container();
  }

  Widget _getBottomSheetOptions(
    List<String> values,
    TextEditingController textEditingController,
  ) {
    if (values != null && values.isNotEmpty) {
      final List<Widget> itemWidgets = values
          .map(
            (value) => Semantics(
              enabled: true,
              label: '${HomeSemanticKeys.bottomOption}$value',
              child: ListTile(
                title: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  textEditingController.text = value;
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
          .toList();

      return Container(
        constraints: BoxConstraints(maxHeight: 480),
        child: ListView(
          shrinkWrap: true,
          semanticChildCount: values.length,
          children: itemWidgets,
        ),
      );
    }

    return Container();
  }

  Widget _getBottomModalSheetButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Semantics(
        enabled: true,
        label: HomeSemanticKeys.bottomSheetCancel,
        child: Container(
          width: double.infinity,
          height: 55.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Palette.primaryColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              HomeContent.cancel,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  /// --- --- --- Date Picker --- --- ---

  void _showDatePicker({
    @required TextEditingController textEditingController,
    @required DateTime minDate,
    @required DateTime maxDate,
    Function(DateTime) onDatePickerConfirm,
  }) {
    DatePicker.showDatePicker(
      context,
      minDateTime: minDate,
      maxDateTime: maxDate,
      dateFormat: 'dd-MM-yyyy',
      initialDateTime: (textEditingController.text?.isEmpty == true)
          ? DateTime.now()
          : _dateFormat.parse(textEditingController.text),
      onConfirm: (date, _) {
        textEditingController.text = _dateFormat.format(date);
        if (onDatePickerConfirm != null) {
          onDatePickerConfirm(date);
        }
      },
    );
  }

  /// --- --- --- Remove Focus --- --- ---

  /// Will remove focus from the current Focus node
  void _removeFocus() {
    FocusScope.of(context).unfocus();
  }

  /// --- --- --- Buttons --- --- ---

  Widget _getButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _getButton(
            context,
            HomeSemanticKeys.search,
            HomeContent.search,
            Palette.primaryColor,
            () {
              _searchHotels(context);
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _getButton(
            context,
            HomeSemanticKeys.reset,
            HomeContent.reset,
            Colors.grey,
            () {
              _resetTextFields();
            },
          ),
        ),
      ],
    );
  }

  Widget _getButton(
    BuildContext context,
    String semanticKey,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Semantics(
      label: semanticKey,
      enabled: true,
      child: RaisedButton(
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _searchHotels(BuildContext context) {
    _removeFocus();

    if (_isValidFormContent(context)) {
      BlocProvider.of<HomeBloc>(context).add(
        HotelSearchAction(
          appBloc: widget.appBloc,
          hotelSearch: HotelSearch(
            location: _locationTextFieldController.text,
            hotels: _hotelsTextFieldController.text,
            roomType: _roomTypeTextFieldController.text,
            numberOfRooms: _numberOfRoomsTextFieldController.text,
            checkInDate: _checkInDateTextFieldController.text,
            checkOutDate: _checkOutDateTextFieldController.text,
            adultsPerRoom: _adultsPerRoomTextFieldController.text,
            childrenPerRoom: _childrenPerRoomTextFieldController.text,
          ),
        ),
      );
    }
  }

  bool _isValidFormContent(BuildContext context) {
    _formKey.currentState.validate();
    bool isValid = true;
    String fieldsRequiredData = '';
    if (_locationTextFieldController.text.isEmpty) {
      fieldsRequiredData = HomeContent.location;
      isValid = false;
    } else if (_numberOfRoomsTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = HomeContent.numberOfRooms
          : fieldsRequiredData = ', ${HomeContent.numberOfRooms}';
      isValid = false;
    } else if (_checkInDateTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = HomeContent.checkInDate
          : fieldsRequiredData = ', ${HomeContent.checkInDate}';
      isValid = false;
    } else if (_checkOutDateTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = HomeContent.checkOutDate
          : fieldsRequiredData = ', ${HomeContent.checkOutDate}';
      isValid = false;
    } else if (_adultsPerRoomTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = HomeContent.adultsPerRoom
          : fieldsRequiredData = ', ${HomeContent.adultsPerRoom}';
      isValid = false;
    }

    if (!isValid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            semanticLabel: HomeSemanticKeys.failureAlert,
            title: Text(HomeContent.errorMissingData),
            content:
                Text('${HomeContent.errorRequireData} $fieldsRequiredData'),
            actions: <Widget>[
              FlatButton(
                child: Semantics(
                  enabled: true,
                  label: HomeSemanticKeys.failureAlertButton,
                  child: Text(HomeContent.alertButtonOk),
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
    }

    return isValid;
  }

  void _resetTextFields() {
    _locationTextFieldController.text = '';
    _hotelsTextFieldController.text = '';
    _roomTypeTextFieldController.text = '';
    _numberOfRoomsTextFieldController.text =
        HomeContent().numberOfRoomsValues().first;
    _checkInDateTextFieldController.text = _dateFormat.format(DateTime.now());
    _checkOutDateTextFieldController.text =
        _dateFormat.format(DateTime.now().add(Duration(days: 1)));
    _adultsPerRoomTextFieldController.text =
        HomeContent().personsPerRoomValues().first;
    _childrenPerRoomTextFieldController.text = '';
  }

  /// --- --- --- Mandatory message --- --- ---

  Widget _getMandatoryMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Semantics(
        enabled: true,
        label: HomeSemanticKeys.mandatoryFieldsMessage,
        child: RichText(
          text: TextSpan(
            text: HomeContent.allFields,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            children: [
              TextSpan(
                text: HomeContent.asterisk,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: HomeContent.mandatory,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
