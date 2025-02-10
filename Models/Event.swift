import Foundation

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var startDate: Date
    var endDate: Date
    var category: EventCategory
    var isAISuggested: Bool
    var priority: EventPriority
    var recurrence: EventRecurrence?
    var location: String?
    var attendees: [String]?
    
    enum EventCategory: String, Codable {
        case work = "trabajo"
        case personal = "personal"
        case health = "salud"
        case social = "social"
        case study = "estudio"
    }
    
    enum EventPriority: Int, Codable {
        case low = 1
        case medium = 2
        case high = 3
    }
    
    enum EventRecurrence: String, Codable {
        case none
        case daily
        case weekly
        case monthly
        case yearly
    }
} 