import 'dart:math';

var timeDividers = {
  "millisecond": 1,
  "second": 1000,
  "minute": 60,
  "hour": 60,
  "day": 24,
  "month": 30,
  "year": 12
};

var timeDistance = {
  "millisecond": 1,
  "second": 1000,
  "minute": 60000,
  "hour": 3600000,
  "day": 86400000,
  "month": 2592000000,
  "year": 31104000000
};

var nextUnits = {
  'millisecond': 'second',
  'second': 'minute',
  'minute': 'hour',
  'hour': 'day',
  'day': 'month',
  'month': 'year',
  'year': 'year'
};

var defaultTimeSteps = {
  'millisecond': 1,
  'second': 1,
  'minute': 1,
  'hour': 1,
  'day': 1,
  'month': 1,
  'year': 1
};

final minCellWidth = 17;
/**
 * zoom: 屏幕上渲染部分的毫秒数  renderEnd - renderStart
 * width: 屏幕宽度像素
 */
String getMinUnit(double zoom, double width, Map<String, int> timeSteps) {
  print("getMinUnit:  zoom:$zoom, width:$width");
  String minUnit = 'year';
  //this timespan is in ms initially
  double nextTimeSpanInUnitContext = zoom;
  timeDividers.keys.any((unit) {
    print("getMinUnit:  loop timeDividers unit:$unit");
    nextTimeSpanInUnitContext = nextTimeSpanInUnitContext / timeDividers[unit];
    print(
        "getMinUnit:  nextTimeSpanInUnitContext:$nextTimeSpanInUnitContext timeSteps[unit]: ${timeSteps[unit]}");
    /* 当前单位屏幕上总的cell数 */
    final cellsToBeRenderedForCurrentUnit =
        nextTimeSpanInUnitContext / timeSteps[unit];
    final cellWidthToUse = timeSteps[unit] != null && timeSteps[unit] > 1
        ? 3 * minCellWidth
        : minCellWidth;

    /* cell 最小宽度 */
    final minimumCellsToRenderUnit = width / cellWidthToUse;
    print(
        "getMinUnit: cellWidthToUse:$cellWidthToUse   cellsToBeRenderedForCurrentUnit:$cellsToBeRenderedForCurrentUnit  minimumCellsToRenderUnit:$minimumCellsToRenderUnit ");

    /* cell数大于最小宽度说明可以继续除， 否则已经找到并返回 */
    if (cellsToBeRenderedForCurrentUnit < minimumCellsToRenderUnit) {
      // for the current zoom, the number of cells we'd need to render all parts of this unit
      // is less than the minimum number of cells needed at minimum cell width
      minUnit = unit;
      return true;
    }
    return false;
  });

  print("getMinUnit:  minUnit:$minUnit");

  return minUnit;
}

DateTime _addByMilliSeconds(DateTime dateTime, int value) {
  return dateTime.add(Duration(milliseconds: value));
}

DateTime _addBySeconds(DateTime dateTime, int value) {
  return dateTime.add(Duration(seconds: value));
}

DateTime _addByMinutes(DateTime dateTime, int value) {
  return dateTime.add(Duration(minutes: value));
}

DateTime _addByHours(DateTime dateTime, int value) {
  return dateTime.add(Duration(hours: value));
}

DateTime _addByDays(DateTime dateTime, int value) {
  return dateTime.add(Duration(days: value));
}

DateTime _addByWeeks(DateTime dateTime, int value) {
  return _addByDays(dateTime, value * 7);
}

DateTime _addByYears(DateTime dateTime, int value) {
  return _addByMonths(dateTime, value * 12);
}

const _daysInMonthArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

bool _isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

int _daysInMonth(int year, int month) {
  var result = _daysInMonthArray[month];
  if (month == 2 && _isLeapYear(year)) result++;
  return result;
}

// int min(int a, int b) {
//   return a > b ? b : a;
// }

DateTime _addByMonths(DateTime from, int months) {
  final r = months % 12;
  final q = (months - r) ~/ 12;
  var newYear = from.year + q;
  var newMonth = from.month + r;
  if (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }
  final newDay = min(from.day, _daysInMonth(newYear, newMonth));
  if (from.isUtc) {
    return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  } else {
    return DateTime(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  }
}

var addFucByUnit = {
  'millisecond': _addByMilliSeconds,
  'second': _addBySeconds,
  'minute': _addByMinutes,
  'hour': _addByHours,
  'day': _addByDays,
  'week': _addByWeeks,
  'month': _addByMonths,
  'year': _addByYears,
};

var timeFormatByUnit = {
  'second': "y/M/d hh:mm:ss",
  'minute': "y/M/d hh点mm分",
  'hour': "y/M/d hh点整",
  'day': "y年M月d日",
  'week': "y/M/E/d",
  'month': "y/M月",
  'year': "y年",
};

int getValueByUnit(DateTime dateTime, String unit) {
  switch (unit) {
    case "millisecond":
      return dateTime.millisecond;
    case "second":
      return dateTime.second;
    case "minute":
      return dateTime.minute;
    case "hour":
      return dateTime.hour;
    case "day":
      return dateTime.day;
    case "month":
      return dateTime.month;
    case "year":
      return dateTime.year;
  }
  return 0;
}

DateTime startOf(DateTime dateTime, String units) {
  DateTime _dateTime = dateTime;
  switch (units) {
    case "millisecond":
      _dateTime = DateTime(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          _dateTime.hour,
          _dateTime.minute,
          _dateTime.second,
          _dateTime.millisecond);
      break;
    case "second":
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
          _dateTime.hour, _dateTime.minute, _dateTime.second);
      break;
    case "minute":
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
          _dateTime.hour, _dateTime.minute);
      break;
    case "hour":
      _dateTime = DateTime(
          _dateTime.year, _dateTime.month, _dateTime.day, _dateTime.hour);
      break;
    case "day":
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day);
      break;
    case "month":
      _dateTime = DateTime(_dateTime.year, _dateTime.month, 1);
      break;
    case "year":
      _dateTime = DateTime(_dateTime.year);
      break;
  }
  return _dateTime;
}
