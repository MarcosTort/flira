import 'package:atlassian_apis/jira_platform.dart';

class JiraRepository {
  const JiraRepository({
    required this.url,
    required this.user,
    required this.token,
  });
  final String url;
  final String user;
  final String token;

  Future<ApiClient> _getApiClient(
    String url,
    String user,
    String token,
  ) async {
    try {
      final uri = '$url.atlassian.net';
      final ApiClient result = ApiClient.basicAuthentication(
        Uri.https(uri, ''),
        user: user,
        apiToken: token,
      );
      return result;
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<JiraPlatformApi> getJiraPlatformApi() async {
    try {
      final client = await _getApiClient(url, user, token);
      return JiraPlatformApi(client);
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }
}
