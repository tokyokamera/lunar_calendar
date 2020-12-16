import 'package:lunar_calendar/lunar_calendar.dart';

void main(List<String> arguments) {
  List<int> lunarVi = CalendarConverter.solarToLunar(2020,12,14, Timezone.Vietnamese);
  List<int> lunarJa = CalendarConverter.solarToLunar(2020,12,14, Timezone.Japanese);
  print(lunarVi);
  print(lunarJa);
}
