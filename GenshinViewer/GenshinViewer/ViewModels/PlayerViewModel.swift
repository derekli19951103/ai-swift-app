import Foundation
import SwiftUI

// MARK: - Saved Account Model
struct SavedAccount: Codable, Identifiable, Equatable {
    var id: String { uid }
    let uid: String
    var nickname: String
    var lastUsed: Date

    static func == (lhs: SavedAccount, rhs: SavedAccount) -> Bool {
        lhs.uid == rhs.uid
    }
}

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var playerInfo: PlayerInfo?
    @Published var characters: [CharacterDisplay] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUID: String = ""
    @Published var showcaseEmpty = false
    @Published var lastRefreshTime: Date?
    @Published var savedAccounts: [SavedAccount] = []

    private let networkService = NetworkService.shared
    private let uidKey = "savedGenshinUID"
    private let accountsKey = "savedGenshinAccounts"

    init() {
        loadSavedAccounts()
        // Set lastUID to most recently used account
        if let mostRecent = savedAccounts.first {
            lastUID = mostRecent.uid
        }
    }

    var savedUID: String {
        get { UserDefaults.standard.string(forKey: uidKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: uidKey) }
    }

    // MARK: - Account Management

    private func loadSavedAccounts() {
        if let data = UserDefaults.standard.data(forKey: accountsKey),
           let accounts = try? JSONDecoder().decode([SavedAccount].self, from: data) {
            // Sort by last used (most recent first)
            savedAccounts = accounts.sorted { $0.lastUsed > $1.lastUsed }
        }
    }

    private func saveToDisk() {
        if let data = try? JSONEncoder().encode(savedAccounts) {
            UserDefaults.standard.set(data, forKey: accountsKey)
        }
    }

    func addOrUpdateAccount(uid: String, nickname: String) {
        let now = Date()

        if let index = savedAccounts.firstIndex(where: { $0.uid == uid }) {
            // Update existing account
            savedAccounts[index].nickname = nickname
            savedAccounts[index].lastUsed = now
        } else {
            // Add new account
            let account = SavedAccount(uid: uid, nickname: nickname, lastUsed: now)
            savedAccounts.append(account)
        }

        // Sort by last used
        savedAccounts.sort { $0.lastUsed > $1.lastUsed }
        saveToDisk()
    }

    func deleteAccount(_ account: SavedAccount) {
        savedAccounts.removeAll { $0.uid == account.uid }
        saveToDisk()
    }

    func deleteAccount(at offsets: IndexSet) {
        savedAccounts.remove(atOffsets: offsets)
        saveToDisk()
    }

    // MARK: - Data Fetching

    func fetchPlayerData(uid: String) async {
        let trimmedUID = uid.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUID.isEmpty else {
            errorMessage = "Please enter a UID"
            return
        }

        guard trimmedUID.count >= 9, trimmedUID.allSatisfy({ $0.isNumber }) else {
            errorMessage = "UID must be a 9-digit number"
            return
        }

        isLoading = true
        errorMessage = nil
        showcaseEmpty = false

        do {
            let response = try await networkService.fetchPlayerData(uid: trimmedUID)

            playerInfo = response.playerInfo
            lastUID = trimmedUID
            lastRefreshTime = Date()

            // Save UID and nickname for next time
            savedUID = trimmedUID
            addOrUpdateAccount(uid: trimmedUID, nickname: response.playerInfo.nickname)

            if let avatarInfoList = response.avatarInfoList, !avatarInfoList.isEmpty {
                characters = avatarInfoList.map { GenshinDataMapper.mapToCharacterDisplay($0) }
            } else {
                characters = []
                showcaseEmpty = true
            }
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        guard !lastUID.isEmpty else { return }
        await fetchPlayerData(uid: lastUID)
    }

    func clearData() {
        playerInfo = nil
        characters = []
        errorMessage = nil
        showcaseEmpty = false
        lastRefreshTime = nil
    }
}
