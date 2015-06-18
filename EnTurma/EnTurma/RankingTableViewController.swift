//
//  RankingTableViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/18/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit


class RankingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var dataDescriptionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var graphDescriptionString: String!
    var allRankedStates: NSDictionary!
    var statesToShow: NSArray!
    var rankDataToShowIndex: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDescriptionButton.addTarget(self, action: "showDataDescription:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        allRankedStates = [
          "evasion": [
                ["stateName":"Brasilia","stateScore":"32"],
                ["stateName":"Goias","stateScore":"32"],
            ],
           "performance": [
                ["stateName":"Formosa","stateScore":"32"],
                ["stateName":"Taguatinga","stateScore":"32"],

            ],
            "distortion": [
                ["stateName":"Anapolis","stateScore":"32"],
                ["stateName":"Pirinopolis","stateScore":"32"],

            ],
            "ideb": [
                ["stateName":"Sop","stateScore":"32"],
                ["stateName":"GOT","stateScore":"32"],
            ]
        ]
        
        setupCurrentDataToShow()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupCurrentDataToShow(){
        rankDataToShowIndex  = 0
        
        switch(rankDataToShowIndex){
            
        case 0:
            graphDescriptionString = NSLocalizedString("evasion_description", comment: "")
            statesToShow = allRankedStates.objectForKey("evasion") as! NSArray
            dataDescriptionButton.titleLabel?.text = "  Evasão"
            break;
            
        case 1:
            graphDescriptionString = NSLocalizedString("performance_description", comment: "")
            statesToShow = allRankedStates.objectForKey("performance") as! NSArray
            dataDescriptionButton.titleLabel?.text = "  Performance"

            break;
            
        case 2:
            graphDescriptionString = NSLocalizedString("distortion_description", comment: "")
            statesToShow = allRankedStates.objectForKey("distortion") as! NSArray
            dataDescriptionButton.titleLabel?.text = "  Distorção"

            break;
            
        case 3:
            graphDescriptionString = NSLocalizedString("ideb_description", comment: "")
            statesToShow = allRankedStates.objectForKey("ideb") as! NSArray
            dataDescriptionButton.titleLabel?.text = "  Ideb"

            break;
            
        default:
            graphDescriptionString = NSLocalizedString("evasion_description", comment: "")
            statesToShow = allRankedStates.objectForKey("evasion") as! NSArray
            dataDescriptionButton.titleLabel?.text = "  Evasão"

            break;
            
            
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesToShow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var isChampion = false
        if indexPath.row == 1{
            
            isChampion = true
            
        }
        var currentState = statesToShow.objectAtIndex(indexPath.row) as! NSDictionary
        var stateName = currentState.objectForKey("stateName") as! String
        var stateScore = currentState.objectForKey("stateScore") as! String
        
        var cell: RankingCell = self.tableView.dequeueReusableCellWithIdentifier("RankingCell") as! RankingCell
        
        cell.setupRankingCell(stateName, stateScore: stateScore, isChampion: isChampion, statePosition: NSString(format: "%d°",indexPath.row+1) as String)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func showDataDescription(sender: UIButton!){
        
        var textContainer = NSTextContainer(size: CGSize(width: view.window!.frame.width, height: view.window!.frame.height))
        
        var descriptionView = GraphDescriptionView(frame: view.window!.frame, descriptionText: graphDescriptionString)
        
        var visualEffect = UIBlurEffect(style:.Light)
        var visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = view.window!.frame
        
        
        
        UIView.transitionWithView(view.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            // remove the front object...
            
            // ... and add the other object
            self.view.window?.addSubview(visualEffectView)
            visualEffectView.addSubview(descriptionView)
            
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
        })
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
