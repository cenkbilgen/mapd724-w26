import SwiftUI

struct Snowflake: View {
    var body: some View {
        Image(systemName: "snowflake")
            .foregroundStyle(.white) // Make it look like snow
            .font(.system(size: 30)) // Set a base size
    }
}

struct FallingSnowflake: View {
    // 1. Pass in the screen size so we know how far to fall
    let screenSize: CGSize
    
    // 2. State to track the vertical position
    @State private var offset: CGFloat = -50.0 // Start above the screen
    
    // 3. Randomize properties for each specific snowflake
    // We generate these once when the view is created
    let xPosition: CGFloat = Double.random(in: -20...400) // Rough screen width range
    let size: CGFloat = Double.random(in: 0.5...1.5)
    let duration: Double = Double.random(in: 2.0...5.0) // Fall speed
    let delay: Double = Double.random(in: 0.0...3.0) // Start time
    
    var body: some View {
        Snowflake()
            .scaleEffect(size) // Apply random size
            .position(x: xPosition, y: offset) // Position it
            .onAppear {
                // 4. The Animation: Fall to bottom, repeat forever
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false) // Continuous fall
                    .delay(delay) // Don't start all at once
                ) {
                    offset = screenSize.height + 50 // End below the screen
                }
            }
    }
}

struct SnowfallView: View {
    let numberOfFlakes = 50
    
    var body: some View {
        // 5. GeometryReader gets the exact screen dimensions
        GeometryReader { geometry in
            ZStack {
                // Dark background so we can see the white snow
                Color.black.ignoresSafeArea()
                
                // 6. Loop to create 'n' snowflakes
                ForEach(0..<numberOfFlakes, id: \.self) { _ in
                    FallingSnowflake(screenSize: geometry.size)
                }
            }
        }
        .ignoresSafeArea() // Let snow fall behind the notch/home bar
    }
}

#Preview {
    SnowfallView()
}
