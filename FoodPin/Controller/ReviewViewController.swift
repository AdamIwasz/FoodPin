//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 28/09/2022.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var exitButton: UIButton!
    
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backgroundImageView.image = UIImage(data: restaurant.image)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: -500)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        for rateButton in rateButtons{
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
        exitButton.transform = moveUpTransform
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
            self.exitButton.transform = .identity
        }, completion: nil)
        
        for rateButton in rateButtons{
            UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                rateButton.alpha = 1.0
                rateButton.transform = .identity
            }, completion: nil)
        }
        
    }

}
