//
//  Notes.swift
//  Notes
//
//  Created by  on 23/11/2017.
//  Copyright © 2017 IUT. All rights reserved.
//

import Foundation

class Notes{
    var id: Int16
    var title: String
    var date: Date!
    var content: String?
    var latitude: Float?
    var longitude: Float?
    
    
    init(id: Int16,title: String, date: Date, content: String, latitude: Float, longitude: Float) {
        self.id = id
        self.title = title
        self.date = date
        self.content = content
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    init(id: Int16,title: String, date: Date, content: String){
        self.id = id
        self.title = title
        self.date = date
        self.content = content
    }
}
