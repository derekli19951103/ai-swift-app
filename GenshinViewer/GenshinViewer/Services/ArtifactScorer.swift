import Foundation

struct ArtifactScore {
    let totalScore: Double
    let mainStatScore: Double
    let substatScore: Double
    let setMultiplier: Double
    let rating: ScoreRating

    enum ScoreRating: String {
        case perfect = "Perfect"
        case excellent = "Excellent"
        case great = "Great"
        case good = "Good"
        case decent = "Decent"
        case poor = "Poor"

        var color: String {
            switch self {
            case .perfect: return "orange"
            case .excellent: return "purple"
            case .great: return "blue"
            case .good: return "green"
            case .decent: return "yellow"
            case .poor: return "gray"
            }
        }
    }
}

struct ArtifactScorer {

    // MARK: - Substat Weights (universal)
    // Based on roll value relative to CRIT DMG
    static let substatWeights: [String: Double] = [
        "FIGHT_PROP_CRITICAL": 2.0,        // CRIT Rate (worth 2x because half the roll value of CD)
        "FIGHT_PROP_CRITICAL_HURT": 1.0,   // CRIT DMG (baseline)
        "FIGHT_PROP_ATTACK_PERCENT": 0.75, // ATK%
        "FIGHT_PROP_HP_PERCENT": 0.5,      // HP% (valuable for some chars)
        "FIGHT_PROP_DEFENSE_PERCENT": 0.3, // DEF%
        "FIGHT_PROP_CHARGE_EFFICIENCY": 0.5, // Energy Recharge
        "FIGHT_PROP_ELEMENT_MASTERY": 0.5, // Elemental Mastery
        "FIGHT_PROP_ATTACK": 0.1,          // Flat ATK
        "FIGHT_PROP_HP": 0.1,              // Flat HP
        "FIGHT_PROP_DEFENSE": 0.1,         // Flat DEF
    ]

    // Max roll values for substats (at 5-star)
    static let maxSubstatRolls: [String: Double] = [
        "FIGHT_PROP_CRITICAL": 3.89,
        "FIGHT_PROP_CRITICAL_HURT": 7.77,
        "FIGHT_PROP_ATTACK_PERCENT": 5.83,
        "FIGHT_PROP_HP_PERCENT": 5.83,
        "FIGHT_PROP_DEFENSE_PERCENT": 7.29,
        "FIGHT_PROP_CHARGE_EFFICIENCY": 6.48,
        "FIGHT_PROP_ELEMENT_MASTERY": 23.31,
        "FIGHT_PROP_ATTACK": 19.45,
        "FIGHT_PROP_HP": 298.75,
        "FIGHT_PROP_DEFENSE": 23.15,
    ]

    // MARK: - Character-specific substat weights
    static let characterSubstatWeights: [Int: [String: Double]] = [
        // Hu Tao - HP scaling, EM for vape
        10000046: [
            "FIGHT_PROP_CRITICAL": 2.0,
            "FIGHT_PROP_CRITICAL_HURT": 1.0,
            "FIGHT_PROP_HP_PERCENT": 0.9,
            "FIGHT_PROP_ELEMENT_MASTERY": 0.8,
            "FIGHT_PROP_ATTACK_PERCENT": 0.5,
        ],
        // Raiden Shogun - ER and ATK
        10000052: [
            "FIGHT_PROP_CRITICAL": 2.0,
            "FIGHT_PROP_CRITICAL_HURT": 1.0,
            "FIGHT_PROP_ATTACK_PERCENT": 0.8,
            "FIGHT_PROP_CHARGE_EFFICIENCY": 0.7,
        ],
        // Zhongli - HP for shields
        10000030: [
            "FIGHT_PROP_HP_PERCENT": 1.0,
            "FIGHT_PROP_CRITICAL": 1.5,
            "FIGHT_PROP_CRITICAL_HURT": 0.75,
        ],
        // Kokomi - HP, no crit
        10000054: [
            "FIGHT_PROP_HP_PERCENT": 1.0,
            "FIGHT_PROP_CHARGE_EFFICIENCY": 0.8,
            "FIGHT_PROP_ELEMENT_MASTERY": 0.5,
            "FIGHT_PROP_CRITICAL": 0.0,
            "FIGHT_PROP_CRITICAL_HURT": 0.0,
        ],
        // Nahida - EM scaling
        10000073: [
            "FIGHT_PROP_CRITICAL": 2.0,
            "FIGHT_PROP_CRITICAL_HURT": 1.0,
            "FIGHT_PROP_ELEMENT_MASTERY": 0.9,
        ],
        // Yelan - HP scaling
        10000060: [
            "FIGHT_PROP_CRITICAL": 2.0,
            "FIGHT_PROP_CRITICAL_HURT": 1.0,
            "FIGHT_PROP_HP_PERCENT": 0.9,
            "FIGHT_PROP_CHARGE_EFFICIENCY": 0.6,
        ],
        // Furina - HP scaling
        10000089: [
            "FIGHT_PROP_CRITICAL": 2.0,
            "FIGHT_PROP_CRITICAL_HURT": 1.0,
            "FIGHT_PROP_HP_PERCENT": 1.0,
            "FIGHT_PROP_CHARGE_EFFICIENCY": 0.6,
        ],
        // Neuvillette - HP scaling
        10000087: [
            "FIGHT_PROP_CRITICAL": 2.0,
            "FIGHT_PROP_CRITICAL_HURT": 1.0,
            "FIGHT_PROP_HP_PERCENT": 0.9,
            "FIGHT_PROP_CHARGE_EFFICIENCY": 0.5,
        ],
    ]

