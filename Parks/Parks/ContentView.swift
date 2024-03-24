//
//  ContentView.swift
//  Parks
//
//  Created by Admin on 3/23/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var parks: [Park] = []
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(parks) { park in
                        NavigationLink(value: park) { // <-- Pass in the park associated with the park row as the value
                            ParkRow(park: park) // <-- The park row serves as the label for the NavigationLink
                        }
                    }
                }
            }
            .navigationDestination(for: Park.self) { park in // <-- Add a navigationDestination that reacts to any Park type sent from a Navigation Link
                    ParkDetailView(park: park) // <-- Create a ParkDetailView for the destination, passing in the park
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationTitle("National Parks") // <-- Add a navigation bar title

        }
        .padding()
        .onAppear(perform: {
            Task {
                await fetchParks()
            }
        })
    }
    
    private func fetchParks() async {
        // URL for the API endpoint
        // 👋👋👋 Make sure to replace {YOUR_API_KEY} in the URL with your actual NPS API Key
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key=HyH4BCkhJEpcPL3ItGxZV7OgUbO3KVun2wRlElfk")!
        do {

            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode json data into ParksResponse type
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)

            // Get the array of parks from the response
            let parks = parksResponse.data

            // Print the full name of each park in the array
            for park in parks {
                print(park.fullName)
            }

            // Set the parks state property
            self.parks = parks

        } catch {
            print(error.localizedDescription)
        }
    }
}
    
struct ParkRow: View {
    let park: Park

    var body: some View {
        
        // Park row
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit) // <-- Dynamically size the rectangle with a 4/3 aspect ratio
        
            //.aspectRatio(16/9, contentMode: .fit)
            .overlay {
                // TODO: Get image url
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in
                    URL(string: string)
                }
                // TODO: Add AsyncImage
                AsyncImage(url: url) { image in
                       image // <-- The fetched image
                           .resizable() // <-- This allows the image to be resized
                           .aspectRatio(contentMode: .fill) // <-- Tells the image to size to fill the available space
                   } placeholder: {
                       Color(.systemGray4) // <-- A gray color to use as a placeholder while the image is loading
                   }

            }
            .overlay(alignment: .bottomLeading) { // <-- Add an overlay aligned to the bottom leading portion of the rectangle
                Text(park.name)
                    .font(.title)
                    .bold() // <-- Make the font bold
                    .foregroundStyle(.white) // <-- Change the text color to white to stand out against the black rectangle
                    .padding() // <-- Add some padding so the title is inset a bit from the edges
            }
            .cornerRadius(16) // <-- Set the corner radius for the rectangle
            .padding(.horizontal) // <-- Add padding for just the sides
    }
}
#Preview {
    ContentView()
}
