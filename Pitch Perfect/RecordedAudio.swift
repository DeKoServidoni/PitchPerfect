//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by André Servidoni on 8/26/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject {
    
    var fileTitle : String!
    var filePath : NSURL!
    
    init(fileTitle title: String!, inPath path: NSURL) {
        fileTitle = title
        filePath = path
    }
}
