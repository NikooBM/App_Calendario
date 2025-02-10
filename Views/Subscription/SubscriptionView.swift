import SwiftUI

struct SubscriptionView: View {
    @StateObject private var subscriptionService = SubscriptionService()
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Mejora tu Productividad")
                        .font(.title)
                        .bold()
                    
                    Text("Elige el plan que mejor se adapte a ti")
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Planes
                VStack(spacing: 20) {
                    PlanCard(
                        title: "Plan Gratuito",
                        price: "0€",
                        period: "para siempre",
                        features: SubscriptionService.SubscriptionPlan.free.features,
                        isCurrentPlan: subscriptionService.currentPlan == .free,
                        action: {}
                    )
                    
                    PlanCard(
                        title: "Plan Premium",
                        price: "4.99€",
                        period: "por mes",
                        features: SubscriptionService.SubscriptionPlan.premium.features,
                        isCurrentPlan: subscriptionService.currentPlan == .premium
                    ) {
                        Task {
                            await upgradeToPremium()
                        }
                    }
                }
                .padding()
                
                // Información adicional
                VStack(spacing: 8) {
                    Text("Cancela en cualquier momento")
                    Text("Restaurar compras").underline()
                        .onTapGesture {
                            // Implementar restauración de compras
                        }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }
    
    private func upgradeToPremium() async {
        isLoading = true
        do {
            try await subscriptionService.upgradeToPremium()
        } catch {
            errorMessage = "No se pudo completar la compra"
            showError = true
        }
        isLoading = false
    }
}

struct PlanCard: View {
    let title: String
    let price: String
    let period: String
    let features: [SubscriptionService.PlanFeature]
    let isCurrentPlan: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .bold()
            
            HStack(alignment: .firstTextBaseline) {
                Text(price)
                    .font(.title)
                    .bold()
                Text(period)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(features) { feature in
                    HStack {
                        Image(systemName: feature.included ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(feature.included ? .green : .gray)
                        Text(feature.name)
                        Spacer()
                    }
                }
            }
            .padding(.vertical)
            
            Button(action: action) {
                Text(isCurrentPlan ? "Plan Actual" : "Seleccionar Plan")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isCurrentPlan ? Color.gray : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isCurrentPlan)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
} 