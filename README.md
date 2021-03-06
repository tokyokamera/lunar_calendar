# lunar_calendar

Lunar calendar library for Dart Native.
Computing lunar calendar by timezone.

| ![Image](https://github.com/tokyokamera/lunar_calendar/blob/main/lunar_japanese.jpg?raw=true) | ![Image](https://github.com/tokyokamera/lunar_calendar/blob/main/lunar_vietnamese.jpg?raw=true) |
| :------------: | :------------: |
| **Lunar Japanese** | **Lunar Vietnamese** |

## Using

Import the library:
```dart
import 'package:lunar_calendar/lunar_calendar.dart';
```

<br>
Convert calendar from one to another between lunar calendar and solar calendar.
<br>
For example:

```dart
List<int> lunarVi = CalendarConverter.solarToLunar(2020,12,14, Timezone.Vietnamese);
List<int> lunarJa = CalendarConverter.solarToLunar(2020,12,14, Timezone.Japanese);
print(lunarVi); //[1, 11, 2020]
print(lunarJa); //[30, 10, 2020]
```

