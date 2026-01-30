import Foundation

struct GenshinDataMapper {
    // Character ID to Name mapping (common characters)
    static let characterNames: [Int: String] = [
        10000002: "Kamisato Ayaka",
        10000003: "Jean",
        10000005: "Traveler",
        10000006: "Lisa",
        10000007: "Traveler",
        10000014: "Barbara",
        10000015: "Kaeya",
        10000016: "Diluc",
        10000020: "Razor",
        10000021: "Amber",
        10000022: "Venti",
        10000023: "Xiangling",
        10000024: "Beidou",
        10000025: "Xingqiu",
        10000026: "Xiao",
        10000027: "Ningguang",
        10000029: "Klee",
        10000030: "Zhongli",
        10000031: "Fischl",
        10000032: "Bennett",
        10000033: "Tartaglia",
        10000034: "Noelle",
        10000035: "Qiqi",
        10000036: "Chongyun",
        10000037: "Ganyu",
        10000038: "Albedo",
        10000039: "Diona",
        10000041: "Mona",
        10000042: "Keqing",
        10000043: "Sucrose",
        10000044: "Xinyan",
        10000045: "Rosaria",
        10000046: "Hu Tao",
        10000047: "Kaedehara Kazuha",
        10000048: "Yanfei",
        10000049: "Yoimiya",
        10000050: "Thoma",
        10000051: "Eula",
        10000052: "Raiden Shogun",
        10000053: "Sayu",
        10000054: "Sangonomiya Kokomi",
        10000055: "Gorou",
        10000056: "Sara",
        10000057: "Arataki Itto",
        10000058: "Yae Miko",
        10000059: "Shikanoin Heizou",
        10000060: "Yelan",
        10000062: "Aloy",
        10000063: "Shenhe",
        10000064: "Yun Jin",
        10000065: "Kuki Shinobu",
        10000066: "Kamisato Ayato",
        10000067: "Collei",
        10000068: "Dori",
        10000069: "Tighnari",
        10000070: "Nilou",
        10000071: "Cyno",
        10000072: "Candace",
        10000073: "Nahida",
        10000074: "Layla",
        10000075: "Wanderer",
        10000076: "Faruzan",
        10000077: "Yaoyao",
        10000078: "Alhaitham",
        10000079: "Dehya",
        10000080: "Mika",
        10000081: "Kaveh",
        10000082: "Baizhu",
        10000083: "Lynette",
        10000084: "Lyney",
        10000085: "Freminet",
        10000086: "Wriothesley",
        10000087: "Neuvillette",
        10000088: "Charlotte",
        10000089: "Furina",
        10000090: "Chevreuse",
        10000091: "Navia",
        10000092: "Gaming",
        10000093: "Xianyun",
        10000094: "Chiori",
        10000095: "Sigewinne",
        10000096: "Arlecchino",
        10000097: "Sethos",
        10000098: "Clorinde",
        10000099: "Emilie",
        10000100: "Kachina",
        10000101: "Kinich",
        10000102: "Mualani",
        10000103: "Xilonen",
        10000104: "Chasca",
        10000105: "Ororon",
        10000106: "Mavuika",
        10000107: "Citlali",
        10000108: "Lan Yan",
    ]

