//
//  ParkDetailView.swift
//  Parks
//
//  Created by Admin on 3/23/24.
//

import Foundation
import SwiftUI
import MapKit

struct ParkDetailView: View {
    
    let park: Park // <-- park property to allow for passing in a park when the detail is presented

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) { // Aligns vertical views to the leading edge with 16pt spacing between views
                Text(park.fullName)
                    .font(.largeTitle)
                Text(park.description)
            }
            .padding()

            // TODO: Add horizontal scrolling images
            ScrollView(.horizontal) { // <-- Create a horizontally scrolling scroll view
                HStack(spacing: 16) { // <-- Use an HStack to arrange views horizontally with 16pt spacing between each view
                    ForEach(park.images) { image in // <-- Add ForEach to iterate over the park's images.
                        
                        // TODO: Create Async Image view
                        Rectangle()
                               .aspectRatio(7/5, contentMode: .fit) // <-- Set aspect ratio 7:5
                               .containerRelativeFrame(.horizontal, count: 9, span: 8, spacing: 16) // <-- Size the views relative to the container (spacing matches HStack spacing)
                               .overlay {
                                   AsyncImage(url: URL(string: image.url)) { image in
                                       image
                                           .resizable()
                                           .aspectRatio(contentMode: .fill)
                                   } placeholder: {
                                       Color(.systemGray4)
                                   }
                               }
                               .cornerRadius(16)
                    }.safeAreaPadding(.horizontal) // <-- Similar to regular padding, however ony affects scroll view insets, allowing scroll view to scroll to edge

                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)

            
            if let latitude = Double(park.latitude), let longitude = Double(park.longitude) {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                Map(initialPosition: .region(.init(center: coordinate, latitudinalMeters: 1_000_000, longitudinalMeters: 1_000_000))) {
                    Marker(park.name, coordinate: coordinate)
                        .tint(.purple)
                }
                .aspectRatio(1, contentMode: .fill)
                .cornerRadius(12)
                .padding()
            }
        }
    }
}

#Preview {
    ParkDetailView(park: Park.mocked)
}
