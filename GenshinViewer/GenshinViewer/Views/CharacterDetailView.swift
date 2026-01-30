import SwiftUI

struct CharacterDetailView: View {
    let character: CharacterDisplay
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [elementBackgroundColor.opacity(0.3), Color(red: 0.05, green: 0.05, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    characterHeader

                    statsSection

                    if let weapon = character.weapon {
                        weaponSection(weapon)
                    }

                    if !character.artifacts.isEmpty {
                        artifactsSection
                    }

                    Spacer(minLength: 50)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(character.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
    }

    // MARK: - Character Header
    private var characterHeader: some View {
        VStack(spacing: 16) {
            AsyncImage(url: character.iconURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [elementColor, elementColor.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 4
                    )
            )
            .shadow(color: elementColor.opacity(0.5), radius: 10)

            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(0..<character.rarity, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                    }
                }

                HStack(spacing: 16) {
                    InfoPill(label: "Level", value: "\(character.level)")
                    InfoPill(label: "Element", value: character.element, color: elementColor)
                    InfoPill(label: "Friendship", value: "\(character.friendship)")
                    if character.constellation > 0 {
                        InfoPill(label: "Constellation", value: "C\(character.constellation)", color: .purple)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Character Stats", icon: "chart.bar.fill")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(name: "Max HP", value: formatNumber(character.stats.hp), icon: "heart.fill", color: .green)
                StatCard(name: "ATK", value: formatNumber(character.stats.atk), icon: "flame.fill", color: .red)
                StatCard(name: "DEF", value: formatNumber(character.stats.def), icon: "shield.fill", color: .yellow)
                StatCard(name: "Elemental Mastery", value: formatNumber(character.stats.elementalMastery), icon: "sparkles", color: .purple)
                StatCard(name: "CRIT Rate", value: String(format: "%.1f%%", character.stats.critRate), icon: "target", color: .orange)
                StatCard(name: "CRIT DMG", value: String(format: "%.1f%%", character.stats.critDmg), icon: "bolt.fill", color: .red)
                StatCard(name: "Energy Recharge", value: String(format: "%.1f%%", character.stats.energyRecharge), icon: "battery.100.bolt", color: .cyan)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    // MARK: - Weapon Section
    private func weaponSection(_ weapon: WeaponDisplay) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Weapon", icon: "shield.lefthalf.filled")

            HStack(spacing: 12) {
                AsyncImage(url: weapon.iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(systemName: "shield.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .background(rarityBackground(weapon.rarity))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Lv. \(weapon.level)")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()

                        HStack(spacing: 2) {
                            ForEach(0..<weapon.rarity, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.yellow)
                            }
                        }
                    }

                    Text("Refinement \(weapon.refinement)")
                        .font(.subheadline)
                        .foregroundColor(.orange)

                    Text(weapon.mainStat)
                        .font(.caption)
                        .foregroundColor(.gray)

                    if let subStat = weapon.subStat {
                        Text(subStat)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    // MARK: - Artifacts Section
    private var artifactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Artifacts", icon: "sparkle")

            ForEach(character.artifacts) { artifact in
                ArtifactCard(artifact: artifact)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    // MARK: - Helpers
    private var elementColor: Color {
        switch character.element {
        case "Pyro": return .red
        case "Hydro": return .blue
        case "Electro": return .purple
        case "Cryo": return .cyan
        case "Anemo": return .mint
        case "Geo": return .yellow
        case "Dendro": return .green
        default: return .gray
        }
    }

    private var elementBackgroundColor: Color {
        elementColor.opacity(0.3)
    }

    private func rarityBackground(_ rarity: Int) -> Color {
        switch rarity {
        case 5: return Color.orange.opacity(0.3)
        case 4: return Color.purple.opacity(0.3)
        case 3: return Color.blue.opacity(0.3)
        default: return Color.gray.opacity(0.3)
        }
    }

    private func formatNumber(_ value: Double) -> String {
        if value >= 10000 {
            return String(format: "%.1fK", value / 1000)
        }
        return String(format: "%.0f", value)
    }
}

// MARK: - Supporting Views
struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.7))
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

struct InfoPill: View {
    let label: String
    let value: String
    var color: Color = .white

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

struct StatCard: View {
    let name: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct ArtifactCard: View {
    let artifact: ArtifactDisplay

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                AsyncImage(url: artifact.iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(systemName: artifact.type.icon)
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 50, height: 50)
                .background(rarityBackground(artifact.rarity))
                .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(artifact.type.displayName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Spacer()

                        Text("+\(artifact.level)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(4)
                    }

                    HStack(spacing: 4) {
                        ForEach(0..<artifact.rarity, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.yellow)
                        }

                        Spacer()

                        // Score badge
                        if let score = artifact.score {
                            HStack(spacing: 4) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 10))
                                Text(String(format: "%.1f", score.totalScore))
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(scoreColor(score.rating))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(scoreColor(score.rating).opacity(0.2))
                            .cornerRadius(4)
                        }
                    }
                }
            }

            // Main Stat
            HStack {
                Text(artifact.mainStat.name)
                    .foregroundColor(.orange)
                Spacer()
                Text(artifact.mainStat.value)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(4)

            // Sub Stats
            if !artifact.subStats.isEmpty {
                VStack(spacing: 4) {
                    ForEach(artifact.subStats) { stat in
                        HStack {
                            Text("• \(stat.name)")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(stat.value)
                                .foregroundColor(.white)
                        }
                        .font(.caption2)
                    }
                }
                .padding(8)
                .background(Color.white.opacity(0.03))
                .cornerRadius(4)
            }

            // Score breakdown
            if let score = artifact.score {
                VStack(spacing: 6) {
                    HStack {
                        Text("Score Breakdown")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(score.rating.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(scoreColor(score.rating))
                    }

                    HStack(spacing: 12) {
                        ScoreComponent(label: "Main", value: score.mainStatScore, maxValue: 1.0)
                        ScoreComponent(label: "Subs", value: score.substatScore, maxValue: 1.5)
                        ScoreComponent(label: "Set", value: score.setMultiplier, maxValue: 1.0)
                    }
                }
                .padding(8)
                .background(scoreColor(score.rating).opacity(0.1))
                .cornerRadius(4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }

    private func rarityBackground(_ rarity: Int) -> Color {
        switch rarity {
        case 5: return Color.orange.opacity(0.3)
        case 4: return Color.purple.opacity(0.3)
        case 3: return Color.blue.opacity(0.3)
        default: return Color.gray.opacity(0.3)
        }
    }

    private func scoreColor(_ rating: ArtifactScore.ScoreRating) -> Color {
        switch rating {
        case .perfect: return .orange
        case .excellent: return .purple
        case .great: return .blue
        case .good: return .green
        case .decent: return .yellow
        case .poor: return .gray
        }
    }
}

struct ScoreComponent: View {
    let label: String
    let value: Double
    let maxValue: Double

    var body: some View {
        VStack(spacing: 2) {
            Text(String(format: "%.0f%%", (value / maxValue) * 100))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(character: CharacterDisplay(
            id: 10000046,
            name: "Hu Tao",
            level: 90,
            element: "Pyro",
            rarity: 5,
            iconURL: nil,
            friendship: 10,
            constellation: 1,
            weapon: WeaponDisplay(
                id: 1,
                name: "Staff of Homa",
                level: 90,
                refinement: 1,
                rarity: 5,
                iconURL: nil,
                mainStat: "Base ATK: 608",
                subStat: "CRIT DMG: 66.2%"
            ),
            artifacts: [
                ArtifactDisplay(
                    id: "1",
                    name: "Witch's Flower",
                    setName: "Crimson Witch",
                    type: .flower,
                    level: 20,
                    rarity: 5,
                    iconURL: nil,
                    mainStat: StatDisplay(name: "HP", value: "4,780"),
                    subStats: [
                        StatDisplay(name: "CRIT DMG", value: "14.8%"),
                        StatDisplay(name: "CRIT Rate", value: "10.5%"),
                        StatDisplay(name: "ATK%", value: "5.8%"),
                        StatDisplay(name: "EM", value: "21")
                    ],
                    score: ArtifactScore(
                        totalScore: 42.5,
                        mainStatScore: 1.0,
                        substatScore: 0.85,
                        setMultiplier: 1.0,
                        rating: .excellent
                    )
                )
            ],
            stats: CharacterStats(
                hp: 32000,
                atk: 1200,
                def: 900,
                critRate: 65.5,
                critDmg: 220.3,
                energyRecharge: 110.0,
                elementalMastery: 100
            )
        ))
    }
}
