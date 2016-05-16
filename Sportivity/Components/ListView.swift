//
//  ListView.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 16.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import UIKit


class ListView : UIView {
    
    var dataSource: ListViewDataSource?
    var cellHeight: CGFloat = 30
    var interspace: CGFloat = 10
    
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
        
        let data = self.dataSource!.dataForListView()
        let unit: String = self.dataSource!.unitForListView()
        
        for (i, (name, value)) in data.enumerate() {
            let rect = CGRect(x: 20 + self.cellHeight, y: 10+CGFloat(CGFloat(i)*(self.cellHeight+self.interspace))+self.cellHeight/2.0, width: 5, height: 5)
            //let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
            let path = UIBezierPath(ovalInRect: rect)
            UIColor.grayColor().setFill()
            path.fill()
            
            let rect2 = CGRect(x: 10+self.cellHeight*2, y: 10+CGFloat(CGFloat(i)*(self.cellHeight+self.interspace)), width: 200, height: self.cellHeight)
            let label = UILabel(frame: rect2)
            //let percent = String(format: "%.1f", value / valuesSum * 100)
            label.text = "\(name): \(Int(value)) \(unit)"
            addSubview(label)
        }
    }
    
}


protocol ListViewDataSource {
    
    func dataForListView() -> [(String, Double)]
    //func colorsForListView() -> [UIColor]
    func unitForListView() -> String
}

