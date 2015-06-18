//
//  ViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/10/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Charts

struct GraphDescriptions {
    static let evasion = "O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb)."
    static let distortion = "O Índice de Distorção representa o percentual de alunos que se encontram em condição de distorção idade-série. O aluno que reprova ou abandona os estudos por dois anos ou mais durante a trajetória de escolarização, repetindo por consequência uma mesma série, se encontra em defasem em relação à idade considerada adequada para cada ano de estudo, de acordo com o que propõe a legislação educacional do país. Neste caso o aluno será contabilizado na situação de distorção idade-série."
    static let ideb = "O Índice de Desenvolvimento da Educação Básica (Ideb) tem o objetivo de reunir em um único indicador dois conceitos importantes para a qualidade da educação: fluxo escolar e média de desempenho nas avaliações. Ele agrega ao enfoque pedagógico dos resultados das avaliações em larga escala do Inep a possibilidade de resultados sintéticos, facilmente assimiláveis, e que permitem traçar metas de qualidade educacional para os sistemas. O indicador é calculado a partir dos dados sobre aprovação, obtidos no Censo Escolar, e médias de desempenho nas avaliações do Inep: o Seab (para unidades da federação e para o país) e a Prova Brasil (para os municípios)."
    static let performance = "O Índice de Rendimento é baseado na Anresc. A Avaliação Nacional do Redimento Escolar (Anresc) é uma avaliação criada pelo Ministério da Educação. Sendo complementar ao Sistema Nacional de Educação Básica e um dos componentes para o cálculo do Índice de Desenvolvimento da Educação Básica, a avaliação é realizada a cada dois anos e participam todos os estudantes de escolas públicas urbanas do 5º ao 9º ano em turmas com 20 ou mais alunos. A avaliação é dividida em duas provas: Língua Portuguesa e Matemática."
}


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
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 12.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(false),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0)
            
        ]
        
        let pageMenuFrame = CGRectMake(0, 0, view.bounds.width, self.view.bounds.width+95)
        
        pageMenu = CAPSPageMenu(viewControllers: pagerMenuControllersArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
    }
    
    func plotEvasionDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        
        var graphDescription = GraphDescriptions.evasion
        var graphTitle = GraphTitles.evasion
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: grades, y1Values: firstClassScores,y2Values: secondClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Evasão"
        pagerMenuControllersArray.append(controller)
        
        
        
    }
    
    func plotDistortionDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        var graphDescription = GraphDescriptions.distortion
        var graphTitle = GraphTitles.distortion
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: grades, y1Values: firstClassScores,y2Values: secondClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Distorção"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotPerformanceDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        var graphDescription = GraphDescriptions.performance
        var graphTitle = GraphTitles.performance
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: grades, y1Values: firstClassScores,y2Values: secondClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Rendimento"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotIdebDoubleDataGraph(grades: NSArray, firstClassScores: NSArray, secondClassScores: NSArray){
        
        var graphDescription = GraphDescriptions.ideb
        var graphTitle = GraphTitles.ideb
        var barChart = EnTurmaBarChartView(doubleBarGraphframe: chartViewFrame, xValues: grades, y1Values: firstClassScores, y2Values: secondClassScores, graphTitleString: graphTitle, graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(barChart)
        controller.title = "Ideb"
        pagerMenuControllersArray.append(controller)
        
        
    }
    
    func plotEvasionSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        
        var graphDescription = GraphDescriptions.evasion
        var graphTitle = GraphTitles.evasion
        var newChart = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Evasão"
        pagerMenuControllersArray.append(controller)
        
        
        
    }
    
    func plotDistortionSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        var graphDescription = GraphDescriptions.distortion
        var graphTitle = GraphTitles.distortion
        var newChart = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Distorção"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotPerformanceSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        var graphDescription = GraphDescriptions.performance
        var graphTitle = GraphTitles.performance
        var newChart = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle,graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Rendimento"
        pagerMenuControllersArray.append(controller)
        
        
        
        
    }
    
    func plotIdebSingleDataGraph(grades: NSArray, firstClassScores: NSArray){
        
        var graphDescription = GraphDescriptions.ideb
        var graphTitle = GraphTitles.ideb
        var barChart = EnTurmaBarChartView(singleBarGraphframe: chartViewFrame, xValues: grades, yValues: firstClassScores, graphTitleString: graphTitle, graphTextDescription: graphDescription)
        
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(barChart)
        controller.title = "Ideb"
        pagerMenuControllersArray.append(controller)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

