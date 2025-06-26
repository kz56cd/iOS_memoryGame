
import SwiftUI

@main
struct MemoryGameApp: App {
    var body: some Scene {
        WindowGroup {
            let game = MemoryGameViewModel()
            ContentView(viewModel: game)
        }
    }
}
