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
    @IBOutlet weak var noRakingView: UIView!
    var graphDescriptionString: String!
    var statesToShow: NSArray!
    var descriptionButtonTitle: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDescriptionButton.addTarget(self, action: "showDataDescription:", forControlEvents: UIControlEvents.TouchUpInside)
        dataDescriptionButton.setTitle(descriptionButtonTitle, forState: .Normal)
        
        if self.statesToShow.count == 0 {
            self.tableView.hidden = true
            self.noRakingView.hidden = false
        }else{
            self.tableView.hidden = false
            self.noRakingView.hidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesToShow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var isChampion = true
        if indexPath.row == 0{
            
            isChampion = false
            
        }
        var currentState = statesToShow.objectAtIndex(indexPath.row) as! NSDictionary
        var stateName = currentState.objectForKey("stateName") as! String
        var stateScore = currentState.objectForKey("stateScore") as! String
        
        var cell: RankingCell = self.tableView.dequeueReusableCellWithIdentifier("RankingCell") as! RankingCell
        
        
        cell.setupRankingCell(stateName, stateScore: NSString(format: "%@%%", stateScore) as String, isChampion: isChampion, statePosition: NSString(format: "%d°",indexPath.row+1) as String)
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
