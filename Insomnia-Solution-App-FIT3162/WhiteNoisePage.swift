//
//  HomePage.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Ching Yee Selina Wong on 16/3/2024.
//

import SwiftUI

// Define a custom struct to hold the icon and label, and conform to Identifiable
struct IconLabelPair: Identifiable {
    let id = UUID() // This provides a unique ID for each IconLabelPair
    var label: String
    var icon: String
}

struct WhiteNoisePage: View {
    // Use an optional UUID to track the selected item
        @State private var selectedItem: UUID?
    
    // Load the items from the plist
    let items: [IconLabelPair] = {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        var plistData: [String: String] = [:]
        var items: [IconLabelPair] = []
        
        if let plistPath = Bundle.main.path(forResource: "WhiteNoiseProperty", ofType: "plist"),
           let plistXML = FileManager.default.contents(atPath: plistPath) {
            do {
                plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                       options: .mutableContainersAndLeaves,
                                                                       format: &propertyListFormat) as! [String: String]
                items = plistData.map { IconLabelPair(label: $0.key, icon: $0.value) }
            } catch {
                print("Error reading plist: \(error), format: \(propertyListFormat)")
            }
        }
        return items
    }()
    
    let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // Adjust the count for the number of columns
    var body: some View {
        ScrollView {
            Text("White Noise")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.top, 1)
            
            Spacer(minLength: 20)
            
            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 30) {
                ForEach(items) { item in
                    Button(action: {
                        if selectedItem == item.id {
                            // If the selected item is clicked again, stop the music and clear the selection
                            SoundManager.audioPlayer?.stop()
                            selectedItem = nil
                        } else {
                            // Play the new sound and update the selected item
//                            SoundManager.playSound(soundFileName: item.label)
                            selectedItem = item.id
                        }
                    }) {
                        VStack {
                            ImageOrIconView(item: item)
                                .overlay(
                                    Circle()
                                        .stroke(selectedItem == item.id ? Color.blue : Color.clear, lineWidth: 3) // Blue border for the selected item
                                )
                                .clipShape(Circle()) // Ensure the overlay is clipped to a circular shape
                                .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove any default button styling provided by SwiftU
                            Text(item.label)
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct ImageOrIconView: View {
    let item: IconLabelPair

    var body: some View {
        if let _ = UIImage(named: item.icon) {
            ZStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 70, height: 70)
                Image(item.icon) // Use the Image view initializer with the name of the image.
                    .resizable() // Make the image resizable.
                    .frame(width: 50, height: 50) // Set the frame as needed.
            }
        } else {
            Image(systemName: item.icon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 70, height: 70) // Adjust size as needed
                .background(Circle().fill(Color.gray))
        }
    }
}

// Just for developing test, will remove when integrating with other part, as white noise is not the home page
// @main will make the page become the initial page when stating the app
@main
struct YourAppName: App {
    var body: some Scene {
        WindowGroup {
            WhiteNoisePage() // Your root SwiftUI view
        }
    }
}

// For preview on canvas
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        WhiteNoisePage()
    }
}


