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

struct HomePage: View {
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
            // The title
            Text("White Noise")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Aligns text to the top
                .padding(.top, 1) // Adds padding at the top to ensure it's below the Dynamic Island
            Spacer(minLength: CGFloat(20))
            
            // Buttons
            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 30) {
                ForEach(items) { item in
                    VStack {
                        // Attempt to create a UIImage to check if the image exists.
                        Button(action: {
                            // Handle the button tap
                            SoundManager.playSound(soundFileName: item.label)
                        }) {
                            // Provide the button's label view
                            if UIImage(named: item.icon) != nil {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 70, height: 70)
                                    Image(item.icon) // Use the Image view initializer with the name of the image.
                                        .resizable() // Make the image resizable.
                                        .frame(width: 50, height: 50) // Set the frame as needed.
                                }
                            } else {
                                Image(systemName: item.icon) // Use your own images if these are custom
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 70) // Adjust size as needed
                                    .background(Circle().fill(Color.gray))
                            }
                        }

                        Text(item.label)
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
            }
            .padding()
        }
        .background(Color.black) // Set the background color of your entire
    }
}

struct ImageOrIconView: View {
    let item: IconLabelPair

    var body: some View {
        if let uiImage = UIImage(named: item.icon) {
            Image(uiImage: uiImage)
                .resizable() // Make the image resizable.
                .frame(width: 70, height: 70) // Set the frame as needed.
        } else {
            Image(systemName: item.icon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 70, height: 70) // Adjust size as needed
                .background(Circle().fill(Color.gray))
        }
    }
}

@main
struct YourAppName: App {
    var body: some Scene {
        WindowGroup {
            HomePage() // Your root SwiftUI view
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}


