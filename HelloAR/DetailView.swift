//
//  DetailView.swift
//  HelloAR
//
//  Created by DataBunker on 2022-11-24.
//

import SwiftUI

struct ModelDetail: View {
    
    var model: ObjectModel
    @State private var isPresented: Bool = false
    
    var body: some View {
        ScrollView {
          
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: model.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.frame(height: 300)
                
                Group {
                    Text(model.name)
                        .font(.system(size: 25, weight: .semibold))
                    Text(model.description)
                    
                    
                } .padding(8)
                
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Experience the Reality")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        
                        .frame(maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .cornerRadius(5)
                .background(.green)
                .sheet(isPresented: $isPresented) {
                    ARViewContainer(modelName: model.modelUrl)
                }
                
            }
            
            .navigationTitle(model.name)
            
            .padding(.horizontal)
        }
            
        
    }
}

struct ModelDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ModelDetail(model: .init(name: "Cosmonaut Suit", image: "https://s.yimg.com/uu/api/res/1.2/V5FfZ79XXZH3QOhtd1lPGw--~B/Zmk9ZmlsbDtoPTU0OTt3PTg3NTthcHBpZD15dGFjaHlvbg--/https://media-mbst-pub-ue1.s3.amazonaws.com/creatr-uploaded-images/2022-09/b43bd9a0-2f4a-11ed-bf5e-f104462dd406.cf.jpg", modelUrl: "", description: " It is a series of semi-rigid one-piece space suit models designed and built by NPP Zvezda. They have been used for spacewalks (EVAs) in the Russian space program, the successor to the Soviet space program, and by space programs of other countries")).ignoresSafeArea(.all)
        }
        
    }
}

