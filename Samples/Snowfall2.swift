import SwiftUI
import Observation
import PhotosUI


@Observable
class SnowfallState {
    var numberOfSnowFlakes: Double = 100
    var averageDuration = 5.0
    var backgroundPhoto: PhotosPickerItem?
}

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
    let duration: CGFloat
    
    // 2. State to track the vertical position
    @State private var yPosition: CGFloat = -50 // Start above the screen
        
    // 3. Randomize properties for each specific snowflake
    // We generate these once when the view is created
    let xPosition = CGFloat.random(in: -20...400) // Rough screen width range
    
    let size = CGFloat.random(in: 0.5...1.5)
//    let duration = Double.random(in: 2.0...10.0) // Fall speed
    //let delay = Double.random(in: 0...3.0) // Start time
    
    let opacity = Double.random(in: 0.1...1.0)
    
    var body: some View {
        Snowflake()
            .scaleEffect(size) // Apply random size
            .position(x: xPosition + .random(in: -3...3),
                      y: yPosition) // Position it
            .opacity(opacity)
            .onAppear {
//                // 4. The Animation: Fall to bottom, repeat forever
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false) // Continuous fall
                        .delay(.random(in: 0..<duration)) // Don't start all at once
                ) {
                    yPosition = screenSize.height + 50 // End below the screen
                }
            }
    }
}

struct SnowfallView: View {
    @State var snowfallState = SnowfallState()
    
    @State var isPhotoPickerPresented = false
    @State var backgroundImage: Image? = nil
    
    func imageFromPickerItem(_ item: PhotosPickerItem?) async -> Image? {
        guard
            let item,
            let data = try? await item.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: data)
        else {
            return nil
        }

        return Image(uiImage: uiImage)
    }
        
    var body: some View {
        // 5. GeometryReader gets the exact screen dimensions
        GeometryReader { geometry in
            ZStack {
                // Dark background so we can see the white snow
               
                if backgroundImage == nil {
                    Color.black.ignoresSafeArea()
                } else {
                    backgroundImage?.ignoresSafeArea()
                }
                
                // 6. Loop to create 'n' snowflakes
                ForEach(0..<Int(snowfallState.numberOfSnowFlakes), id: \.self) { _ in
                    FallingSnowflake(screenSize: geometry.size,
                                     duration: snowfallState.averageDuration)
                }
            }
           .overlay(alignment: .bottom) {
               VStack {
                   Slider(value: $snowfallState.numberOfSnowFlakes, in: 10...300)
                   Slider(value: $snowfallState.averageDuration, in: 1...10)
                   Button("Choose Photo") {
                       isPhotoPickerPresented = true
                   }
               }
               .padding()
            }
            .photosPicker(isPresented: $isPhotoPickerPresented, selection: $snowfallState.backgroundPhoto, matching: .images)
            .onChange(of: snowfallState.backgroundPhoto) { _, newValue in
                Task {
                    self.backgroundImage = await imageFromPickerItem(newValue)
                }
            }
            .ignoresSafeArea() // Let snow fall behind the notch/home bar
        }
    }
}


#Preview {
    SnowfallView()
}
