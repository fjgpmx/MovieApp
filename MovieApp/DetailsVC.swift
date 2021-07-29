//
//  DetailsVC.swift
//  MovieApp
//
//  Created by Francisco Garcia on 28/07/21.
//

import UIKit

public class DetailsVC: UIViewController {
    
    // MARK: VARIABLES
    var detailsMovie: MovieInfo?
    private var moviAPI = MovieAPI()
    private let manager = CoreDataManager()
    
    // MARK: OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblRelease: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    
    
    
    // MARK: LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UI()
    }

    // MARK: METHODS
    public func UI() {
        
        lblTitle.text = detailsMovie?.original_title!
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(detailsMovie!.poster_path!)")
        
        if let data = try? Data(contentsOf: url!) {
            imgPoster.image = UIImage(data: data)
        }
        lblOverview.text = "RESUME: \(detailsMovie!.overview!)"
        lblRelease.text = "RELEASE DATE: \(detailsMovie!.release_date!)"
        lblVote.text = "QUALIFICATION: \(detailsMovie!.vote_average!)"

    }
}


// MARK: EXTENSIONS
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage? {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image
    }
}
