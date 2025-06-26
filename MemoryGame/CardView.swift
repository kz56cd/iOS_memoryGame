
import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            
            // Card Back
            Group {
                let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                shape.fill(gradient)
            }
            .opacity(card.isFaceUp ? 0 : 1)
            .rotation3DEffect(Angle.degrees(card.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Card Front
            Group {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            .rotation3DEffect(Angle.degrees(card.isFaceUp ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .animation(.default, value: card)
        .opacity(card.isMatched ? 0 : 1)
        .animation(.easeOut(duration: 0.4).delay(0.4), value: card.isMatched)
    }
}
