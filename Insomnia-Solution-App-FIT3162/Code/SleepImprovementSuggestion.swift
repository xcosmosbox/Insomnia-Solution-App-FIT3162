//
//  SleepImprovementSuggestion.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Jianhua Liu on 2024/3/23.
//

import SwiftUI

struct SleepSuggestionView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Meditation Techniques")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Suggestion 1")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text("Remove electronic devices, such as TVs, computers, and smart phones, from the bedroom.")
                    .font(.body)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SleepSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SleepSuggestionView()
    }
}
