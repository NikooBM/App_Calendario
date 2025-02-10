import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(
                title: "Bienvenido a SmartCal",
                description: "Optimiza tu tiempo con ayuda de IA",
                imageName: "calendar.badge.clock",
                backgroundColor: .accentColor
            ) {
                LogoView(size: 120)
            }
            .tag(0)
            
            OnboardingPage(
                title: "Sincronización Universal",
                description: "Conecta con Google Calendar y Apple Calendar",
                imageName: "arrow.triangle.2.circlepath",
                backgroundColor: .green
            )
            .tag(1)
            
            OnboardingPage(
                title: "Sugerencias Personalizadas",
                description: "Recibe recomendaciones basadas en tus hábitos",
                imageName: "brain.head.profile",
                backgroundColor: .purple
            )
            .tag(2)
            
            LoginView()
                .tag(3)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage<Content: View>: View {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
    let customContent: Content?
    
    init(
        title: String,
        description: String,
        imageName: String,
        backgroundColor: Color,
        @ViewBuilder customContent: () -> Content? = { nil }
    ) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.customContent = customContent()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let customContent = customContent {
                customContent
            } else {
                Image(systemName: imageName)
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
} 