import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            LogoView(size: 120, showText: true)
                .foregroundColor(.white)
        }
    }
} 