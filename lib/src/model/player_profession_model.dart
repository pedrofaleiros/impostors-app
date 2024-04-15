class PlayerProfessionModel {
  final String playerId;
  final String username;
  final String? profession;
  final bool isImpostor;

  PlayerProfessionModel({
    required this.playerId,
    required this.username,
    required this.profession,
    required this.isImpostor,
  });
}
