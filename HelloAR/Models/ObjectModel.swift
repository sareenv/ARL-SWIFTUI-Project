//
//  ObjectModel.swift
//  HelloAR
//
//  Created by DataBunker on 2022-11-24.
//

import Foundation

struct ObjectModel: Identifiable{
    var id = UUID()
    var name: String
    var image: String
    var modelUrl: String
    var description: String
}
