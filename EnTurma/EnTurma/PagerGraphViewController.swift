//
//  ViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/10/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Charts



struct GraphTitles {
    static let evasion = "Evasão"
    static let distortion = "Distorção"
    static let performance = "Rendimento"
    static let ideb = "IDEB"
    
}

class PagerGraphViewController: UIViewController, ChartViewDelegate, CAPSPageMenuDelegate {
    
    private var pageMenu: CAPSPageMenu?
    private var chartViewFrame: CGRect!
    private var pagerMenuControllersArray: [UIViewController]!
    
    var gradesIdeb: NSArray!
    var firstClassScoresIdeb: NSArray!
    var secondClassScoresIdeb: NSArray!
    var indexGrades: NSArray!
    var firstClassEvasionScores : NSArray!
    var secondClassEvasionScores : NSArray!
    var firstClassDistortionScores : NSArray!
    var secondClassDistortionScores : NSArray!
    var firstClassPerformanceScores : NSArray!
    var secondClassPerformanceScores : NSArray!
    
    convenience init(compareGradesIdeb: NSArray, firstClassScoresIdeb: NSArray, secondClassScoresIdeb: NSArray, indexGrades: NSArray , firstClassEvasionScores: NSArray, secondClassEvasionScores: NSArray , firstClassPerformanceScores: NSArray, secondClassPerformanceScores: NSArray, firstClassDistortionScores: NSArray, secondClassDistortionScores: NSArray){
        
        self.init()
        self.gradesIdeb = compareGradesIdeb
        self.firstClassScoresIdeb = firstClassScoresIdeb
        self.secondClassScoresIdeb = secondClassScoresIdeb
        self.indexGrades = indexGrades
        self.firstClassDistortionScores = firstClassDistortionScores
        self.secondClassDistortionScores = secondClassDistortionScores
        self.firstClassEvasionScores = firstClassEvasionScores
        self.secondClassEvasionScores = secondClassEvasionScores
        self.firstClassPerformanceScores = firstClassPerformanceScores
        self.secondClassPerformanceScores = secondClassPerformanceScores
        
    }
    
    convenience init(reportGradesIdeb: NSArray, firstClassScoresIdeb: NSArray, indexGrades: NSArray , firstClassEvasionScores: NSArray, firstClassPerformanceScores: NSArray, firstClassDistortionScores: NSArray){
        
        self.init()
        self.gradesIdeb = reportGradesIdeb
        self.firstClassScoresIdeb = firstClassScoresIdeb
        self.indexGrades = indexGrades
        self.firstClassDistortionScores = firstClassDistortionScores
        self.firstClassEvasionScores = firstClassEvasionScores
        self.firstClassPerformanceScores = firstClassPerformanceScores
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.frame = CGRectMake(0, 20,UIScreen.mainScreen().bounds.width ,UIScreen.mainScreen().bounds.width)
        chartViewFrame = view.frame
        
        pagerMenuControllersArray  = []
        
        
        if((secondClassScoresIdeb) != nil){
            plotIdebDoubleDataGraph(gradesIdeb, firstClassScores: firstClassScoresIdeb, secondClassScores: secondClassScoresIdeb)
            plotEvasionDoubleDataGraph(indexGrades, firstClassScores: firstClassEvasionScores, secondClassScores: secondClassEvasionScores)
            plotPerformanceDoubleDataGraph(indexGrades, firstClassScores: firstClassPerformanceScores, secondClassScores: secondClassPerformanceScores)
            plotDistortionDoubleDataGraph(indexGrades, firstClassScores: firstClassDistortionScores, secondClassScores: secondClassDistortionScores)
        }else{
            
            plotIdebSingleDataGraph(gradesIdeb, firstClassScores: firstClassScoresIdeb)
            plotEvasionSingleDataGraph(indexGrades, firstClassScores: firstClassEvasionScores)
            plotPerformanceSingleDataGraph(indexGrades, firstClassScores: firstClassPerformanceScores)
            plotDistortionSingleDataGraph(indexGrades, firstClassScores: firstClassDistortionScores)
            
        }
        
        
        
        setupPagerMenu()
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        
        // Do any additional setup after loading the view, typically from a nib.
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
        
        let pageMenuFrame = CGRectMake(0, 0, view.bounds.width, self.view.bounds.width+95)
        
        pageMenu = CAPSPageMenu(viewControllers: pagerMenuControllersArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
    }
    
    func plotEvasionDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        
        var graphDescription = NSLocalizedString("evasion_description", comment: "")
        var graphTitle = GraphTitles.evasion
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: grades, y1Values: firstClassScores,y2Values: secondClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Evasão"
        pagerMenuControllersArray.append(controller)
        
        
        
    }
    