    // Character element mapping
    static let characterElements: [Int: String] = [
        10000002: "Cryo",
        10000003: "Anemo",
        10000006: "Electro",
        10000014: "Hydro",
        10000015: "Cryo",
        10000016: "Pyro",
        10000020: "Electro",
        10000021: "Pyro",
        10000022: "Anemo",
        10000023: "Pyro",
        10000024: "Electro",
        10000025: "Hydro",
        10000026: "Anemo",
        10000027: "Geo",
        10000029: "Pyro",
        10000030: "Geo",
        10000031: "Electro",
        10000032: "Pyro",
        10000033: "Hydro",
        10000034: "Geo",
        10000035: "Cryo",
        10000036: "Cryo",
        10000037: "Cryo",
        10000038: "Geo",
        10000039: "Cryo",
        10000041: "Hydro",
        10000042: "Electro",
        10000043: "Anemo",
        10000044: "Pyro",
        10000045: "Cryo",
        10000046: "Pyro",
        10000047: "Anemo",
        10000048: "Pyro",
        10000049: "Pyro",
        10000050: "Pyro",
        10000051: "Cryo",
        10000052: "Electro",
        10000053: "Anemo",
        10000054: "Hydro",
        10000055: "Geo",
        10000056: "Electro",
        10000057: "Geo",
        10000058: "Electro",
        10000059: "Anemo",
        10000060: "Hydro",
        10000062: "Cryo",
        10000063: "Cryo",
        10000064: "Geo",
        10000065: "Electro",
        10000066: "Hydro",
        10000067: "Dendro",
        10000068: "Electro",
        10000069: "Dendro",
        10000070: "Hydro",
        10000071: "Electro",
        10000072: "Hydro",
        10000073: "Dendro",
        10000074: "Cryo",
        10000075: "Anemo",
        10000076: "Anemo",
        10000077: "Dendro",
        10000078: "Dendro",
        10000079: "Pyro",
        10000080: "Cryo",
        10000081: "Dendro",
        10000082: "Dendro",
        10000083: "Anemo",
        10000084: "Pyro",
        10000085: "Cryo",
        10000086: "Cryo",
        10000087: "Hydro",
        10000088: "Cryo",
        10000089: "Hydro",
        10000090: "Pyro",
        10000091: "Geo",
        10000092: "Pyro",
        10000093: "Anemo",
        10000094: "Geo",
        10000095: "Hydro",
        10000096: "Pyro",
        10000097: "Electro",
        10000098: "Electro",
        10000099: "Dendro",
        10000100: "Geo",
        10000101: "Dendro",
        10000102: "Hydro",
        10000103: "Geo",
        10000104: "Anemo",
        10000105: "Electro",
        10000106: "Pyro",
        10000107: "Cryo",
        10000108: "Anemo",
    ]

    // Character rarity
    static let characterRarity: [Int: Int] = [
        10000002: 5, 10000003: 5, 10000005: 5, 10000006: 4, 10000007: 5,
        10000014: 4, 10000015: 4, 10000016: 5, 10000020: 4, 10000021: 4,
        10000022: 5, 10000023: 4, 10000024: 4, 10000025: 4, 10000026: 5,
        10000027: 4, 10000029: 5, 10000030: 5, 10000031: 4, 10000032: 4,
        10000033: 5, 10000034: 4, 10000035: 5, 10000036: 4, 10000037: 5,
        10000038: 5, 10000039: 4, 10000041: 5, 10000042: 5, 10000043: 4,
        10000044: 4, 10000045: 4, 10000046: 5, 10000047: 5, 10000048: 4,
        10000049: 5, 10000050: 4, 10000051: 5, 10000052: 5, 10000053: 4,
        10000054: 5, 10000055: 4, 10000056: 4, 10000057: 5, 10000058: 5,
        10000059: 4, 10000060: 5, 10000062: 5, 10000063: 5, 10000064: 4,
        10000065: 4, 10000066: 5, 10000067: 4, 10000068: 4, 10000069: 5,
        10000070: 5, 10000071: 5, 10000072: 4, 10000073: 5, 10000074: 4,
        10000075: 5, 10000076: 4, 10000077: 4, 10000078: 5, 10000079: 5,
        10000080: 4, 10000081: 4, 10000082: 5, 10000083: 4, 10000084: 5,
        10000085: 4, 10000086: 5, 10000087: 5, 10000088: 4, 10000089: 5,
        10000090: 4, 10000091: 5, 10000092: 4, 10000093: 5, 10000094: 5,
        10000095: 5, 10000096: 5, 10000097: 4, 10000098: 5, 10000099: 5,
        10000100: 4, 10000101: 5, 10000102: 5, 10000103: 5, 10000104: 5,
        10000105: 4, 10000106: 5, 10000107: 5, 10000108: 4,
    ]

