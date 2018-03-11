//
//  GlyphHelper.swift
//  StarterProject
//
//  Created by Strat Aguilar on 11/6/17.
//  Copyright © 2017 Strat Aguilar. All rights reserved.
//

import UIKit


class GlyphHelper{
  
  let font: VectorFont
  private var imageCache: [Int: UIImage] = [:]
  
  init(font: VectorFont){
    self.font = font
  }
  
  func getImage(glyph: VectorGlyph, fontSize: CGFloat, color: UIColor) -> UIImage?{
    guard let hexColor = hexStringFrom(color: color) else{
      return nil
    }

    if let image = imageCache[glyph.hashValue]{
      return image
    }
    
    let screenScale = UIScreen.main.scale
    let filename = String(format: "RNVectorIcons_%@_%hu_%.f%@@%.fx.png", font.rawValue, glyph.rawValue, fontSize, hexColor, screenScale)
    
    var tempURL = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    tempURL.appendPathComponent(filename)

    let filePath = tempURL.absoluteString
    
    if !FileManager.default.fileExists(atPath: filePath), let selectedFont = UIFont(name: font.rawValue, size: fontSize){
      // No cached icon exists, we need to create it and persist to disk
  
       let attributedString = NSAttributedString(string: glyph.rawValue, attributes: [NSAttributedStringKey.font: selectedFont, NSAttributedStringKey.foregroundColor: color])

      
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
  
  
  private func hexStringFrom(color: UIColor) -> String?{
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
  private func addImageToCache(glyph: VectorGlyph, image: UIImage?) -> Bool{
    guard let image = image else{
      return false
    }
    
    self.imageCache[glyph.hashValue] = image
    
    return true
  }
  
  enum VectorFont: String{
    case ionic = "Ionicons"
  }
  
  enum VectorGlyph: String{
    case camera = "\u{f118}"
  }
  
}