    // MARK: - Ideal Main Stats by Slot
    // Flower always HP, Plume always ATK - skip those
    static let idealMainStats: [Int: [ArtifactType: [String]]] = [
        // Default DPS
        0: [
            .sands: ["FIGHT_PROP_ATTACK_PERCENT"],
            .goblet: ["FIGHT_PROP_FIRE_ADD_HURT", "FIGHT_PROP_WATER_ADD_HURT", "FIGHT_PROP_ELEC_ADD_HURT",
                     "FIGHT_PROP_ICE_ADD_HURT", "FIGHT_PROP_WIND_ADD_HURT", "FIGHT_PROP_ROCK_ADD_HURT",
                     "FIGHT_PROP_GRASS_ADD_HURT", "FIGHT_PROP_PHYSICAL_ADD_HURT"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
        // Hu Tao - HP sands
        10000046: [
            .sands: ["FIGHT_PROP_HP_PERCENT", "FIGHT_PROP_ELEMENT_MASTERY"],
            .goblet: ["FIGHT_PROP_FIRE_ADD_HURT"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
        // Raiden - ER or ATK sands
        10000052: [
            .sands: ["FIGHT_PROP_CHARGE_EFFICIENCY", "FIGHT_PROP_ATTACK_PERCENT"],
            .goblet: ["FIGHT_PROP_ELEC_ADD_HURT", "FIGHT_PROP_ATTACK_PERCENT"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
        // Zhongli - HP everything for shield
        10000030: [
            .sands: ["FIGHT_PROP_HP_PERCENT"],
            .goblet: ["FIGHT_PROP_HP_PERCENT", "FIGHT_PROP_ROCK_ADD_HURT"],
            .circlet: ["FIGHT_PROP_HP_PERCENT", "FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
        // Kokomi - HP
        10000054: [
            .sands: ["FIGHT_PROP_HP_PERCENT", "FIGHT_PROP_CHARGE_EFFICIENCY"],
            .goblet: ["FIGHT_PROP_HP_PERCENT", "FIGHT_PROP_WATER_ADD_HURT"],
            .circlet: ["FIGHT_PROP_HEAL_ADD"],
        ],
        // Nahida - EM
        10000073: [
            .sands: ["FIGHT_PROP_ELEMENT_MASTERY"],
            .goblet: ["FIGHT_PROP_GRASS_ADD_HURT", "FIGHT_PROP_ELEMENT_MASTERY"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT", "FIGHT_PROP_ELEMENT_MASTERY"],
        ],
        // Yelan - HP
        10000060: [
            .sands: ["FIGHT_PROP_HP_PERCENT"],
            .goblet: ["FIGHT_PROP_WATER_ADD_HURT"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
        // Furina - HP
        10000089: [
            .sands: ["FIGHT_PROP_HP_PERCENT"],
            .goblet: ["FIGHT_PROP_HP_PERCENT"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
        // Neuvillette - HP
        10000087: [
            .sands: ["FIGHT_PROP_HP_PERCENT"],
            .goblet: ["FIGHT_PROP_WATER_ADD_HURT"],
            .circlet: ["FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT"],
        ],
    ]

    // MARK: - Best-in-Slot Artifact Sets (by set name hash patterns)
    // Key: character ID, Value: [BiS set names, alternate set names]
    static let characterBiSSets: [Int: (bis: [String], alternates: [String])] = [
        10000046: (bis: ["Crimson Witch", "4144069251"], alternates: ["Shimenawa", "2276480763"]), // Hu Tao
        10000052: (bis: ["Emblem", "1524173875"], alternates: ["Gladiator", "1541919827"]), // Raiden
        10000030: (bis: ["Tenacity", "1756609915"], alternates: ["Archaic Petra", "1541919827"]), // Zhongli
        10000054: (bis: ["Ocean-Hued", "3626268211"], alternates: ["Tenacity", "1756609915"]), // Kokomi
        10000073: (bis: ["Deepwood", "4144069251"], alternates: ["Gilded Dreams", "2276480763"]), // Nahida
        10000060: (bis: ["Emblem", "1524173875"], alternates: ["Tenacity", "1756609915"]), // Yelan
        10000089: (bis: ["Golden Troupe", "2538235187"], alternates: ["Tenacity", "1756609915"]), // Furina
        10000087: (bis: ["Marechaussee", "1249831867"], alternates: ["Wanderer", "1541919827"]), // Neuvillette
        10000047: (bis: ["Viridescent", "4144069251"], alternates: ["Gilded Dreams", "2276480763"]), // Kazuha
        10000002: (bis: ["Blizzard", "933076627"], alternates: ["Gladiator", "1541919827"]), // Ayaka
    ]

    // MARK: - Score Calculation

    static func scoreArtifact(
        artifact: ArtifactDisplay,
        characterId: Int,
        artifactType: ArtifactType
    ) -> ArtifactScore {
        let mainStatScore = calculateMainStatScore(
            mainStat: artifact.mainStat.name,
            mainStatPropId: getMainStatPropId(artifact.mainStat.name),
            artifactType: artifactType,
            characterId: characterId
        )

        let substatScore = calculateSubstatScore(
            substats: artifact.subStats,
            characterId: characterId,
            rarity: artifact.rarity,
            level: artifact.level
        )

        let setMultiplier = calculateSetMultiplier(
            setName: artifact.setName,
            characterId: characterId
        )

        // Formula: (Main + Substat) * Set Multiplier * 50
        let rawScore = (mainStatScore + substatScore) * setMultiplier * 50
        let rating = getRating(score: rawScore, artifactType: artifactType)

        return ArtifactScore(
            totalScore: rawScore,
            mainStatScore: mainStatScore,
            substatScore: substatScore,
            setMultiplier: setMultiplier,
            rating: rating
        )
    }

    private static func calculateMainStatScore(
        mainStat: String,
        mainStatPropId: String,
        artifactType: ArtifactType,
        characterId: Int
    ) -> Double {
        // Flower and Plume have fixed main stats - always score 1.0
        if artifactType == .flower || artifactType == .plume {
            return 1.0
        }

        // Get ideal main stats for this character and slot
        let idealStats = idealMainStats[characterId] ?? idealMainStats[0]!
        guard let slotIdealStats = idealStats[artifactType] else {
            return 0.5 // Unknown slot
        }

        // Check if main stat matches ideal
        if slotIdealStats.contains(mainStatPropId) {
            return 1.0
        }

        // Partial credit for useful but not ideal stats
        let usefulStats = ["FIGHT_PROP_ATTACK_PERCENT", "FIGHT_PROP_HP_PERCENT",
                          "FIGHT_PROP_CHARGE_EFFICIENCY", "FIGHT_PROP_ELEMENT_MASTERY"]
        if usefulStats.contains(mainStatPropId) {
            return 0.5
        }

        return 0.2 // Wrong main stat
    }

    private static func calculateSubstatScore(
        substats: [StatDisplay],
        characterId: Int,
        rarity: Int,
        level: Int
    ) -> Double {
        let weights = characterSubstatWeights[characterId] ?? substatWeights
        var totalScore = 0.0

        for substat in substats {
            let propId = getSubstatPropId(substat.name)
            let weight = weights[propId] ?? substatWeights[propId] ?? 0.1

            // Parse the value
            let value = parseStatValue(substat.value)

            // Get max possible roll value
            let maxRoll = maxSubstatRolls[propId] ?? 1.0

            // Calculate how many "good rolls" this represents
            // A +20 artifact has 5 total substat upgrades (initial 4 + 5 rolls)
            // Score based on roll efficiency
            let rollEfficiency = value / (maxRoll * 6) // 6 max rolls possible (initial + 5)

            totalScore += rollEfficiency * weight
        }

        // Normalize: 4 substats with perfect rolls = 1.0
        // With typical weights, max would be around 4.0 for perfect artifact
        return min(totalScore / 2.0, 1.5) // Cap at 1.5 for exceptional artifacts
    }

    private static func calculateSetMultiplier(
        setName: String,
        characterId: Int
    ) -> Double {
        guard let sets = characterBiSSets[characterId] else {
            return 0.9 // Unknown character, slight penalty
        }

        // Check BiS
        for bis in sets.bis {
            if setName.contains(bis) || setName == bis {
                return 1.0
            }
        }

        // Check alternates
        for alt in sets.alternates {
            if setName.contains(alt) || setName == alt {
                return 0.8
            }
        }

        // Rainbow/off-set piece - some value but not ideal
        return 0.6
    }

    private static func getRating(score: Double, artifactType: ArtifactType) -> ArtifactScore.ScoreRating {
        // Adjust thresholds based on artifact type
        // Flower/Plume easier to get good rolls, others harder
        let isFixed = artifactType == .flower || artifactType == .plume

        if isFixed {
            if score >= 50 { return .perfect }
            if score >= 40 { return .excellent }
            if score >= 30 { return .great }
            if score >= 20 { return .good }
            if score >= 10 { return .decent }
            return .poor
        } else {
            if score >= 45 { return .perfect }
            if score >= 35 { return .excellent }
            if score >= 25 { return .great }
            if score >= 15 { return .good }
            if score >= 8 { return .decent }
            return .poor
        }
    }

    // MARK: - Helpers

    private static func getMainStatPropId(_ statName: String) -> String {
        let mapping: [String: String] = [
            "HP": "FIGHT_PROP_HP",
            "HP%": "FIGHT_PROP_HP_PERCENT",
            "ATK": "FIGHT_PROP_ATTACK",
            "ATK%": "FIGHT_PROP_ATTACK_PERCENT",
            "DEF": "FIGHT_PROP_DEFENSE",
            "DEF%": "FIGHT_PROP_DEFENSE_PERCENT",
            "CRIT Rate": "FIGHT_PROP_CRITICAL",
            "CRIT DMG": "FIGHT_PROP_CRITICAL_HURT",
            "Energy Recharge": "FIGHT_PROP_CHARGE_EFFICIENCY",
            "Elemental Mastery": "FIGHT_PROP_ELEMENT_MASTERY",
            "Healing Bonus": "FIGHT_PROP_HEAL_ADD",
            "Pyro DMG Bonus": "FIGHT_PROP_FIRE_ADD_HURT",
            "Hydro DMG Bonus": "FIGHT_PROP_WATER_ADD_HURT",
            "Electro DMG Bonus": "FIGHT_PROP_ELEC_ADD_HURT",
            "Cryo DMG Bonus": "FIGHT_PROP_ICE_ADD_HURT",
            "Anemo DMG Bonus": "FIGHT_PROP_WIND_ADD_HURT",
            "Geo DMG Bonus": "FIGHT_PROP_ROCK_ADD_HURT",
            "Dendro DMG Bonus": "FIGHT_PROP_GRASS_ADD_HURT",
            "Physical DMG Bonus": "FIGHT_PROP_PHYSICAL_ADD_HURT",
        ]
        return mapping[statName] ?? statName
    }

    private static func getSubstatPropId(_ statName: String) -> String {
        return getMainStatPropId(statName)
    }

    private static func parseStatValue(_ value: String) -> Double {
        // Remove % and parse
        let cleaned = value.replacingOccurrences(of: "%", with: "")
                          .replacingOccurrences(of: ",", with: "")
        return Double(cleaned) ?? 0
    }
}
