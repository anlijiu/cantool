import 'package:cantool/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutPage extends HookConsumerWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabInDrawerProvider);
    return Offstage(
        offstage: currentTab != 2,
        child: Center(
          child: TextButton(
            child: const Text('https://github.com/anlijiu/cantool',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            onPressed: () {
              url_launcher
                  .launchUrl(Uri.https('github.com', 'anlijiu/cantool'));
            },
          ),
        ));
  }
}
