// Unified Fighter model used across engines, services, and widgets.

import 'package:flutter/foundation.dart';

class Fighter {
  final String id;
  String name;
  String weightClass;

  // Nested stats/state for clarity
  final FighterStats stats;
  final FighterState state;
  final FighterRecord record;
  final CareerStats careerStats;

  int popularity;
  bool retired;
  double money;
  List<String> beltIds;

  Fighter({
    required this.id,
    required this.name,
    required this.weightClass,
    required this.stats,
    required this.state,
    required this.record,
    required this.careerStats,
    this.popularity = 50,
    this.retired = false,
    this.money = 0.0,
    List<String>? beltIds,
  }) : beltIds = beltIds ?? [];

  // Convenience getters
  int get wins => record.wins;
  int get losses => record.losses;
  int get draws => record.draws;

  // Serialization for DB (basic fields only; nested objects kept minimal defaults)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weightClass': weightClass,
      'popularity': popularity,
      'money': money,
      'wins': record.wins,
      'losses': record.losses,
      'draws': record.draws,
      // store belts as comma-separated string for simplicity
      'beltIds': beltIds.join(','),
      // store stats and state minimal values
      'power': stats.power,
      'speed': stats.speed,
      'accuracy': stats.accuracy,
      'defense': stats.defense,
      'stamina': stats.stamina,
      'maxHealth': stats.maxHealth,
      'health': state.health,
      'fatigue': state.fatigue,
    };
  }

  factory Fighter.fromMap(Map<String, dynamic> m) {
    return Fighter(
      id: m['id']?.toString() ?? '',
      name: m['name']?.toString() ?? '',
      weightClass: m['weightClass']?.toString() ?? 'Unknown',
      popularity: (m['popularity'] is int) ? m['popularity'] as int : int.tryParse(m['popularity']?.toString() ?? '') ?? 50,
      money: (m['money'] is num) ? (m['money'] as num).toDouble() : double.tryParse(m['money']?.toString() ?? '') ?? 0.0,
      stats: FighterStats(
        power: (m['power'] is int) ? m['power'] as int : int.tryParse(m['power']?.toString() ?? '') ?? 50,
        speed: (m['speed'] is int) ? m['speed'] as int : int.tryParse(m['speed']?.toString() ?? '') ?? 50,
        accuracy: (m['accuracy'] is int) ? m['accuracy'] as int : int.tryParse(m['accuracy']?.toString() ?? '') ?? 50,
        defense: (m['defense'] is int) ? m['defense'] as int : int.tryParse(m['defense']?.toString() ?? '') ?? 50,
        stamina: (m['stamina'] is int) ? m['stamina'] as int : int.tryParse(m['stamina']?.toString() ?? '') ?? 50,
        maxHealth: (m['maxHealth'] is int) ? m['maxHealth'] as int : int.tryParse(m['maxHealth']?.toString() ?? '') ?? 100,
      ),
      state: FighterState(
        health: (m['health'] is int) ? m['health'] as int : int.tryParse(m['health']?.toString() ?? '') ?? 100,
        fatigue: (m['fatigue'] is int) ? m['fatigue'] as int : int.tryParse(m['fatigue']?.toString() ?? '') ?? 0,
      ),
      record: FighterRecord(
        wins: (m['wins'] is int) ? m['wins'] as int : int.tryParse(m['wins']?.toString() ?? '') ?? 0,
        losses: (m['losses'] is int) ? m['losses'] as int : int.tryParse(m['losses']?.toString() ?? '') ?? 0,
        draws: (m['draws'] is int) ? m['draws'] as int : int.tryParse(m['draws']?.toString() ?? '') ?? 0,
      ),
      careerStats: CareerStats(
        totalEarnings: 0,
        knockouts: 0,
        legacyScore: 0,
        careerDamage: 0,
        totalDamageTaken: 0,
        severeHitsTaken: 0,
      ),
      beltIds: (m['beltIds']?.toString().isNotEmpty == true) ? m['beltIds'].toString().split(',') : <String>[],
    );
  }

  @override
  String toString() => 'Fighter($id, $name)';
}

class FighterStats {
  final int power;
  final int speed;
  final int accuracy;
  final int defense;
  final int stamina;
  final int maxHealth;

  const FighterStats({
    required this.power,
    required this.speed,
    required this.accuracy,
    required this.defense,
    required this.stamina,
    required this.maxHealth,
  });
}

class FighterState {
  int health;
  int fatigue;
  int knockdownsThisRound;

  FighterState({
    required this.health,
    this.fatigue = 0,
    this.knockdownsThisRound = 0,
  });

  void resetRound() {
    knockdownsThisRound = 0;
  }
}

class FighterRecord {
  int wins;
  int losses;
  int draws;

  FighterRecord({
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
  });
}

class CareerStats {
  int totalEarnings;
  int knockouts;
  int legacyScore;
  int careerDamage;
  int totalDamageTaken;
  int severeHitsTaken;

  CareerStats({
    this.totalEarnings = 0,
    this.knockouts = 0,
    this.legacyScore = 0,
    this.careerDamage = 0,
    this.totalDamageTaken = 0,
    this.severeHitsTaken = 0,
  });
}
