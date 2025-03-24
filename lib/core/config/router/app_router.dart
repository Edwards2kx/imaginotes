import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:imaginotes/features/auth/ui/pages/check_auth_page.dart';
import 'package:imaginotes/features/auth/ui/pages/create_account_page.dart';
import 'package:imaginotes/features/auth/ui/pages/login_page.dart';
import 'package:imaginotes/features/notes/ui/pages/note_detail_page.dart';
import 'package:imaginotes/features/notes/ui/pages/notes_page.dart';
import 'package:imaginotes/features/notes/ui/pages/search_notes_page.dart';

import '../../../features/notes/domain/entities/note_entity.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CheckAuthRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page, initial: false),
    AutoRoute(page: NotesRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: NoteDetailRoute.page),
    AutoRoute(page: SearchRoute.page),
  ];
}
