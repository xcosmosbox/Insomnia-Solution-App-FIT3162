//
//  HomePage.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Ching Yee Selina Wong on 16/3/2024.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
            ScrollView {
                VStack {
                    ForEach(Category.allCases, id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category.title)
                                .font(.headline)
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 10) {
                                    ForEach(0..<10) { item in
                                        VStack {
                                            Image(systemName: category.iconName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                            Text(category.itemTitle)
                                                .font(.caption)
                                        }
                                        .frame(width: 100, height: 150)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
    }

enum Category: CaseIterable {
    case whiteNoise, relaxingMusic, sleepingStory
    
    var title: String {
        switch self {
            case .whiteNoise: return "White Noise"
            case .relaxingMusic: return "Relaxing Music"
            case .sleepingStory: return "Sleeping Story"
        }
    }
    
    var iconName: String {
        switch self {
            case .whiteNoise: return "cloud.rain.fill"
            case .relaxingMusic: return "music.note.list"
            case .sleepingStory: return "book.fill"
        }
    }
    
    var itemTitle: String {
        switch self {
            case .whiteNoise: return "Rain"
            case .relaxingMusic: return "Beat Insomnia"
            case .sleepingStory: return "Adventure Dream"
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
