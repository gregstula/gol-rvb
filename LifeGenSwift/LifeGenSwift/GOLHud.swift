//
//  GoLHud.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 10/4/15.
//  Copyright © 2015 Gregory D. Stula. All rights reserved.
//

import UIKit

@IBDesignable class GOLHud: UIView {

    var view: UIView!
    let nibName = "GOLHud.xib"
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupHud()
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupHud()
    }
    
    func setupHud()
    {
        // setup XIB here
        view = loadHudFromNib()
        
        /* this will be the size of your HUD in game */
        view.frame = CGRect(x: 0, y: 0, width: 250, height: 100)
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }
    
    
    func loadHudFromNib() ->UIView
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let temp = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return temp
        
    }

}
