//
//  StartSleepPage.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Jianhua Liu on 2024/3/24.
//

import SwiftUI

struct SleepTimeView: View {
    @State private var currentTime: String = ""

    var body: some View {
        VStack {
            Spacer()

            // Real Time display
            Text(currentTime)
                .font(.system(size: 60))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .onAppear(perform: {
                    self.updateTime()
                    // Sets up a timer that fires every minute
                    Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                        self.updateTime()
                    }
                })

            Text("Alarm at 7:30pm")
                .foregroundColor(.white)
                .font(.caption)

            Spacer()

            // Quit button
            Button(action: {
                // Handle quit action
            }) {
                Text("Quit")
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
                    Image("Night")
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fill) // Fill the screen while preserving aspect ratio
                        .edgesIgnoringSafeArea(.all) // Ignore safe area to extend to all edges
                )
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Sleep-2")
        .navigationBarTitleDisplayMode(.inline)
    }

    func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        currentTime = formatter.string(from: Date())
    }
}

struct SleepTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTimeView()
    }
}
