//
//  ContentView.swift
//  Memorize
//
//  Created by Ömer Ulusal on 19.05.2020.
//  Copyright © 2020 ulusalomer. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(items: emojiMemoryGame.cards) { card in
                CardView(card: card)
                    .padding(5)
                    .onTapGesture {
                        withAnimation(.linear) { () -> Void in
                            self.emojiMemoryGame.choose(card: card)
                        }
                    }
            }
            .padding()
            .foregroundColor(.orange)
            Button(action: {
                withAnimation(.easeInOut) { () -> Void in
                    emojiMemoryGame.startOverWithRandomTheme()
                }
            }, label: {
                Text("New Game")
            })
            Text("Score: \(String(emojiMemoryGame.score))")
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: -90),
                            endAngle: Angle(degrees: (-360 * animatedBonusRemaining) - 90))
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: -90),
                            endAngle: Angle(degrees: (-360 * card.bonusRemaining) - 90))
                    }
                }
                .padding(.all, 5)
                .opacity(0.4)
                    
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
    
    // MARK: - Drawing Constants
    let fontScaleFactor: CGFloat = 0.7
    
}




































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards.first!)
        game.choose(card: game.cards[2])
        return EmojiMemoryGameView(emojiMemoryGame: game)
    }
}
