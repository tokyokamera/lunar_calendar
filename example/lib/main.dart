import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lunar_calendar/lunar_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 12, 25): ['Christmas Day'],
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 1, 6): ['Epiphany'],
  DateTime(2021, 2, 14): ['Valentine\'s Day'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lunar Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    List<int> lunarVi = CalendarConverter.solarToLunar(2020, 12, 14, Timezone.Vietnamese);
    List<int> lunarJa = CalendarConverter.solarToLunar(2020, 12, 14, Timezone.Japanese);
    print(lunarVi);
    print(lunarJa);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunar Calendar Demo'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
        ],
      ),
    );
  }

  String printLunarDate(DateTime solar) {
    List<int> lunar = CalendarConverter.solarToLunar(solar.year, solar.month, solar.day, Timezone.Japanese);
    return DateFormat.Md('ja').format(DateTime(lunar[2], lunar[1], lunar[0]));
  }

  Widget buildCell(Color color, DateTime date) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 3, bottom: 3),
      width: 100,
      height: 100,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${date.day}',
            style: TextStyle().copyWith(fontSize: 16.0),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '${printLunarDate(date)}',
              style: TextStyle().copyWith(fontSize: 10.0),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          return buildCell(Colors.grey.withOpacity(0.1), date);
        },
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: buildCell(Colors.deepOrange[300].withOpacity(0.5), date),
          );
        },
        todayDayBuilder: (context, date, _) {
          return buildCell(Colors.amber[400].withOpacity(0.5), date);
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.assistant_photo,
      size: 20.0,
      color: Colors.deepOrange,
    );
  }
}
