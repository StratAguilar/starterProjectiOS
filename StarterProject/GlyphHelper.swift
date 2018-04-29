//
//  GlyphHelper.swift
//  StarterProject
//
//  Created by Strat Aguilar on 11/6/17.
//  Copyright © 2017 Strat Aguilar. All rights reserved.
//

import UIKit

class GlyphLibrary {
  
  fileprivate var font: String
  fileprivate var imageCache: [Int: UIImage]
  
  fileprivate init(font: String) {
    self.font = font
    imageCache = [:]
  }
  
  private func hexStringFrom(color: UIColor) -> String? {
    guard let components = color.cgColor.components else{
      return nil
    }
    
    var baseComponents: [CGFloat] = [0,0,0]
    var index = 0
    
    while index < baseComponents.count && index < components.count{
      baseComponents[index] = components[index]
      index += 1
    }
    
    let floatComponents = baseComponents.map{ Float($0) }
    let red = lroundf(floatComponents[0] * 255)
    let green = lroundf(floatComponents[1] * 255)
    let blue = lroundf(floatComponents[2] * 255)
    return String(format: "#%02lX%02lX%02lX", red, green, blue)
    
  }
  
  @discardableResult
  private func addImageToCache(glyph: Glyph, image: UIImage?) -> Bool {
    guard let image = image else{
      return false
    }
    
    imageCache[glyph.hashVal] = image
    
    return true
  }
  
  fileprivate func getImage(glyph: Glyph, fontSize: CGFloat, color: UIColor) -> UIImage?{
    guard let hexColor = hexStringFrom(color: color) else{
      return nil
    }
    
    if let image = imageCache[glyph.hashVal]{
      return image
    }
    
    let screenScale = UIScreen.main.scale
    let filename = String(format: "RNVectorIcons_%@_%hu_%.f%@@%.fx.png", font, glyph.unicode, fontSize, hexColor, screenScale)
    
    var tempURL = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    tempURL.appendPathComponent(filename)
    
    let filePath = tempURL.absoluteString
    
    if !FileManager.default.fileExists(atPath: filePath), let selectedFont = UIFont(name: font, size: fontSize){
      
      // No cached icon exists, we need to create it and persist to disk
      var attributes = [NSAttributedStringKey: AnyObject]()
      attributes[.font] = selectedFont
      
      attributes[.foregroundColor] = UIColor.green
      let attributedString = NSAttributedString(string: glyph.unicode, attributes: attributes)
      let iconSize = attributedString.size()
      
      UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
      
      attributedString.draw(at: CGPoint(x: 0, y: 0))
      
      let iconImage = UIGraphicsGetImageFromCurrentImageContext()
      
      UIGraphicsEndImageContext()
      
      addImageToCache(glyph: glyph, image: iconImage)
      
      if let iconImage = iconImage{
        
        let imageDate = UIImagePNGRepresentation(iconImage)
        
        do{
          
          try imageDate?.write(to: tempURL)
          
        }catch(let error){
          
          print(error.localizedDescription)
          
        }
        
      }
      
      return iconImage
      
    }else{
      
      let imageFromFile = UIImage(contentsOfFile: filePath)
      
      addImageToCache(glyph: glyph, image: imageFromFile)
      
      return imageFromFile
      
    }
  }
}


class IonicGlyph: GlyphLibrary {
  
  static let fontName: String = "Ionicons"
  
  init() {
    super.init(font: IonicGlyph.fontName)
  }
  
  func getImage(glyph: Ionic, fontSize: CGFloat, color: UIColor) -> UIImage? {
    return super.getImage(glyph: glyph, fontSize: fontSize, color: color)
  }
  
  enum Ionic: String, Glyph {
    case camera = "\u{f118}"
    case roundedCheckMark = "\u{f121}"
    case checkMark = "\u{f122}"
    case chevronDown = "\u{f123}"
    case chevronLeft = "\u{f124}"
    case chevronRight = "\u{f125}"
    case chevronUp = "\u{f126}"
    
    var hashVal: Int {
      return self.hashValue
    }
    
    var unicode: String {
      return self.rawValue
    }
    
  }
}

protocol Glyph {
  var hashVal: Int { get }
  var unicode: String { get }
}
