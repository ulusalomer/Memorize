//
//  Grid.swift
//  Memorize
//
//  Created by Ömer Ulusal on 7.08.2020.
//  Copyright © 2020 ulusalomer. All rights reserved.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            forEach(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    func forEach(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            itemView(for: item, in: layout)
        }
    }
    
    func itemView(for item: Item, in layout: GridLayout) -> some View {
        viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: items.firstIndex(matching: item)!))
    }
}

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for i in 0..<self.count {
            if self[i].id == matching.id {
                return i
            }
        }
        return nil
    }
}
