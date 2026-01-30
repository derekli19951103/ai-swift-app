import Foundation

// MARK: - Flexible Value Types (API returns mixed types)
struct FlexibleString: Codable {
    let value: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let intValue = try? container.decode(Int.self) {
            value = String(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            value = String(doubleValue)
        } else {
            value = ""
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

struct FlexibleDouble: Codable {
    let value: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let intValue = try? container.decode(Int.self) {
            value = Double(intValue)
        } else if let stringValue = try? container.decode(String.self), let parsed = Double(stringValue) {
            value = parsed
        } else {
            value = 0
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - API Response
struct EnkaResponse: Codable {
    let playerInfo: PlayerInfo
    let avatarInfoList: [AvatarInfo]?
    let ttl: Int?
}

// MARK: - Player Info
struct PlayerInfo: Codable {
    let nickname: String
    let level: Int
    let signature: String?
    let worldLevel: Int?
    let nameCardId: Int?
    let finishAchievementNum: Int?
    let towerFloorIndex: Int?
    let towerLevelIndex: Int?
    let showAvatarInfoList: [ShowAvatarInfo]?
    let profilePicture: ProfilePicture?
}

struct ShowAvatarInfo: Codable {
    let avatarId: Int
    let level: Int
    let costumeId: Int?
}

struct ProfilePicture: Codable {
    let avatarId: Int?
    let id: Int?
}

// MARK: - Avatar (Character) Info
struct AvatarInfo: Codable, Identifiable {
    var id: Int { avatarId }

    let avatarId: Int
    let propMap: [String: PropValue]?
    let talentIdList: [Int]?
    let fightPropMap: [String: Double]?
    let skillDepotId: Int?
    let inherentProudSkillList: [Int]?
    let skillLevelMap: [String: Int]?
    let equipList: [Equipment]?
    let fetterInfo: FetterInfo?

    enum CodingKeys: String, CodingKey {
        case avatarId, propMap, talentIdList, fightPropMap, skillDepotId
        case inherentProudSkillList, skillLevelMap, equipList, fetterInfo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarId = try container.decode(Int.self, forKey: .avatarId)
        propMap = try container.decodeIfPresent([String: PropValue].self, forKey: .propMap)
        talentIdList = try container.decodeIfPresent([Int].self, forKey: .talentIdList)
        skillDepotId = try container.decodeIfPresent(Int.self, forKey: .skillDepotId)
        inherentProudSkillList = try container.decodeIfPresent([Int].self, forKey: .inherentProudSkillList)
        skillLevelMap = try container.decodeIfPresent([String: Int].self, forKey: .skillLevelMap)
        equipList = try container.decodeIfPresent([Equipment].self, forKey: .equipList)
        fetterInfo = try container.decodeIfPresent(FetterInfo.self, forKey: .fetterInfo)

        // Handle fightPropMap with flexible number types
        if let rawMap = try container.decodeIfPresent([String: FlexibleDouble].self, forKey: .fightPropMap) {
            fightPropMap = rawMap.mapValues { $0.value }
        } else {
            fightPropMap = nil
        }
    }
}

struct PropValue: Codable {
    let type: Int?
    let ival: String?
    let val: String?

    enum CodingKeys: String, CodingKey {
        case type, ival, val
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(Int.self, forKey: .type)

        // Handle ival as either String or Int
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: .ival) {
            ival = stringValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .ival) {
            ival = String(intValue)
        } else {
            ival = nil
        }

        // Handle val as either String or Int/Double
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: .val) {
            val = stringValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .val) {
            val = String(intValue)
        } else if let doubleValue = try? container.decodeIfPresent(Double.self, forKey: .val) {
            val = String(doubleValue)
        } else {
            val = nil
        }
    }
}

struct FetterInfo: Codable {
    let expLevel: Int?
}

// MARK: - Equipment (Weapons & Artifacts)
struct Equipment: Codable, Identifiable {
    var id: String { flat.nameTextMapHash }

    let itemId: Int
    let weapon: WeaponData?
    let reliquary: ReliquaryData?
    let flat: FlatData
}

struct WeaponData: Codable {
    let level: Int
    let promoteLevel: Int?
    let affixMap: [String: Int]?
}

struct ReliquaryData: Codable {
    let level: Int
    let mainPropId: Int?
    let appendPropIdList: [Int]?
}

struct FlatData: Codable {
    let nameTextMapHash: String
    let setNameTextMapHash: String?
    let rankLevel: Int
    let itemType: String
    let icon: String
    let equipType: String?
    let reliquaryMainstat: ReliquaryStat?
    let reliquarySubstats: [ReliquarySubstat]?
    let weaponStats: [WeaponStat]?

    enum CodingKeys: String, CodingKey {
        case nameTextMapHash, setNameTextMapHash, rankLevel, itemType, icon, equipType
        case reliquaryMainstat, reliquarySubstats, weaponStats
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Handle nameTextMapHash as either String or Int
        if let stringValue = try? container.decode(String.self, forKey: .nameTextMapHash) {
            nameTextMapHash = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .nameTextMapHash) {
            nameTextMapHash = String(intValue)
        } else {
            nameTextMapHash = ""
        }

        // Handle setNameTextMapHash as either String or Int
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: .setNameTextMapHash) {
            setNameTextMapHash = stringValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .setNameTextMapHash) {
            setNameTextMapHash = String(intValue)
        } else {
            setNameTextMapHash = nil
        }

        rankLevel = try container.decode(Int.self, forKey: .rankLevel)
        itemType = try container.decode(String.self, forKey: .itemType)
        icon = try container.decode(String.self, forKey: .icon)
        equipType = try container.decodeIfPresent(String.self, forKey: .equipType)
        reliquaryMainstat = try container.decodeIfPresent(ReliquaryStat.self, forKey: .reliquaryMainstat)
        reliquarySubstats = try container.decodeIfPresent([ReliquarySubstat].self, forKey: .reliquarySubstats)
        weaponStats = try container.decodeIfPresent([WeaponStat].self, forKey: .weaponStats)
    }
}

struct ReliquaryStat: Codable, Identifiable {
    var id: String { mainPropId + statValue.description }

    let mainPropId: String
    let statValue: Double

    enum CodingKeys: String, CodingKey {
        case mainPropId, statValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mainPropId = try container.decode(String.self, forKey: .mainPropId)

        // Handle statValue as either Double or Int
        if let doubleValue = try? container.decode(Double.self, forKey: .statValue) {
            statValue = doubleValue
        } else if let intValue = try? container.decode(Int.self, forKey: .statValue) {
            statValue = Double(intValue)
        } else {
            statValue = 0
        }
    }
}

struct ReliquarySubstat: Codable, Identifiable {
    var id: String { appendPropId + statValue.description }

    let appendPropId: String
    let statValue: Double

    enum CodingKeys: String, CodingKey {
        case appendPropId, statValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appendPropId = try container.decode(String.self, forKey: .appendPropId)

        // Handle statValue as either Double or Int
        if let doubleValue = try? container.decode(Double.self, forKey: .statValue) {
            statValue = doubleValue
        } else if let intValue = try? container.decode(Int.self, forKey: .statValue) {
            statValue = Double(intValue)
        } else {
            statValue = 0
        }
    }
}

struct WeaponStat: Codable, Identifiable {
    var id: String { appendPropId }

    let appendPropId: String
    let statValue: Double

    enum CodingKeys: String, CodingKey {
        case appendPropId, statValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appendPropId = try container.decode(String.self, forKey: .appendPropId)

        // Handle statValue as either Double or Int
        if let doubleValue = try? container.decode(Double.self, forKey: .statValue) {
            statValue = doubleValue
        } else if let intValue = try? container.decode(Int.self, forKey: .statValue) {
            statValue = Double(intValue)
        } else {
            statValue = 0
        }
    }
}

// MARK: - Display Models
struct CharacterDisplay: Identifiable {
    let id: Int
    let name: String
    let level: Int
    let element: String
    let rarity: Int
    let iconURL: URL?
    let friendship: Int
    let constellation: Int
    let weapon: WeaponDisplay?
    let artifacts: [ArtifactDisplay]
    let stats: CharacterStats
}

struct WeaponDisplay: Identifiable {
    let id: Int
    let name: String
    let level: Int
    let refinement: Int
    let rarity: Int
    let iconURL: URL?
    let mainStat: String
    let subStat: String?
}

struct ArtifactDisplay: Identifiable {
    let id: String
    let name: String
    let setName: String
    let type: ArtifactType
    let level: Int
    let rarity: Int
    let iconURL: URL?
    let mainStat: StatDisplay
    let subStats: [StatDisplay]
    var score: ArtifactScore?
}

struct StatDisplay: Identifiable {
    var id: String { name + value }
    let name: String
    let value: String
}

struct CharacterStats {
    let hp: Double
    let atk: Double
    let def: Double
    let critRate: Double
    let critDmg: Double
    let energyRecharge: Double
    let elementalMastery: Double
}

enum ArtifactType: String {
    case flower = "EQUIP_BRACER"
    case plume = "EQUIP_NECKLACE"
    case sands = "EQUIP_SHOES"
    case goblet = "EQUIP_RING"
    case circlet = "EQUIP_DRESS"

    var displayName: String {
        switch self {
        case .flower: return "Flower of Life"
        case .plume: return "Plume of Death"
        case .sands: return "Sands of Eon"
        case .goblet: return "Goblet of Eonothem"
        case .circlet: return "Circlet of Logos"
        }
    }

    var icon: String {
        switch self {
        case .flower: return "leaf.fill"
        case .plume: return "wind"
        case .sands: return "hourglass"
        case .goblet: return "cup.and.saucer.fill"
        case .circlet: return "crown.fill"
        }
    }
}
