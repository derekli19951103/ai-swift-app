import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case wrongUIDFormat
    case playerNotFound
    case gameMaintenance
    case rateLimited
    case serverError
    case decodingError(Error)
    case unknown(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .wrongUIDFormat:
            return "Wrong UID format. Please enter a valid 9-digit UID."
        case .playerNotFound:
            return "Player not found. Please check the UID."
        case .gameMaintenance:
            return "Game is under maintenance. Please try again later."
        case .rateLimited:
            return "Too many requests. Please wait a moment and try again."
        case .serverError:
            return "Server error. Please try again later."
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .unknown(let code):
            return "Unknown error (code: \(code))"
        }
    }
}

actor NetworkService {
    static let shared = NetworkService()

    private let baseURL = "https://enka.network/api"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    func fetchPlayerData(uid: String) async throws -> EnkaResponse {
        guard let url = URL(string: "\(baseURL)/uid/\(uid)/") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("GenshinViewer-iOS/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            break
        case 400:
            throw NetworkError.wrongUIDFormat
        case 404:
            throw NetworkError.playerNotFound
        case 424:
            throw NetworkError.gameMaintenance
        case 429:
            throw NetworkError.rateLimited
        case 500, 503:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(EnkaResponse.self, from: data)
        } catch let decodingError as DecodingError {
            // Log the raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("=== RAW API RESPONSE ===")
                print(jsonString.prefix(5000))
                print("=== END RAW RESPONSE ===")
            }

            // Provide detailed decoding error
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                print("Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .typeMismatch(let type, let context):
                print("Type mismatch for \(type): \(context.debugDescription)")
                print("Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .valueNotFound(let type, let context):
                print("Value not found for \(type): \(context.debugDescription)")
                print("Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription)")
                print("Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            @unknown default:
                print("Unknown decoding error: \(decodingError)")
            }

            throw NetworkError.decodingError(decodingError)
        } catch {
            print("Non-decoding error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
}
