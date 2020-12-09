import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// TextStyle posRes = TextStyle(color: Colors.black, backgroundColor: Colors.red),
//     negRes = TextStyle(color: Colors.black, backgroundColor: Colors.white);

TextSpan searchMatch(
    String search, String match, TextStyle posRes, TextStyle negRes) {
  if (search == null || search == "")
    return TextSpan(text: match, style: negRes);
  var refinedMatch = match.toLowerCase();
  var refinedSearch = search.toLowerCase();
  if (refinedMatch.contains(refinedSearch)) {
    if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
      return TextSpan(
        style: posRes,
        text: match.substring(0, refinedSearch.length),
        children: [
          searchMatch(
              search,
              match.substring(
                refinedSearch.length,
              ),
              posRes,
              negRes),
        ],
      );
    } else if (refinedMatch.length == refinedSearch.length) {
      return TextSpan(text: match, style: posRes);
    } else {
      return TextSpan(
        style: negRes,
        text: match.substring(
          0,
          refinedMatch.indexOf(refinedSearch),
        ),
        children: [
          searchMatch(
              search,
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
              posRes,
              negRes),
        ],
      );
    }
  } else if (!refinedMatch.contains(refinedSearch)) {
    return TextSpan(text: match, style: negRes);
  }
  return TextSpan(
    text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
    style: negRes,
    children: [
      searchMatch(search, match.substring(refinedMatch.indexOf(refinedSearch)),
          posRes, negRes)
    ],
  );
}

String useDecouncedSearch(TextEditingController textEditingController) {
  final search = useState(textEditingController.text);
  useEffect(() {
    Timer timer;
    void listener() {
      timer?.cancel();
      timer = Timer(
        const Duration(milliseconds: 200),
        () => search.value = textEditingController.text,
      );
    }

    textEditingController.addListener(listener);
    return () {
      timer?.cancel();
      textEditingController.removeListener(listener);
    };
  }, [textEditingController]);

  return search.value;
}
