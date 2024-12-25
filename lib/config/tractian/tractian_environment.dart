class TractianEnvironment {
  final String apiUrl;

  TractianEnvironment()
      : apiUrl = String.fromEnvironment(
          'TRACTIAN_API_URL',
          defaultValue: 'https://fake-api.tractian.com',
        );
}
