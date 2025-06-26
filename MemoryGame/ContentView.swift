
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    @State private var showCongratulations = false
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            VStack {
                Text("Memory Game")
                    .font(.largeTitle)
                Spacer()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .onChange(of: viewModel.allCardsMatched) {
                if viewModel.allCardsMatched {
                    // Allow the last card flip animation to finish
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring()) {
                            showCongratulations = true
                        }
                    }
                }
            }

            if showCongratulations {
                VStack {
                    Spacer()
                    Text("Congratulations!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .scaleEffect(scale)
                        .onAppear {
                            let baseAnimation = Animation.spring(response: 0.5, dampingFraction: 0.5)
                            withAnimation(baseAnimation) {
                                scale = 1.2
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(baseAnimation) {
                                    scale = 1.0
                                }
                            }
                        }
                    Spacer()
                    Button("Play Again") {
                        withAnimation {
                            viewModel.restart()
                            showCongratulations = false
                        }
                    }
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.85))
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        ContentView(viewModel: game)
    }
}
