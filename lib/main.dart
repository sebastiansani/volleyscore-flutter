// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/homePage.dart';
import 'package:volleyscore/storage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlayerMatchesStorage(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        // magic to unfocus text fields when tapping outside
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Volleyscore',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
