

import SwiftUI
import Combine

class MemoryGameViewModel: ObservableObject {
    static let emojis = ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙", "🙀", "👹", "😱", "☠️", "🍭"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 12) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private var model: MemoryGame<String> = createMemoryGame()
    @Published var timeRemaining = 60.00
    @Published var isGameOver = false

    private var timer: AnyCancellable?
    private var isGameStarted = false

    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }

    var allCardsMatched: Bool {
        model.cards.allSatisfy { $0.isMatched }
    }

    // MARK: - Intent(s)

    func choose(_ card: MemoryGame<String>.Card) {
        if !isGameStarted {
            startTimer()
            isGameStarted = true
        }
        model.choose(card)
    }

    func restart() {
        model = MemoryGameViewModel.createMemoryGame()
        stopTimer()
        timeRemaining = 60.00
        isGameOver = false
        isGameStarted = false
    }

    private func startTimer() {
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 0.01
            } else {
                self.timeRemaining = 0
                self.isGameOver = true
                self.stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

