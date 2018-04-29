//
//  HomeViewController.swift
//  StarterProject
//
//  Created by Strat Aguilar on 11/6/17.
//  Copyright © 2017 Strat Aguilar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Identifiable {
  
  @IBOutlet weak var testButton: UIButton?
  init(){
    super.init(nibName: HomeViewController.identifier, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  override func viewDidLoad() {
      super.viewDidLoad()
    let ionicGlyphs = IonicGlyph()
    let testImage = ionicGlyphs.getImage(glyph: .camera, fontSize: 100, color: .black)
    testButton?.setImage(testImage, for: .normal)
    testButton?.tintColor = .white
  }
  
}
