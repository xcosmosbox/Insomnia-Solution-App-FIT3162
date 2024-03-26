//
//  SleepImprovementSuggestion.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Jianhua Liu on 2024/3/25.
//

import SwiftUI

struct SleepTrackerView: View {
    var body: some View {
        VStack {
            Button(action: {
                // Start sleep action
            }) {
                Text("Start Sleep")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding()

            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.yellow)

                Circle()
                    .trim(from: 0.0, to: 0.67)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(Color.yellow)
                    .rotationEffect(Angle(degrees: 270))
            }
            .frame(width: 150, height: 150)
            .padding()
            
            // Add more components as needed
            
            Spacer()
        }
        .navigationTitle("Weekly Overview")
    }
}
