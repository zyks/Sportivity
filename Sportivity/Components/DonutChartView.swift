//
//  DonutChartView.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 16.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import UIKit


class DonutChartView : UIView {
    
    var dataSource: DonutChartViewDataSource?
    var donutWidth: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    override func drawRect(rect: CGRect) {
        guard self.dataSource != nil else {
            return
        }
        
        let center = CGPoint(x: bounds.width/2, y: bounds.width/2)
        let radius: CGFloat = bounds.width * 0.85 / 2
        var prefixSum = 0.0
        let data = self.dataSource!.dataForDonutChart()
        let colors = self.generateColors(data.count)
        let valuesSum = data.values.reduce(0, combine: +)
        
        for (i, (name, value)) in data.enumerate() {
            let startAngle: CGFloat = CGFloat(prefixSum * 2 * M_PI / valuesSum)
            let endAngle: CGFloat = CGFloat((prefixSum + value) * 2 * M_PI / valuesSum)
            prefixSum += value
            
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius - self.donutWidth/2.0,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            path.lineWidth = self.donutWidth
            colors[i].setStroke()
            
            path.stroke()
            
            let xOffset: CGFloat = -0.01 * bounds.width * CGFloat(name.characters.count)
            
            let labelOriginAngle = startAngle + ((endAngle - startAngle)/2.0)
            var labelOrigin = CGPoint()
            labelOrigin.x = center.x + radius * cos(labelOriginAngle) + xOffset
            labelOrigin.y = center.y + radius * sin(labelOriginAngle)
            
            let rect2 = CGRect(x: labelOrigin.x, y: labelOrigin.y, width: 300, height: 15)
            let label = UILabel(frame: rect2)
            label.text = "\(name)"
            label.numberOfLines = 0
            label.sizeToFit()
            addSubview(label)
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

protocol DonutChartViewDataSource {
    
    func dataForDonutChart() -> [String: Double]
    //func colorsForDonutView() -> [UIColor]
}
