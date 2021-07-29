//
//  SplashVC.swift
//  MovieApp
//
//  Created by Francisco Garcia on 27/07/21.
//

import UIKit

public class SplashVC: UIViewController {
    
    // MARK: LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationVC") as! UINavigationController
            self.present(resultViewController, animated:true, completion:nil)
        }
    }
}
