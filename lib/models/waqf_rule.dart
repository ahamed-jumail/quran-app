/// A single stop/pause (waqf) sign, as listed in `assets/jsons/waqf_rules.json`.
class WaqfRule {
  const WaqfRule({
    required this.symbol,
    required this.name,
    required this.arabicName,
    required this.meaning,
    required this.action,
    required this.simpleExplanation,
    this.breath,
  });

  factory WaqfRule.fromJson(Map<String, dynamic> json) {
    return WaqfRule(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      meaning: json['meaning'] as String,
      action: json['action'] as String,
      simpleExplanation: json['simpleExplanation'] as String,
      breath: json['breath'] as String?,
    );
  }

  final String symbol;
  final String name;
  final String arabicName;
  final String meaning;
  final String action;
  final String simpleExplanation;
  final String? breath;
}

/// A beginner-friendly rule of thumb (rule + why), also from the same asset.
class WaqfBeginnerRule {
  const WaqfBeginnerRule({required this.rule, required this.reason});

  factory WaqfBeginnerRule.fromJson(Map<String, dynamic> json) {
    return WaqfBeginnerRule(
      rule: json['rule'] as String,
      reason: json['reason'] as String,
    );
  }

  final String rule;
  final String reason;
}

/// Parsed, display-ready view of `assets/jsons/waqf_rules.json`.
class WaqfRulesData {
  const WaqfRulesData({
    required this.intro,
    required this.importantNote,
    required this.rules,
    required this.beginnerRules,
    required this.mushafVariation,
  });

  factory WaqfRulesData.fromJson(Map<String, dynamic> json) {
    return WaqfRulesData(
      intro: json['intro'] as String,
      importantNote: json['importantNote'] as String,
      rules: (json['rules'] as List<dynamic>)
          .map((dynamic e) => WaqfRule.fromJson(e as Map<String, dynamic>))
          .toList(),
      beginnerRules: (json['commonBeginnerRules'] as List<dynamic>)
          .map((dynamic e) => WaqfBeginnerRule.fromJson(e as Map<String, dynamic>))
          .toList(),
      mushafVariation: json['mushafVariation'] as String,
    );
  }

  final String intro;
  final String importantNote;
  final List<WaqfRule> rules;
  final List<WaqfBeginnerRule> beginnerRules;
  final String mushafVariation;
}
