import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PlayerViewModel()
    @State private var uid: String = ""
    @State private var showAllAccounts = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.05, green: 0.05, blue: 0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerView

                        searchSection

                        if viewModel.isLoading {
                            loadingView
                        } else if let error = viewModel.errorMessage {
                            errorView(error)
                        } else if let playerInfo = viewModel.playerInfo {
                            refreshSection

                            playerInfoCard(playerInfo)

                            if viewModel.showcaseEmpty {
                                showcaseEmptyView
                            } else {
                                charactersSection
                            }
                        } else {
                            welcomeView
                        }

                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Load saved UID
                if uid.isEmpty {
                    uid = viewModel.savedUID
                }
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Genshin Viewer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("View your account showcase")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top, 20)
    }

    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "person.badge.key")
                    .foregroundColor(.gray)

                TextField("Enter UID (e.g., 800000001)", text: $uid)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .focused($isInputFocused)
                    .onSubmit {
                        Task {
                            await viewModel.fetchPlayerData(uid: uid)
                        }
                    }

                if !uid.isEmpty {
                    Button {
                        uid = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)

            Button {
                isInputFocused = false
                Task {
                    await viewModel.fetchPlayerData(uid: uid)
                }
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)

            // Saved Accounts
            if !viewModel.savedAccounts.isEmpty {
                savedAccountsSection
            }
        }
    }

    // MARK: - Saved Accounts Section
    private var savedAccountsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Saved Accounts")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)

                Spacer()

                if showAllAccounts || viewModel.savedAccounts.count <= 3 {
                    // No toggle needed
                } else {
                    Button {
                        withAnimation {
                            showAllAccounts.toggle()
                        }
                    } label: {
                        Text(showAllAccounts ? "Show Less" : "Show All (\(viewModel.savedAccounts.count))")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }

            let accountsToShow = showAllAccounts ? viewModel.savedAccounts : Array(viewModel.savedAccounts.prefix(3))

            ForEach(accountsToShow) { account in
                SavedAccountRow(
                    account: account,
                    isSelected: uid == account.uid,
                    onSelect: {
                        uid = account.uid
                        isInputFocused = false
                        Task {
                            await viewModel.fetchPlayerData(uid: account.uid)
                        }
                    },
                    onDelete: {
                        withAnimation {
                            viewModel.deleteAccount(account)
                        }
                    }
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)

            Text("Fetching player data...")
                .foregroundColor(.gray)
        }
        .padding(40)
    }

    // MARK: - Refresh Section
    private var refreshSection: some View {
        HStack {
            if let lastRefresh = viewModel.lastRefreshTime {
                Text("Updated \(lastRefresh.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Refresh")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
            }
            .disabled(viewModel.isLoading)
            .opacity(viewModel.isLoading ? 0.5 : 1)
        }
    }

    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)

            Text(message)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task {
                    await viewModel.fetchPlayerData(uid: uid)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Color.red.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(16)
    }

    // MARK: - Player Info Card
    private func playerInfoCard(_ info: PlayerInfo) -> some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(info.nickname)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("UID: \(viewModel.lastUID)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("AR \(info.level)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)

                    if let worldLevel = info.worldLevel {
                        Text("WL \(worldLevel)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }

            if let signature = info.signature, !signature.isEmpty {
                Text("\"\(signature)\"")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider()
                .background(Color.white.opacity(0.2))

            HStack(spacing: 20) {
                if let achievements = info.finishAchievementNum {
                    StatBadge(icon: "trophy.fill", value: "\(achievements)", label: "Achievements")
                }

                if let floor = info.towerFloorIndex, let level = info.towerLevelIndex {
                    StatBadge(icon: "building.columns.fill", value: "\(floor)-\(level)", label: "Spiral Abyss")
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Showcase Empty View
    private var showcaseEmptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "eye.slash.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)

            Text("Character Showcase is Empty")
                .font(.headline)
                .foregroundColor(.white)

            Text("This player hasn't added characters to their showcase, or the showcase is private.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
    }

    // MARK: - Characters Section
    private var charactersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Character Showcase")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(viewModel.characters) { character in
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    CharacterRow(character: character)
                }
            }
        }
    }

    // MARK: - Welcome View
    private var welcomeView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.purple.opacity(0.7))

            Text("Enter a UID to View Account")
                .font(.headline)
                .foregroundColor(.white)

            Text("You can find your UID in-game at the bottom right of the screen on the map or pause menu.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8) {
                Text("Note:")
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)

                Text("• Character Showcase must be public")
                Text("• Add characters to showcase in-game")
                Text("• Data may be cached for a few minutes")
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
        }
        .padding()
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(value)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)

            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Character Row
struct CharacterRow: View {
    let character: CharacterDisplay

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: character.iconURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(elementColor(character.element), lineWidth: 2)
            )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(character.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Spacer()

                    HStack(spacing: 2) {
                        ForEach(0..<character.rarity, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.yellow)
                        }
                    }
                }

                HStack {
                    Text("Lv. \(character.level)")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("•")
                        .foregroundColor(.gray)

                    Text(character.element)
                        .font(.caption)
                        .foregroundColor(elementColor(character.element))

                    if character.constellation > 0 {
                        Text("•")
                            .foregroundColor(.gray)

                        Text("C\(character.constellation)")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }

                if let weapon = character.weapon {
                    HStack(spacing: 4) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 10))
                        Text("R\(weapon.refinement) Lv.\(weapon.level)")
                    }
                    .font(.caption2)
                    .foregroundColor(.orange)
                }
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }

    private func elementColor(_ element: String) -> Color {
        switch element {
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
}

// MARK: - Saved Account Row
struct SavedAccountRow: View {
    let account: SavedAccount
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSelect) {
                HStack(spacing: 10) {
                    // Avatar placeholder
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text(String(account.nickname.prefix(1)).uppercased())
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(account.nickname)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Text(account.uid)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)

            // Delete button
            Button {
                showDeleteConfirmation = true
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(.red.opacity(0.8))
                    .padding(8)
            }
            .confirmationDialog(
                "Delete \(account.nickname)?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will remove the saved account from your list.")
            }
        }
    }
}

#Preview {
    ContentView()
}
