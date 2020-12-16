# lunar_calendar

Lunar calendar library for Dart Native.
Computing lunar calendar by timezone.
## Using

Import the library:
```dart
import 'package:lunar_calendar/lunar_calendar.dart';
```

<br>
Convert calendar from one to another between lunar calendar and solar calendar.
For example:
```dart
List<int> lunarVi = CalendarConverter.solarToLunar(2020,12,14, Timezone.Vietnamese);
List<int> lunarJa = CalendarConverter.solarToLunar(2020,12,14, Timezone.Japanese);
print(lunarVi); //[1, 11, 2020]
print(lunarJa); //[30, 10, 2020]
```

<br>
Refers:
<br>
<a href="https://www.informatik.uni-leipzig.de/~duc/amlich/calrules_en.html">Computing the Vietnamese lunar calendar</a>