    func plotDistortionDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        var graphDescription = NSLocalizedString("distortion_description", comment: "")
        var graphTitle = GraphTitles.distortion
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: grades, y1Values: firstClassScores,y2Values: secondClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Distorção"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotPerformanceDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        var graphDescription = NSLocalizedString("performance_description", comment: "")
        var graphTitle = GraphTitles.performance
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: grades, y1Values: firstClassScores,y2Values: secondClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Rendimento"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotIdebDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        var graphDescription = NSLocalizedString("ideb_description", comment: "")
        var graphTitle = GraphTitles.ideb
        
        var barChart : UIView
        
        if grades.count > 0 {
            barChart = EnTurmaBarChartView(doubleBarGraphframe: chartViewFrame, xValues: grades, y1Values: firstClassScores, y2Values: secondClassScores, graphTitleString: graphTitle, graphTextDescription: graphDescription)
        }else{
            
            barChart = UIView(frame: chartViewFrame)
            barChart.backgroundColor = .whiteColor()
            var noIdebExceptionLabel = UILabel(frame: CGRectMake(0, barChart.center.y, barChart.frame.width, barChart.frame.height/5))
            noIdebExceptionLabel.text = "Desculpe, mais não houve IDEB nesse ano."
            noIdebExceptionLabel.textColor = .redColor()
            noIdebExceptionLabel.numberOfLines = 2
            noIdebExceptionLabel.textAlignment = .Center
            noIdebExceptionLabel.font = UIFont().charValueLabelFont
            
            barChart.addSubview(noIdebExceptionLabel)
            
        }

        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(barChart)
        controller.title = "Ideb"
        pagerMenuControllersArray.append(controller)
        
        
    }
    
    func plotEvasionSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        
        var graphDescription =  NSLocalizedString("evasion_description", comment: "")
        var graphTitle = GraphTitles.evasion
        var newChart = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Evasão"
        pagerMenuControllersArray.append(controller)
        
        
        
    }
    
    func plotDistortionSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        var graphDescription = NSLocalizedString("distortion_description", comment: "")
        var graphTitle = GraphTitles.distortion
        var newChart = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Distorção"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotPerformanceSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        var graphDescription = NSLocalizedString("performance_description", comment: "")
        var graphTitle = GraphTitles.performance
        var newChart = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Rendimento"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotIdebSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        var graphDescription = NSLocalizedString("ideb_description", comment: "")
        var graphTitle = GraphTitles.ideb
        
        var barChart : UIView
        
        if grades.count > 0 {
            barChart = EnTurmaBarChartView(singleBarGraphframe: chartViewFrame, xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle, graphTextDescription: graphDescription)
        }else{
            
            barChart = UIView(frame: chartViewFrame)
            barChart.backgroundColor = .whiteColor()
            var noIdebExceptionLabel = UILabel(frame: CGRectMake(0, barChart.center.y, barChart.frame.width, barChart.frame.height/5))
            noIdebExceptionLabel.text = "Desculpe, mais não houve IDEB nesse ano."
            noIdebExceptionLabel.textColor = .redColor()
            noIdebExceptionLabel.numberOfLines = 2
            noIdebExceptionLabel.textAlignment = .Center
            noIdebExceptionLabel.font = UIFont().charValueLabelFont
            
            barChart.addSubview(noIdebExceptionLabel)

        }
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(barChart)
        controller.title = "Ideb"
        pagerMenuControllersArray.append(controller)
        
        
    }
    
    internal static func selectXData(initialYear: Int, initialGrade: Int) -> NSArray{
        var xValues : [String] = []
        
        var numberOfGrades = 9 - initialGrade
        var numberOfYears = 2013 - initialYear
        
        var numberOfXData : Int
        if numberOfGrades > numberOfYears{
            
            numberOfXData = numberOfYears
            
        }else{
            
            numberOfXData = numberOfGrades
        }
        
        for i in 0...(numberOfXData){
            xValues.append("\(i+initialYear)")
        }
        return xValues
    }
    
    internal static func selectXDataInGrades(initialYear: Int, initialGrade: Int) -> NSArray{
        var xValues : [String] = []
        
        var numberOfGrades = 9 - initialGrade
        var numberOfYears = 2013 - initialYear
        
        var numberOfXData : Int
        if numberOfGrades > numberOfYears{
            
            numberOfXData = numberOfYears
            
        }else{
            
            numberOfXData = numberOfGrades
        }
        
        for i in 0...(numberOfXData){
            xValues.append("\(i+initialGrade)°ano")
        }
        return xValues
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

