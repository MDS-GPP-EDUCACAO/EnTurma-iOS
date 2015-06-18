
//
//  PagerRankViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/18/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit

class PagerRankViewController: UIViewController, CAPSPageMenuDelegate {

    
    private var pageMenu: CAPSPageMenu?
    private var pagerMenuControllersArray: [UIViewController]!
    private var rankViewFrame: CGRect!
    var allRankedStates: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         view.frame = CGRectMake(0, 20,UIScreen.mainScreen().bounds.width ,UIScreen.mainScreen().bounds.height)
        rankViewFrame = view.frame
        
        pagerMenuControllersArray  = []
        
        setupRanks()
   
        
        setupPagerMenu()
        
        self.view.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRanks(){
        
        
        setupEvasionRank()
        setupPerformanceRank()
        setupDistortionRank()
        setupIdebRank()
    
    
    }
    
    func setupEvasionRank(){
        
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        let evasionRankVC = storyboard.instantiateViewControllerWithIdentifier("RankingTableView") as! RankingTableViewController
        evasionRankVC.statesToShow = allRankedStates.objectForKey("evasion") as! NSArray
        evasionRankVC.graphDescriptionString = NSLocalizedString("evasion_description", comment: "")
        evasionRankVC.title = "Evasão"
        evasionRankVC.descriptionButtonTitle = "  Evasão"
        evasionRankVC.view.frame = rankViewFrame
        pagerMenuControllersArray.append(evasionRankVC)

    }
    
    func setupPerformanceRank(){
        let storyboard = UIStoryboard(name:"Main", bundle: nil)

        let performanceRankVC = storyboard.instantiateViewControllerWithIdentifier("RankingTableView") as! RankingTableViewController
        performanceRankVC.statesToShow = allRankedStates.objectForKey("performance") as! NSArray
        performanceRankVC.graphDescriptionString = NSLocalizedString("performance_description", comment: "")
        performanceRankVC.descriptionButtonTitle = "  Rendimento"
        performanceRankVC.title = "Rendimento"

        performanceRankVC.view.frame = rankViewFrame
        pagerMenuControllersArray.append(performanceRankVC)

        
    }
    
    func setupDistortionRank(){
        let storyboard = UIStoryboard(name:"Main", bundle: nil)

        let distortionRankVC = storyboard.instantiateViewControllerWithIdentifier("RankingTableView") as! RankingTableViewController
        distortionRankVC.statesToShow = allRankedStates.objectForKey("distortion") as! NSArray
        distortionRankVC.graphDescriptionString = NSLocalizedString("distortion_description", comment: "")
        distortionRankVC.descriptionButtonTitle = "  Distorção"
        distortionRankVC.title = "Distorção"
        distortionRankVC.view.frame = rankViewFrame
        pagerMenuControllersArray.append(distortionRankVC)

    }
    
    func setupIdebRank(){
        
        let storyboard = UIStoryboard(name:"Main", bundle: nil)

        let idebRankVC = storyboard.instantiateViewControllerWithIdentifier("RankingTableView") as! RankingTableViewController
        idebRankVC.statesToShow = allRankedStates.objectForKey("ideb") as! NSArray
        idebRankVC.graphDescriptionString = NSLocalizedString("ideb_description", comment: "")
        idebRankVC.descriptionButtonTitle = "  Ideb"
        idebRankVC.title = "Ideb"
        idebRankVC.view.frame = rankViewFrame
        pagerMenuControllersArray.append(idebRankVC)
        
    }
    
    func setupPagerMenu(){
        
        
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .BottomMenuHairlineColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .MenuMargin(20.0),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .UnselectedMenuItemLabelColor(UIColor(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 12.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(false),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0)
            
        ]
        
        let pageMenuFrame = CGRectMake(0, 0, view.bounds.width, self.view.bounds.height)
        
        pageMenu = CAPSPageMenu(viewControllers: pagerMenuControllersArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
