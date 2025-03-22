// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CheckAuthPage]
class CheckAuthRoute extends PageRouteInfo<void> {
  const CheckAuthRoute({List<PageRouteInfo>? children})
    : super(CheckAuthRoute.name, initialChildren: children);

  static const String name = 'CheckAuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CheckAuthPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [NoteDetailPage]
class NoteDetailRoute extends PageRouteInfo<NoteDetailRouteArgs> {
  NoteDetailRoute({Key? key, NoteEntity? note, List<PageRouteInfo>? children})
    : super(
        NoteDetailRoute.name,
        args: NoteDetailRouteArgs(key: key, note: note),
        initialChildren: children,
      );

  static const String name = 'NoteDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteDetailRouteArgs>(
        orElse: () => const NoteDetailRouteArgs(),
      );
      return NoteDetailPage(key: args.key, note: args.note);
    },
  );
}

class NoteDetailRouteArgs {
  const NoteDetailRouteArgs({this.key, this.note});

  final Key? key;

  final NoteEntity? note;

  @override
  String toString() {
    return 'NoteDetailRouteArgs{key: $key, note: $note}';
  }
}

/// generated route for
/// [NotesPage]
class NotesRoute extends PageRouteInfo<void> {
  const NotesRoute({List<PageRouteInfo>? children})
    : super(NotesRoute.name, initialChildren: children);

  static const String name = 'NotesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotesPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        RegisterRoute.name,
        args: RegisterRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>(
        orElse: () => const RegisterRouteArgs(),
      );
      return RegisterPage(key: args.key);
    },
  );
}

class RegisterRouteArgs {
  const RegisterRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key}';
  }
}
