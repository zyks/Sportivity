//
//  DonutChart.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 15.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//


import UIKit


class DonutChart : UIView {
    
    var dataSource: DonutChartDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let data = self.dataSource!.dataForDonutChart()
        guard data.count > 0 else { return }
        
        let sum = data.values.reduce(0, combine: +)
        let colors = self.generateColors(data.count)
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height) * 0.9
        let chartWidth: CGFloat = 50
        var prefixSum = 0.0
        
        for (i, (_, value)) in data.enumerate() {
            let startAngle: CGFloat = CGFloat(prefixSum * 2 * M_PI / sum)
            let endAngle: CGFloat = CGFloat((prefixSum + value) * 2 * M_PI / sum)
            prefixSum += value
            
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius/2 - chartWidth/2,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            path.lineWidth = chartWidth
            colors[i].setStroke()
            
            path.stroke()
        }
    }
    
    func generateColors(number: Int) -> [UIColor] {
        var colors = [UIColor]()
        
        for i in 0..<number {
            let newColor = UIColor.init(hue: CGFloat(i) / CGFloat(number), saturation: 0.4, brightness: 0.9, alpha: 1.0)
            colors.append(newColor)
        }
        
        return colors
    }
    
}


protocol DonutChartDataSource {
    
    func dataForDonutChart() -> [String: Double]
}

