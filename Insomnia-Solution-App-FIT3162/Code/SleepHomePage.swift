//
//  SleepImprovementSuggestion.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Jianhua Liu on 2024/3/25.
//

import SwiftUI

struct SleepHomePage: View {
    var body: some View {
        VStack {
            Button(action: {
                // Start sleep Button
            }) {
                Text("Start Sleep")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding()

            
            Spacer()
            
            
            
            
            
            
        }
        .navigationTitle("Weekly Overview")
    }
}

struct SleepHomePage_Previews: PreviewProvider {
    static var previews: some View {
        SleepHomePage()
    }
}