    // Stat property mappings
    static let statNames: [String: String] = [
        "FIGHT_PROP_HP": "HP",
        "FIGHT_PROP_HP_PERCENT": "HP%",
        "FIGHT_PROP_ATTACK": "ATK",
        "FIGHT_PROP_ATTACK_PERCENT": "ATK%",
        "FIGHT_PROP_DEFENSE": "DEF",
        "FIGHT_PROP_DEFENSE_PERCENT": "DEF%",
        "FIGHT_PROP_CRITICAL": "CRIT Rate",
        "FIGHT_PROP_CRITICAL_HURT": "CRIT DMG",
        "FIGHT_PROP_CHARGE_EFFICIENCY": "Energy Recharge",
        "FIGHT_PROP_HEAL_ADD": "Healing Bonus",
        "FIGHT_PROP_ELEMENT_MASTERY": "Elemental Mastery",
        "FIGHT_PROP_PHYSICAL_ADD_HURT": "Physical DMG Bonus",
        "FIGHT_PROP_FIRE_ADD_HURT": "Pyro DMG Bonus",
        "FIGHT_PROP_WATER_ADD_HURT": "Hydro DMG Bonus",
        "FIGHT_PROP_ELEC_ADD_HURT": "Electro DMG Bonus",
        "FIGHT_PROP_ICE_ADD_HURT": "Cryo DMG Bonus",
        "FIGHT_PROP_WIND_ADD_HURT": "Anemo DMG Bonus",
        "FIGHT_PROP_ROCK_ADD_HURT": "Geo DMG Bonus",
        "FIGHT_PROP_GRASS_ADD_HURT": "Dendro DMG Bonus",
        "FIGHT_PROP_BASE_HP": "Base HP",
        "FIGHT_PROP_BASE_ATTACK": "Base ATK",
        "FIGHT_PROP_BASE_DEFENSE": "Base DEF",
    ]

    // Fight prop map keys (numeric)
    static let fightPropKeys: [String: String] = [
        "1": "Base HP",
        "2": "HP",
        "3": "HP%",
        "4": "Base ATK",
        "5": "ATK",
        "6": "ATK%",
        "7": "Base DEF",
        "8": "DEF",
        "9": "DEF%",
        "20": "CRIT Rate",
        "22": "CRIT DMG",
        "23": "Energy Recharge",
        "26": "Healing Bonus",
        "27": "Incoming Healing Bonus",
        "28": "Elemental Mastery",
        "29": "Physical RES",
        "30": "Physical DMG Bonus",
        "40": "Pyro DMG Bonus",
        "41": "Electro DMG Bonus",
        "42": "Hydro DMG Bonus",
        "43": "Dendro DMG Bonus",
        "44": "Anemo DMG Bonus",
        "45": "Geo DMG Bonus",
        "46": "Cryo DMG Bonus",
        "2000": "Max HP",
        "2001": "ATK",
        "2002": "DEF",
    ]

    static func mapToCharacterDisplay(_ avatar: AvatarInfo) -> CharacterDisplay {
        let avatarId = avatar.avatarId
        let name = characterNames[avatarId] ?? "Unknown Character"
        let element = characterElements[avatarId] ?? "Unknown"
        let rarity = characterRarity[avatarId] ?? 4

        // Get level from propMap (key "4001" is level)
        let level = Int(avatar.propMap?["4001"]?.val ?? "1") ?? 1

        // Get friendship level
        let friendship = avatar.fetterInfo?.expLevel ?? 1

        // Get constellation count
        let constellation = avatar.talentIdList?.count ?? 0

        // Parse equipment
        var weapon: WeaponDisplay?
        var artifacts: [ArtifactDisplay] = []

        if let equipList = avatar.equipList {
            for equip in equipList {
                if equip.flat.itemType == "ITEM_WEAPON" {
                    weapon = mapToWeaponDisplay(equip)
                } else if equip.flat.itemType == "ITEM_RELIQUARY" {
                    if var artifact = mapToArtifactDisplay(equip) {
                        // Calculate artifact score
                        let score = ArtifactScorer.scoreArtifact(
                            artifact: artifact,
                            characterId: avatarId,
                            artifactType: artifact.type
                        )
                        artifact.score = score
                        artifacts.append(artifact)
                    }
                }
            }
        }

        // Parse stats
        let stats = parseCharacterStats(avatar.fightPropMap)

        let iconURL = URL(string: "https://enka.network/ui/UI_AvatarIcon_\(getCharacterIconName(avatarId)).png")

        return CharacterDisplay(
            id: avatarId,
            name: name,
            level: level,
            element: element,
            rarity: rarity,
            iconURL: iconURL,
            friendship: friendship,
            constellation: constellation,
            weapon: weapon,
            artifacts: artifacts,
            stats: stats
        )
    }

