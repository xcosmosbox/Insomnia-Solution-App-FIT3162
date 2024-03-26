//
//  PhysicalVisualisation.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Niloy Shehrin on 26/3/2024.
//

import SwiftUI
import SwiftUICharts


struct PhysicalVisualisation: View {
    @State private var selectedTab = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                RingsChart()
                        .data([80,43]) // steps out of 10000 and hours out of 8
                        .chartStyle(ChartStyle(backgroundColor: .white,
                                               foregroundColor: ColorGradient(.purple, .blue)))

                                .padding()
                                .frame(maxHeight: geometry.size.height / 2) // Adjust the height of TabView
                
                // Custom tab bar
                CustomTabBar(selectedTab: $selectedTab)
                
                TabView(selection: $selectedTab) {
                    Text("Steps content")
                        .tag(0)
                    
                    Text("Active Hours Content")
                        .tag(1)
                    
                    // Add more tab content if new sections added to visualisation
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom) // Ensure tab bar is not obstructed by safe area
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarButton(imageName: "1.square.fill", text: "Steps", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabBarButton(imageName: "2.square.fill", text: "Active Hours", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            // Add more tab bar buttons if needed by dubplication
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding()
    }
}

struct TabBarButton: View {
    let imageName: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: imageName)
                Text(text)
            }
            .foregroundColor(isSelected ? .blue : .gray)
        }
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicalVisualisation()
    }
}
