//
//  ListTableVC.swift
//  MovieApp
//
//  Created by Francisco Garcia on 27/07/21.
//

import UIKit
import Network

public class ListTableVC: UIViewController, UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate {
    
    
    // MARK: VAIABLES
    private var sections: [Sections] = []
    private var titlesPopular = [String]()
    private var titlesTopRated = [String]()
    private var titlesUpcoming = [String]()
    private var moviesPopular = [MovieInfo]()
    private var moviesTopRated = [MovieInfo]()
    private var moviesUpcoming = [MovieInfo]()
    
    private var tv = [MovieAPI.tvResults]()
    private var moviAPI = MovieAPI()
    private var flagInternet = true
    

    // MARK: CONSTANTS
    private let manager = CoreDataManager()
    private let monitor = NWPathMonitor()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // MARK: LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.flagInternet = true
            } else {
                self.flagInternet = false
            }

            print(path.isExpensive)
        }

        self.UI()

    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: METHODS
    public func UI() {
        title = "Movie & TV List"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        if (flagInternet) {
            moviAPI.fetchListMovie(type: MovieAPI().MOVIES_POPULAR, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    for i in 0..<data.count {
                        self?.titlesPopular.append(data[i].original_title!)
                        self?.moviesPopular.append(data[i])
                        if (self!.manager.isMovieRegistered(id: (data[i].id!)) != true) {
                            self!.manager.addMovie(poster_path: data[i].poster_path, overview: data[i].overview!, release_date: data[i].release_date!, id: data[i].id!, original_title: data[i].original_title!, vote_average: data[i].vote_average!, type: MovieAPI().MOVIES_POPULAR)
                        }
                    }
                    self!.sections.append(Sections(title: "Popular", objs: self!.titlesPopular))
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
            
            moviAPI.fetchListMovie(type: MovieAPI().MOVIES_TOP_RATED, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    for i in 0..<data.count {
                        
                        self?.titlesTopRated.append(data[i].original_title!)
                        self?.moviesTopRated.append(data[i])
                        if (self!.manager.isMovieRegistered(id: (data[i].id!)) != true) {
                            self!.manager.addMovie(poster_path: data[i].poster_path, overview: data[i].overview!, release_date: data[i].release_date!, id: data[i].id!, original_title: data[i].original_title!, vote_average: data[i].vote_average!, type: MovieAPI().MOVIES_TOP_RATED)
                        }
                    }
                    self!.sections.append(Sections(title: "Top Rated", objs: self!.titlesTopRated))
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
            
            moviAPI.fetchListMovie(type: MovieAPI().MOVIES_UPCOMING, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    for i in 0..<data.count {
                        self?.titlesUpcoming.append(data[i].original_title!)
                        self?.moviesUpcoming.append(data[i])
                        if (self!.manager.isMovieRegistered(id: (data[i].id!)) != true) {
                            self!.manager.addMovie(poster_path: data[i].poster_path, overview: data[i].overview!, release_date: data[i].release_date!, id: data[i].id!, original_title: data[i].original_title!, vote_average: data[i].vote_average!, type: MovieAPI().MOVIES_UPCOMING)
                        }
                    }
                    self!.sections.append(Sections(title: "Upcoming", objs: self!.titlesUpcoming))
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
        } else {
            let movies = manager.fetchMovies()
            
            for i in 0..<movies.count {
                if (movies[i].type == MovieAPI().MOVIES_POPULAR) {
                    titlesPopular.append(movies[i].original_title!)
                    moviesPopular.append(movies[i])
                } else if (movies[i].type == MovieAPI().MOVIES_TOP_RATED) {
                    titlesTopRated.append(movies[i].original_title!)
                    moviesTopRated.append(movies[i])
                } else if (movies[i].type == MovieAPI().MOVIES_UPCOMING) {
                    titlesUpcoming.append(movies[i].original_title!)
                    moviesUpcoming.append(movies[i])
                }
            }
        }
    }


    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "segueDetails") {
            let viewDetails = segue.destination as! DetailsVC
            let index = tableView.indexPathForSelectedRow!
        
            if (index.section == 0) {
                viewDetails.detailsMovie = moviesPopular[index.row]
            } else if (index.section == 1) {
                viewDetails.detailsMovie = moviesTopRated[index.row]
            } else if (index.section == 2) {
                viewDetails.detailsMovie = moviesUpcoming[index.row]
            }
       }
    }

    // MARK: DELEGATES
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "segueDetails", sender: self)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].capitalizingFirstLetter()
        return cell
    }

//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if position > tableView.contentSize.height-100-scrollView.frame.size.height {
//            moviAPI.fetchListMovie(type: MovieAPI().MOVIES_POPULAR, completion: { [weak self] result in
//                switch result {
//                case .success(let data):
//                    for i in 0..<data.count {
//                        self?.titlesPopular.append(data[i].title)
//                        self?.moviesPopular.append(data[i])
//                    }
//                    self!.sections[0].update(objs: self!.titlesPopular)
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                case .failure(_):
//                    break
//                }
//            })
//
//            moviAPI.fetchListMovie(type: MovieAPI().MOVIES_TOP_RATED, completion: { [weak self] result in
//                switch result {
//                case .success(let data):
//                    for i in 0..<data.count {
//                        self?.titlesTopRated.append(data[i].title)
//                        self?.moviesTopRated.append(data[i])
//                    }
//                    self!.sections[0].update(objs: self!.titlesTopRated)
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                case .failure(_):
//                    break
//                }
//            })
//
//            moviAPI.fetchListMovie(type: MovieAPI().MOVIES_UPCOMING, completion: { [weak self] result in
//                switch result {
//                case .success(let data):
//                    for i in 0..<data.count {
//                        self?.titlesUpcoming.append(data[i].title)
//                        self?.moviesUpcoming.append(data[i])
//                    }
//                    self!.sections[0].update(objs: self!.titlesUpcoming)
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                case .failure(_):
//                    break
//                }
//            })
//        }
//    }
}

// MARK: EXTENSIONS

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