    static func mapToWeaponDisplay(_ equip: Equipment) -> WeaponDisplay {
        let weaponData = equip.weapon
        let flat = equip.flat

        let level = weaponData?.level ?? 1
        let refinement = (weaponData?.affixMap?.values.first ?? 0) + 1

        var mainStat = ""
        var subStat: String?

        if let weaponStats = flat.weaponStats {
            for (index, stat) in weaponStats.enumerated() {
                let statName = statNames[stat.appendPropId] ?? stat.appendPropId
                let value = formatStatValue(stat.appendPropId, stat.statValue)
                if index == 0 {
                    mainStat = "\(statName): \(value)"
                } else {
                    subStat = "\(statName): \(value)"
                }
            }
        }

        let iconURL = URL(string: "https://enka.network/ui/\(flat.icon).png")

        return WeaponDisplay(
            id: equip.itemId,
            name: flat.nameTextMapHash,
            level: level,
            refinement: refinement,
            rarity: flat.rankLevel,
            iconURL: iconURL,
            mainStat: mainStat,
            subStat: subStat
        )
    }

    static func mapToArtifactDisplay(_ equip: Equipment) -> ArtifactDisplay? {
        let reliquary = equip.reliquary
        let flat = equip.flat

        guard let equipType = flat.equipType,
              let artifactType = ArtifactType(rawValue: equipType) else {
            return nil
        }

        let level = (reliquary?.level ?? 1) - 1

        var mainStat = StatDisplay(name: "Unknown", value: "0")
        if let mainStatData = flat.reliquaryMainstat {
            let statName = statNames[mainStatData.mainPropId] ?? mainStatData.mainPropId
            let value = formatStatValue(mainStatData.mainPropId, mainStatData.statValue)
            mainStat = StatDisplay(name: statName, value: value)
        }

        var subStats: [StatDisplay] = []
        if let subStatsData = flat.reliquarySubstats {
            for sub in subStatsData {
                let statName = statNames[sub.appendPropId] ?? sub.appendPropId
                let value = formatStatValue(sub.appendPropId, sub.statValue)
                subStats.append(StatDisplay(name: statName, value: value))
            }
        }

        let iconURL = URL(string: "https://enka.network/ui/\(flat.icon).png")

        return ArtifactDisplay(
            id: equip.flat.nameTextMapHash,
            name: flat.nameTextMapHash,
            setName: flat.setNameTextMapHash ?? "Unknown Set",
            type: artifactType,
            level: level,
            rarity: flat.rankLevel,
            iconURL: iconURL,
            mainStat: mainStat,
            subStats: subStats
        )
    }

    static func parseCharacterStats(_ fightPropMap: [String: Double]?) -> CharacterStats {
        guard let props = fightPropMap else {
            return CharacterStats(hp: 0, atk: 0, def: 0, critRate: 0, critDmg: 0, energyRecharge: 0, elementalMastery: 0)
        }

        return CharacterStats(
            hp: props["2000"] ?? 0,
            atk: props["2001"] ?? 0,
            def: props["2002"] ?? 0,
            critRate: (props["20"] ?? 0) * 100,
            critDmg: (props["22"] ?? 0) * 100,
            energyRecharge: (props["23"] ?? 1) * 100,
            elementalMastery: props["28"] ?? 0
        )
    }

