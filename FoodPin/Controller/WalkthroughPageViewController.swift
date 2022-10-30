//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 12/10/2022.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: AnyObject{
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {

    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    var pageHeadings = [String(localized: "CREATE YOUR OWN FOOD GUIDE", comment: "CREATE YOUR OWN FOOD GUIDE"), String(localized: "SHOW YOU THE LOCATION", comment: "SHOW YOU THE LOCATION"), String(localized: "DISCOVER GREAT RESTAURANTS", comment: "DISCOVER GREAT RESTAURANTS")]
    
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    
    var pageSubHeadings = [String(localized: "Pin your favorite restaurants and create your own food guide", comment: "Pin your favorite restaurants and create your own food guide"),String(localized: "Search and locate your favourite restaurant on Maps"),String(localized: "Find restaurants shared by your friends and other foodies", comment: "Find restaurants shared by your friends and other foodies")]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate.self
        dataSource.self
        
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func forwardPage(){
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}

extension WalkthroughPageViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController?{
        if index < 0 || index >= pageHeadings.count{
            return nil
        }
        
        // crate new viewController and pass suitable data
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
}

extension WalkthroughPageViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController{
                currentIndex = contentViewController.index
                
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
}
