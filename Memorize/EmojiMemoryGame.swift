//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ömer Ulusal on 21.05.2020.
//  Copyright © 2020 ulusalomer. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let theme: GameTheme = .halloween
        return MemoryGame(numberOfPairsOfCards: theme.cards.count) { pairIndex in
            return theme.cards[pairIndex]
        }
    }
    
    func startOverWithRandomTheme() {
        guard let newTheme = GameTheme.allCases.randomElement() else { return }
        let cards = newTheme.cards
        model = MemoryGame(numberOfPairsOfCards: cards.count) { pairIndex in
            return cards[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var numberOfEmojis: Int {
        model.cards.count / 2
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}

enum GameTheme: CaseIterable {
    case halloween
    case smileys
    
    var cards: [String] {
        switch self {
        case .halloween:
            return ["🎃", "👻", "🕷", "👽", "🕯"]
        case .smileys:
            return ["😂", "🤣", "😇", "😍", "😘"]
        }
    }
}