    static func formatStatValue(_ propId: String, _ value: Double) -> String {
        let percentStats = [
            "FIGHT_PROP_HP_PERCENT", "FIGHT_PROP_ATTACK_PERCENT", "FIGHT_PROP_DEFENSE_PERCENT",
            "FIGHT_PROP_CRITICAL", "FIGHT_PROP_CRITICAL_HURT", "FIGHT_PROP_CHARGE_EFFICIENCY",
            "FIGHT_PROP_HEAL_ADD", "FIGHT_PROP_PHYSICAL_ADD_HURT", "FIGHT_PROP_FIRE_ADD_HURT",
            "FIGHT_PROP_WATER_ADD_HURT", "FIGHT_PROP_ELEC_ADD_HURT", "FIGHT_PROP_ICE_ADD_HURT",
            "FIGHT_PROP_WIND_ADD_HURT", "FIGHT_PROP_ROCK_ADD_HURT", "FIGHT_PROP_GRASS_ADD_HURT"
        ]

        if percentStats.contains(propId) {
            return String(format: "%.1f%%", value)
        } else {
            return String(format: "%.0f", value)
        }
    }

    static func getCharacterIconName(_ avatarId: Int) -> String {
        let iconNames: [Int: String] = [
            10000002: "Ayaka", 10000003: "Qin", 10000005: "PlayerBoy", 10000006: "Lisa",
            10000007: "PlayerGirl", 10000014: "Barbara", 10000015: "Kaeya", 10000016: "Diluc",
            10000020: "Razor", 10000021: "Ambor", 10000022: "Venti", 10000023: "Xiangling",
            10000024: "Beidou", 10000025: "Xingqiu", 10000026: "Xiao", 10000027: "Ningguang",
            10000029: "Klee", 10000030: "Zhongli", 10000031: "Fischl", 10000032: "Bennett",
            10000033: "Tartaglia", 10000034: "Noel", 10000035: "Qiqi", 10000036: "Chongyun",
            10000037: "Ganyu", 10000038: "Albedo", 10000039: "Diona", 10000041: "Mona",
            10000042: "Keqing", 10000043: "Sucrose", 10000044: "Xinyan", 10000045: "Rosaria",
            10000046: "Hutao", 10000047: "Kazuha", 10000048: "Feiyan", 10000049: "Yoimiya",
            10000050: "Tohma", 10000051: "Eula", 10000052: "Shougun", 10000053: "Sayu",
            10000054: "Kokomi", 10000055: "Gorou", 10000056: "Sara", 10000057: "Itto",
            10000058: "Yae", 10000059: "Heizo", 10000060: "Yelan", 10000062: "Aloy",
            10000063: "Shenhe", 10000064: "Yunjin", 10000065: "Shinobu", 10000066: "Ayato",
            10000067: "Collei", 10000068: "Dori", 10000069: "Tighnari", 10000070: "Nilou",
            10000071: "Cyno", 10000072: "Candace", 10000073: "Nahida", 10000074: "Layla",
            10000075: "Wanderer", 10000076: "Faruzan", 10000077: "Yaoyao", 10000078: "Alhatham",
            10000079: "Dehya", 10000080: "Mika", 10000081: "Kaveh", 10000082: "Baizhuer",
            10000083: "Linette", 10000084: "Liney", 10000085: "Freminet", 10000086: "Wriothesley",
            10000087: "Neuvillette", 10000088: "Charlotte", 10000089: "Furina", 10000090: "Chevreuse",
            10000091: "Navia", 10000092: "Gaming", 10000093: "Liuyun", 10000094: "Chiori",
            10000095: "Sigewinne", 10000096: "Arlecchino", 10000097: "Sethos", 10000098: "Clorinde",
            10000099: "Emilie", 10000100: "Kachina", 10000101: "Kinich", 10000102: "Mualani",
            10000103: "Xilonen", 10000104: "Chasca", 10000105: "Ororon", 10000106: "Mavuika",
            10000107: "Citlali", 10000108: "Lanyan",
        ]
        return iconNames[avatarId] ?? "PlayerBoy"
    }
}
