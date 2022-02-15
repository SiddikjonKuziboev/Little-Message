//
//  MessageDM.swift
//  LittleMessenger
//
//  Created by Kuziboev Siddikjon on 2/13/22.
//

import Foundation
import UIKit
protocol ChatDelegate {
    func didSelectImage(index: IndexPath)
}

struct MessagesDM {
    var date: String
    var data: [MessageDM]
    
}

struct MessageDM {
    
    enum MediaType : String {
        case photo = "Photo"
        case audio = "Audio"
        case file = "File"
    }
    
    var type: String
    var text: String?
    var isFistUser: Int
    var time: String
    
    var image: UIImage?
    var imageHeight : Int?
    var imageWidth : Int?
    var mediaType: MediaType?
}


