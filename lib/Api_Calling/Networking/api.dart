import 'package:dp_matka_3/App_Utils/app_utils.dart';

class ApiUrls {
  static final String baseUrl = apiLinkUrl.isNotEmpty
      ? apiLinkUrl
      : "https://mysattamatka.codetrick.in/admin/";

  static const String login = "api/login.php";
  static const String signup = "api/register2.php";
  static const String changePassword = "api/password.php";

  static const String home = "api/home.php";
  static const String getConfig = "api/get_config.php";
  static const String upiPayment = "api/upi_payment.php";
  static const String getPayment = "api/get_payment.php";
  static const String games = "api/games.php";

  static const String gamesRate = "api/rate.php";
  static const String bet = "api/bet.php";
  static const String sangam = "api/sangam.php";

  static const String gameData = "api/games.php";
  static const String transaction = "api/transaction.php";
  static const String winningHistory = "api/gameledger.php";

  static const String withdraw = "api/withdraw_request.php";
  static const String profile = "api/profile.php";

  static const String howToPlay = "api/content.php";

  //starline
  static const String marketListStarline = "api/market_list_starline.php";
  static const String starlineTiming = "api/starline_timings.php";
  static const String getChart = "api/chart/getChart.php";
  static const String mainChart = "/api/chart2/getChart.php";

  // Gali Disawar

  static const String getGalidisawerGameRate =
      "api/get_galidisawer_game_rate.php";
  static const String galidisawerBidHistory = "api/galidisawer_bid_history.php";
  static const String galidisawerWinHistory =
      "api/get_galidisawer_win_history.php";
  static const String getDissawerGame = "api/get_dissawer_game.php";
  static const String addGalidisawerBid = "api/add_galidisawer_bid.php";
  static const String placeBidGalidsawer = "api/place_bid_galidsawer.php";
  static const String deleteGalidisawer = "api/delete_galidisawer.php";
  static const String getGalidisawerBet = "api/get_galidisawer_bet.php";
}
