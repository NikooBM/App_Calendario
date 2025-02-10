import Foundation
import CoreData

class DataService: ObservableObject {
    private let container: NSPersistentContainer
    @Published var events: [Event] = []
    @Published var preferences: UserPreferences
    
    init() {
        container = NSPersistentContainer(name: "CalendarApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        
        preferences = UserPreferences.load() ?? UserPreferences.default
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func fetchEvents(in range: DateInterval) -> [Event] {
        let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "startDate >= %@ AND endDate <= %@",
            range.start as NSDate,
            range.end as NSDate
        )
        
        do {
            let entities = try container.viewContext.fetch(request)
            return entities.map { $0.toEvent() }
        } catch {
            print("Error fetching events: \(error)")
            return []
        }
    }
}

struct UserPreferences: Codable {
    var preferredWorkingHours: DateInterval
    var minimumBreakTime: TimeInterval
    var preferredMeetingDuration: TimeInterval
    var focusTimePreferences: FocusTimePreferences
    var notificationPreferences: NotificationPreferences
    
    static var `default`: UserPreferences {
        UserPreferences(
            preferredWorkingHours: DateInterval(
                start: Calendar.current.date(from: DateComponents(hour: 9)) ?? Date(),
                duration: 8 * 3600
            ),
            minimumBreakTime: 900, // 15 minutos
            preferredMeetingDuration: 3600, // 1 hora
            focusTimePreferences: .default,
            notificationPreferences: .default
        )
    }
} 