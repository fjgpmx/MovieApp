//
//  CoreDataManager.swift
//  PokeApp
//
//  Created by Francisco Garcia on 25/07/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "Model")
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    func addMovie(poster_path: String?, overview: String, release_date: String, id: Int, original_title: String, vote_average: Double, type: Int) {

        let context = container.viewContext

        let movie = Movies(context: context)
        movie.poster_path = poster_path
        movie.overview = overview
        movie.release_date = release_date
        movie.id = Int64(id)
        movie.original_title = original_title
        movie.vote_average = vote_average
        movie.type = Int16(type)

        do {
            try context.save()
            print("Pelicula \(original_title) saved")
        } catch {

          print("Error guardando pelicula — \(error)")
        }
    }
    
    func fetchMovies() -> [MovieInfo] {

        let fetchRequest : NSFetchRequest<Movies> = Movies.fetchRequest()
        do {

            let result = try container.viewContext.fetch(fetchRequest)
            
            var auxMovie = [MovieInfo]()
            for i in 0..<result.count {
                let movie: MovieInfo = MovieInfo(poster_path: result[i].poster_path, overview: result[i].overview!, release_date: result[i].release_date!, id: Int(result[i].id), original_title: result[i].original_title!, vote_average: result[i].vote_average, type: Int(result[i].type))

                
                auxMovie.append(movie)
            }
            return auxMovie
        } catch {
            print("El error obteniendo Favoritos \(error)")
         }

         return []
    }
    
    func isMovieRegistered(id: Int) -> Bool {
        var isExist = false
        let fetchRequest : NSFetchRequest<Movies> = Movies.fetchRequest()
        do {

            let result = try container.viewContext.fetch(fetchRequest)

            for i in 0..<result.count {
                if (result[i].id == id) {
                    isExist = true
                }
            }
            return isExist
        } catch {
            print("El error obteniendo Peliculas \(error)")
         }

         return isExist
    }
}
