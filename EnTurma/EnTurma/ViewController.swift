//
//  ViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/10/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//====================================graphs data: json response ======================

        //dados do ideb
        var gradesIdeb = NSArray(objects:  "2°ano","4°ano")
        var firstClassScoresIdeb = NSArray(objects: 10,20)
        var secondClassScoresIdeb = NSArray(objects: 100,2)
        
        //dados dos indices
        var grades = NSArray(objects: "1°ano", "2°ano","3°ano", "4°ano","5°ano","6°ano")
        
        var firstClassScores = NSArray(objects: 10,20,10,50,30,100)
        var secondClassScores = NSArray(objects: 25,67,2,78,12,24)

        var firstClassScoresPerformance = NSArray(objects: 10,20,10,50,30,100)
        var secondClassScoresPerformane = NSArray(objects: 25,67,2,78,12,24)
        
        var firstClassScoresDistortion = NSArray(objects: 10,20,10,50,30,100)
        var secondClassScoresDistortion = NSArray(objects: 25,67,2,78,12,24)
        
//====================================plot double line graph ======================
        var pageCompareGraph = PagerGraphViewController(compareGradesIdeb: gradesIdeb, firstClassScoresIdeb: firstClassScoresIdeb, secondClassScoresIdeb: secondClassScoresIdeb,indexGrades: grades, firstClassEvasionScores: firstClassScores, secondClassEvasionScores: secondClassScores, firstClassPerformanceScores: firstClassScoresPerformance, secondClassPerformanceScores: secondClassScoresPerformane, firstClassDistortionScores: firstClassScoresDistortion, secondClassDistortionScores: secondClassScoresDistortion)

        pageCompareGraph.view.frame = CGRectMake(0, 0, view.frame.width, view.frame.width)
        addChildViewController(pageCompareGraph)
        view.addSubview(pageCompareGraph.view)
        pageCompareGraph.didMoveToParentViewController(self)
        
//====================================plot single line graph ======================
        var pageReportGraph = PagerGraphViewController(reportGradesIdeb: gradesIdeb, firstClassScoresIdeb: firstClassScoresIdeb, indexGrades: grades, firstClassEvasionScores: firstClassScores, firstClassPerformanceScores: firstClassScoresPerformance, firstClassDistortionScores: firstClassScoresDistortion)

        pageReportGraph.view.frame = CGRectMake(0, 300, view.frame.width, view.frame.width)
        addChildViewController(pageReportGraph)
        view.addSubview(pageReportGraph.view)
        pageReportGraph.didMoveToParentViewController(self)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

