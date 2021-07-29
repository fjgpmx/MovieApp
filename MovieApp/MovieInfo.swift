//
//  MovieInfo.swift
//  MovieApp
//
//  Created by Francisco Garcia on 29/07/21.
//

import UIKit

public class MovieInfo {
    
    var poster_path: String?
    var overview: String?
    var release_date: String?
    var id: Int?
    var original_title: String?
    var vote_average: Double?
    var type: Int?
    
    init(poster_path: String?, overview: String, release_date: String, id: Int, original_title: String, vote_average: Double, type: Int) {
        
        self.poster_path = poster_path
        self.overview = overview
        self.release_date = release_date
        self.id = id
        self.original_title = original_title
        self.vote_average = vote_average
        self.type = type
    }
}
