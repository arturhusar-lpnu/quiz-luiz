import 'package:fluter_prjcts/Models/match_details.dart';
import './user.dart';

class Game {
  MatchDetails matchDetails;
  String id;
  List<User> users = [];

  Game({required this.matchDetails, required this.id, required this.users});
}