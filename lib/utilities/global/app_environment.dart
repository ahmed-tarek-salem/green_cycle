/// Which backend the whole app talks to.
///
/// Flip [appEnvironment] in `main()` to point every API call at either the
/// production server or the staging/dev server. Nothing else needs to change —
/// every endpoint in `AppEndpoints` derives its base URL from here.
enum AppEnvironment {
  /// Production backend.
  prod('https://green-cycle-juiq.onrender.com/api/v1/'),

  /// Staging / dev backend.
  dev('http://98.92.252.75/api/v1/');

  const AppEnvironment(this.baseUrl);

  /// Root URL that every endpoint is appended to. Includes the trailing slash.
  final String baseUrl;
}

/// Global, hardcoded environment switch.
///
/// Change this single value (ideally from `main()`) to move the whole app
/// between [AppEnvironment.prod] and [AppEnvironment.dev].
AppEnvironment appEnvironment = AppEnvironment.prod;
