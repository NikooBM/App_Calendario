import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var subscriptionService: SubscriptionService
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarMainView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendario")
                }
                .tag(0)
            
            AISuggestionsView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Sugerencias")
                }
                .tag(1)
            
            ProductivityInsightsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Insights")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Ajustes")
                }
                .tag(3)
        }
    }
} 