import EventKit
import GoogleAPIClientForREST

class CalendarIntegrationService: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var calendars: [CalendarSource] = []
    @Published var isAuthorized = false
    
    enum CalendarSource: Identifiable {
        case apple(EKCalendar)
        case google(GoogleCalendar)
        
        var id: String {
            switch self {
            case .apple(let calendar): return calendar.calendarIdentifier
            case .google(let calendar): return calendar.id
            }
        }
    }
    
    func requestAccess() async throws {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            isAuthorized = try await eventStore.requestAccess(to: .event)
        default:
            throw CalendarError.accessDenied
        }
    }
    
    func syncWithGoogleCalendar() async throws {
        // Implementar autenticación OAuth2 y sincronización
    }
    
    func importAppleCalendarEvents() async throws -> [Event] {
        guard isAuthorized else { throw CalendarError.notAuthorized }
        
        let calendars = eventStore.calendars(for: .event)
        let oneMonthAgo = Date().addingTimeInterval(-30*24*60*60)
        let oneYearFromNow = Date().addingTimeInterval(365*24*60*60)
        
        let predicate = eventStore.predicateForEvents(
            withStart: oneMonthAgo,
            end: oneYearFromNow,
            calendars: calendars
        )
        
        return eventStore.events(matching: predicate).map { ekEvent in
            Event(
                id: UUID(),
                title: ekEvent.title,
                description: ekEvent.notes,
                startDate: ekEvent.startDate,
                endDate: ekEvent.endDate,
                category: .personal,
                isAISuggested: false,
                priority: .medium
            )
        }
    }
    
    enum CalendarError: Error {
        case accessDenied
        case notAuthorized
        case syncFailed
    }
} 