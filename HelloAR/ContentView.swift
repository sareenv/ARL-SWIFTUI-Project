//
//  ContentView.swift
//  HelloAR
//
//  Created by DataBunker on 2022-11-14.
//

import SwiftUI
import UIKit

struct ContentView : View {
    
    @State private var models: [ObjectModel] = [
        
        .init(name: "Lunar Rover", image: "https://upload.wikimedia.org/wikipedia/commons/e/ed/Apollo15LunarRover.jpg", modelUrl: "LunarRover", description: "A lunar rover or Moon rover is a space exploration vehicle designed to move across the surface of the Moon."),
        
        
        
        .init(name: "Cosmonaut Suit", image: "https://s.yimg.com/uu/api/res/1.2/V5FfZ79XXZH3QOhtd1lPGw--~B/Zmk9ZmlsbDtoPTU0OTt3PTg3NTthcHBpZD15dGFjaHlvbg--/https://media-mbst-pub-ue1.s3.amazonaws.com/creatr-uploaded-images/2022-09/b43bd9a0-2f4a-11ed-bf5e-f104462dd406.cf.jpg", modelUrl: "CosmonautSuit", description: " It is a series of semi-rigid one-piece space suit models designed and built by NPP Zvezda. They have been used for spacewalks (EVAs) in the Russian space program, the successor to the Soviet space program, and by space programs of other countries"),
        
        
            
        .init(name: "The HAB", image: "https://developer.apple.com/augmented-reality/quick-look/models/hab/hab_2x.png", modelUrl: "hab_en", description: "The SPACEHAB double module is a pressurized, mixed-cargo carrier which supports various quantities, sizes, and locations of experiment hardware.")
        
    ]
    
    @State private var staticModels: [ObjectModel] = [
        .init(name: "Volcano Model", image: "https://cdn.britannica.com/34/231234-050-5B2280BB/volcanic-eruption-Antigua-Guatemala-volcano.jpg", modelUrl: "VOLCANO", description: "A volcano is a rupture in the crust of a planetary-mass object, such as Earth, that allows hot lava")
    ]
    
    @State private var searchText = ""
    
    var searchResults: [ObjectModel]  {
        if(searchText.isEmpty) {
            return models
        } else {
            return [models, staticModels].reduce([],+).filter { model in
                return model.name.contains(searchText)
            }
        }
    }
    
    
    var body: some View {
      
            NavigationView {
                List {
                    Section("Space Interactive Models") {
                        ForEach(searchResults, id: \.id) { record in
                            NavigationLink {
                                ModelDetail(model: record)
                            } label: {
                                HStack {
                                    AsyncImage(url: URL(string: record.image)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }.frame(width: 120, height: 120)
                                        .cornerRadius(12)

                                    VStack(alignment: .leading) {
                                        
                                        Text(record.name)
                                            .font(.headline)
                                        Text(record.description)
                                            .font(.body)
                                            .lineLimit(3)
                                    }
                                }
                            }

                            
                        }
                    }
                    
                    Section("Static Learning Models") {
                        ForEach(staticModels, id: \.id) { record in
                            NavigationLink {
                                ModelDetail(model: record)
                            } label: {
                                HStack {
                                    AsyncImage(url: URL(string: record.image)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }.frame(width: 120, height: 120)
                                        .cornerRadius(12)

                                    VStack(alignment: .leading) {
                                        
                                        Text(record.name)
                                            .font(.headline)
                                            
                                        Text(record.description)
                                            .font(.body)
                                            .lineLimit(2)
                                    }
                                }
                            }

                            
                        }
                    }
                    
                }
                .frame(maxHeight: .infinity)
                .navigationTitle("Home")
                .searchable(text: $searchText)
            }
    }
}


struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .ignoresSafeArea(.all)
    }
}
