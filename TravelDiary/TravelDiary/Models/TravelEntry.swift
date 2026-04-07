import Foundation

struct TravelEntry: Hashable, Codable {
    let id: String
    let country: String
    let city: String
    let notes: String
    let date: Date
}
