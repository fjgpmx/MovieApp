//
//  PokeAPI.swift
//  PokeApp
//
//  Created by Francisco Garcia on 24/07/21.
//

import UIKit

public class MovieAPI {
    
    // MARK: VARIABLES
    private var pagination = 1
    private var PagesMoviePopular = 1000
    private var PagesMovieTopRate = 1000
    private var PagesMovieUpcoming = 1000
    
    // MARK: CONSTANTS
    internal let MOVIES_POPULAR = 1
    let MOVIES_TOP_RATED = 2
    let MOVIES_UPCOMING = 3
    let MOVIES_VIDEOS = 4
    let TV_POPULAR = 5
    let TV_TOP_RATED = 6
    
    // MARK: ESTRUCTS
    struct movieResults: Codable {
        var poster_path: String?
        var adult: Bool
        var overview: String
        var release_date: String
        var genre_ids: [Int]
        var id: Int
        var original_title: String
        var original_language: String
        var title: String
        var backdrop_path: String?
        var popularity: Double
        var vote_count: Int
        var video: Bool
        var vote_average: Double
    }
    
    struct  movieGeneral: Codable {
        var page: Int
        var results: [movieResults]
        var total_results: Int
        var total_pages: Int
    }
    
    struct tvResults: Codable {
        var poster_path: String?
        var popularity: Double
        var id: Int
        var backdrop_path: String?
        var vote_average: Double
        var overview: String
        var first_air_date: String
        var origin_country: [String]
        var genre_ids: [Int]
        var original_language: String
        var vote_count: Int
        var name: String
        var original_name: String
    }
    
    struct tvGeneral: Codable {
        var page: Int
        var results: [tvResults]
        var total_results: Int
        var total_pages: Int
    }
    
    struct videoGeneral: Codable {
        var id: Int
        var results: videoResults
    }
    
    struct videoResults: Codable {
        var id: String
        var iso_639_1: String
        var iso_3166_1: String
        var key: String
        var name: String
        var site: String
        var size: Int
        var type: String
    }
    
    
    // MARK: METHODS
    func fetchListMovie(type: Int, completion: @escaping (Result<[MovieInfo], Error>) -> Void) {
        
        var url: URL?
    
        switch type {
            case MOVIES_POPULAR:
                url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=07bc297ec9031636f649f215d579c303&language=en-US&page=\(pagination)")
            case MOVIES_TOP_RATED:
                url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=07bc297ec9031636f649f215d579c303&language=en-US&page=\(pagination)")
            case MOVIES_UPCOMING:
                url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=07bc297ec9031636f649f215d579c303&language=en-US&page=\(pagination)")
            default:
                return
        }
        
        switch type {
            case MOVIES_POPULAR:
                if (pagination == PagesMoviePopular) {
                    return
                }
            case MOVIES_TOP_RATED:
                if (pagination == PagesMovieTopRate) {
                    return
                }
            case MOVIES_UPCOMING:
                if (pagination == PagesMovieUpcoming) {
                    return
                }
            default:
                return
        }
        
        if let unwrappedURL = url {
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let content = try decoder.decode(movieGeneral.self, from: data)
                        //print ("Contenido", content.page, content.total_pages )
                        
                        self.pagination = content.page + 1
                        self.PagesMoviePopular = content.total_pages
                        
                        var aux: [MovieInfo] = []
                        for i in 0..<content.results.count {
                            let aux2 = MovieInfo(poster_path: content.results[i].poster_path, overview: content.results[i].overview, release_date: content.results[i].release_date, id: content.results[i].id, original_title: content.results[i].original_title, vote_average: content.results[i].vote_average, type: type)
                            aux.append(aux2)
                        }
                        
                        completion(.success(aux))
                    }
                    catch {
                        print ("Error converting json")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchListTV(type: Int, completion: @escaping (Result<[tvResults], Error>) -> Void) {
        
        var url: URL?
    
        switch type {
            case TV_POPULAR:
                url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=07bc297ec9031636f649f215d579c303&language=en-US&page=1")
            case TV_TOP_RATED:
                url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=07bc297ec9031636f649f215d579c303&language=en-US&page=1")
            default:
                return
        }
        
        if let unwrappedURL = url {
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let content = try decoder.decode(tvGeneral.self, from: data)
                        print ("Contenido", content.page, content.total_pages )
                        
                        completion(.success(content.results))
                    }
                    catch {
                        print ("Error converting json")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchVideo(idMovies: Int, completion: @escaping (Result<videoResults, Error>) -> Void) {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(idMovies)/videos?api_key=07bc297ec9031636f649f215d579c303&language=en-US")
    
        
        if let unwrappedURL = url {
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let content = try decoder.decode(videoGeneral.self, from: data)
                        print ("Contenido", content.id, content.results )
                        
                        completion(.success(content.results))
                    }
                    catch {
                        print ("Error converting json")
                    }
                }
            }
            dataTask.resume()
        }
    }

}

