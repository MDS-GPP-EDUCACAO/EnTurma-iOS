
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
    
    convenience init(jsonObject : NSDictionary){
        self.init()
        self.parseJSONToRanking(jsonObject)
    }
    
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
            .MenuItemFont(UIFont().pagerMenuItemFont),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(false),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0)
            
        ]
        
        let pageMenuFrame = CGRectMake(0, 0, view.bounds.width, self.view.bounds.height)
        
        pageMenu = CAPSPageMenu(viewControllers: pagerMenuControllersArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
    }
    
    func parseJSONToRanking(jsonObject : NSDictionary){
        var distortion = jsonObject.objectForKey("distortion_list") as! NSArray
        var evasion = jsonObject.objectForKey("evasion_list") as! NSArray
        var performance = jsonObject.objectForKey("peformance_list") as! NSArray
        var ideb = jsonObject.objectForKey("ideb_list") as! NSDictionary
        
        var distortionParsed = self.serializeDataToDictionary(distortion, key: "distortion")
        var evasionParsed = self.serializeDataToDictionary(evasion, key: "evasion")
        var performanceParsed = self.serializeDataToDictionary(performance, key: "peformance")
        var idebParsed : [Dictionary<String,String>] = []
        
        if (ideb.objectForKey("status") as! String)  == "avaliable"{
            idebParsed = self.serializeDataToDictionary(ideb.objectForKey("ideb") as! NSArray, key: "score")
        }
        
        self.allRankedStates = ["evasion" : evasionParsed, "performance" : performanceParsed, "distortion" : distortionParsed, "ideb" : idebParsed]
        
    }
    
    func serializeDataToDictionary(rate: NSArray, key : String) -> [Dictionary<String,String>]{
        var parsedJSON: [Dictionary<String,String>] = []
        
        for currenteRate in rate{
            var currentParsedObject : Dictionary<String,String> = [:]
            currentParsedObject["stateName"] = self.getStateFromID(currenteRate.objectForKey("state_id") as! Int)
                var score = currenteRate.objectForKey(key) as! Double
            currentParsedObject["stateScore"] = "\(score)"

            parsedJSON.append(currentParsedObject)
        }
        return parsedJSON
    }

    func getStateFromID(stateId: Int) -> String{
        var states = ["AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"]
        return states[stateId-1]
    }

}
