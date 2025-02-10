import UserNotifications

class NotificationService: ObservableObject {
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permisos de notificación concedidos")
            } else if let error = error {
                print("Error al solicitar permisos: \(error)")
            }
        }
    }
    
    func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = event.description ?? "Evento próximo"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: event.startDate.addingTimeInterval(-900) // 15 minutos antes
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
} 