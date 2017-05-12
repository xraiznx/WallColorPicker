//
//  CompatibleColorController.swift
//  WallColor
//
//  Created by Israel Hammon on 4/21/17.
//  Copyright © 2017 Israel Hammon. All rights reserved.
//

import UIKit
class CompatibleColorController: UIViewController
{
    
    var solidcolor: UIColor? // Holds color of previously selected pixel
    var actualalpha: CGFloat? // Hold alpha value
    var hexvaluestring: String? // Holds hex value
    var rgbvaluestring: String? // Hold rgb value
    var previmage: UIImage? // Holds image from ImageDisplayViewController
    var hue: Int? // Holds calculated hue
    var saturation: Int? // Holds calculated saturation
    var value: Int? // Holds calculated value
    var actualhue: CGFloat? // Holds uncalculated hue
    var actualsaturation: CGFloat? // Holds uncalculated saturation
    var actualvalue: CGFloat? // Holds uncalculated value
    var actualcompatiblecolors : [String: Float] = [:] // Dictionary for uncalculated HSV and RGB values
    var compatiblecolors : [String: Int] = [:] // Dictionary for calculated HSV and RGB values
    @IBOutlet weak var SolidColor: UIImageView! // Image view of color selected
    @IBOutlet weak var HexValue: UILabel! // Label for hex value
    @IBOutlet weak var RGBValue: UILabel! // Label for RGB value
    
    // Image views for compatible colors
    @IBOutlet weak var CompatibleImage1: UIImageView!
    @IBOutlet weak var CompatibleImage2: UIImageView!
    @IBOutlet weak var CompatibleImage3: UIImageView!
    @IBOutlet weak var CompatibleImage4: UIImageView!
    @IBOutlet weak var CompatibleImage5: UIImageView!
    @IBOutlet weak var CompatibleImage6: UIImageView!
    
    // When back buton is pressed perfrom segue
    @IBAction func PreviousView(_ sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "PassBack", sender: nil)
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "PassBack"
        {
            let imagedisplay = segue.destination as! ImageDisplayViewController
            imagedisplay.image = previmage // Passes back image to ImageDisplayViewController
        }
    }
    
    // Changes hue to get compatible colors
    func colorchanger(block: Int)
    {
        if (block == 1) {compatiblecolors["h1"] = compatiblecolors["h1"]! + 180} // Complimentary Color
        if (block == 2) {compatiblecolors["h2"] = compatiblecolors["h2"]! + 120} // Color triad
        if (block == 3) {compatiblecolors["h3"] = compatiblecolors["h3"]! - 120} // Color triad
        if (block == 4) {compatiblecolors["h4"] = compatiblecolors["h4"]! - 30} // Adjacent Color
        if (block == 5) {compatiblecolors["h5"] = compatiblecolors["h5"]! + 30} // Adjacent Color
        if (block == 6) {compatiblecolors["h6"] = compatiblecolors["h6"]! + 150} // Split Complementary}
    }
    
    // Converts HSV to RGB
    func hsvtorgb(block: Int)
    {
        var redvalue = Float(0)
        var greenvalue = Float(0)
        var bluevalue = Float(0)
        
        let h = Float(compatiblecolors["h" + String(block)]!) // Angle in degrees [0,360] or -1 as Undefined
        let s = Float(actualcompatiblecolors["s" + String(block)]!) // Percent [0,1]
        let v = Float(actualcompatiblecolors["v" + String(block)]!)// Percent [0,1]
        if (s == 0) {redvalue = v; greenvalue = v; bluevalue = v} // If saturation is 0, set RGB to value

        let angle = (h >= 360 ? 0 : h) // If angle is greater than 360 ( error checking )
        let sector = angle / 60 // Divide hue by 60
        let i = floor(Float(sector)) // Rounds down
        let f = Float(sector) - i // Factorial part of h
        
        // Conversion formula
        let p = Float(v) * (1 - Float(s))
        let q = Float(v) * (1 - (Float(s) * f))
        let t = Float(v) * (1 - (Float (s) * (1 - f)))
                
                switch(i)
                {
                    case 0:
                        redvalue = v
                        greenvalue = t
                        bluevalue = p
                    case 1:
                        redvalue = q
                        greenvalue = v
                        bluevalue = p
                    case 2:
                        redvalue = p
                        greenvalue = v
                        bluevalue = t
                    case 3:
                        redvalue = p
                        greenvalue = q
                        bluevalue = v
                    case 4:
                        redvalue = t
                        greenvalue = p
                        bluevalue = v
                    default:
                        redvalue = v
                        greenvalue = p
                        bluevalue = q
                }
        
        actualcompatiblecolors["r" + String(block)] = redvalue // Saves uncalculated red value
        actualcompatiblecolors["g" + String(block)] = greenvalue // Saves uncalculated green value
        actualcompatiblecolors["b" + String(block)] = bluevalue // Saves uncalculated blue value
        actualcompatiblecolors["a" + String(block)] = Float(actualalpha!) // Saves alpha value
        compatiblecolors["r" + String(block)] = Int(redvalue * 255) // Saves calculated red value
        compatiblecolors["g" + String(block)] = Int(greenvalue * 255) // Saves calculated green value
        compatiblecolors["b" + String(block)] = Int(bluevalue * 255) // Saves calculated blue value
        compatiblecolors["a" + String(block)] = Int(actualalpha!)  // Saves alpha value
      
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Holds RGB and HSV in full Int form
        compatiblecolors = ["r1": 0, "g1": 0, "b1": 0,"a1": 0, "h1": hue!, "s1": saturation!, "v1":value!,"r2": 0, "g2": 0, "b2": 0,"a2": 0, "h2": hue!, "s2": saturation!, "v2": value!,"r3": 0, "g3": 0, "b3": 0,"a3": 0, "h3": hue!, "s3": saturation!, "v3": value!,"r4": 0, "g4": 0, "b4": 0,"a4": 0, "h4": hue!, "s4": saturation!, "v4": value!,"r5": 0, "g5": 0, "b5": 0,"a5": 0, "h5": hue!, "s5": saturation!, "v5": value!,"r6": 0, "g6": 0, "b6": 0,"a6": 0, "h6": hue!, "s6": saturation!, "v6": value!]
        
        // Holds RGB and HSV in uncalculated Float form
        actualcompatiblecolors = ["r1": 0, "g1": 0, "b1": 0,"a1": 0, "h1": Float(actualhue!), "s1": Float(actualsaturation!), "v1": Float(actualvalue!),"r2": 0, "g2": 0, "b2": 0,"a2": 0, "h2": Float(actualhue!), "s2": Float(actualsaturation!), "v2": Float(actualvalue!),"r3": 0, "g3": 0, "b3": 0,"a3": 0, "h3": Float(actualhue!), "s3": Float(actualsaturation!), "v3": Float(actualvalue!),"r4": 0, "g4": 0, "b4": 0,"a4": 0, "h4": Float(actualhue!), "s4": Float(actualsaturation!), "v4": Float(actualvalue!),"r5": 0, "g5": 0, "b5": 0,"a5": 0, "h5": Float(actualhue!), "s5": Float(actualsaturation!), "v5": Float(actualvalue!),"r6": 0, "g6": 0, "b6": 0,"a6": 0, "h6": Float(actualhue!), "s6": Float(actualsaturation!), "v6": Float(actualvalue!)]
        
        colorchanger(block: 1) // Calculates compatible color
        hsvtorgb(block: 1) // Changes color to rgb
        colorchanger(block: 2) // Calculates compatible color
        hsvtorgb(block: 2) // Changes color to rgb
        colorchanger(block: 3) // Calculates compatible color
        hsvtorgb(block: 3) // Changes color to rgb
        colorchanger(block: 4) // Calculates compatible color
        hsvtorgb(block: 4) // Changes color to rgb
        colorchanger(block: 5) // Calculates compatible color
        hsvtorgb(block: 5) // Changes color to rgb
        colorchanger(block: 6) // Calculates compatible color
        hsvtorgb(block: 6) // Changes color to rgb
        
        HexValue.text = hexvaluestring // Sets label text to hex value
        RGBValue.text = rgbvaluestring // Sets label text to RGB value
        SolidColor.backgroundColor = solidcolor // Sets background color of color block
        
        // Sets background color to the different compatible colors using RGB values
        CompatibleImage1.backgroundColor = UIColor(red:CGFloat(actualcompatiblecolors["r1"]!), green:CGFloat(actualcompatiblecolors["g1"]!), blue:CGFloat(actualcompatiblecolors["b1"]!), alpha:CGFloat(actualcompatiblecolors["a1"]!))
        CompatibleImage2.backgroundColor = UIColor(red:CGFloat(actualcompatiblecolors["r2"]!), green:CGFloat(actualcompatiblecolors["g2"]!), blue:CGFloat(actualcompatiblecolors["b2"]!), alpha:CGFloat(actualcompatiblecolors["a2"]!))
        CompatibleImage3.backgroundColor = UIColor(red:CGFloat(actualcompatiblecolors["r3"]!), green:CGFloat(actualcompatiblecolors["g3"]!), blue:CGFloat(actualcompatiblecolors["b3"]!), alpha:CGFloat(actualcompatiblecolors["a3"]!))
        CompatibleImage4.backgroundColor = UIColor(red:CGFloat(actualcompatiblecolors["r4"]!), green:CGFloat(actualcompatiblecolors["g4"]!), blue:CGFloat(actualcompatiblecolors["b4"]!), alpha:CGFloat(actualcompatiblecolors["a4"]!))
        CompatibleImage5.backgroundColor = UIColor(red:CGFloat(actualcompatiblecolors["r5"]!), green:CGFloat(actualcompatiblecolors["g5"]!), blue:CGFloat(actualcompatiblecolors["b5"]!), alpha:CGFloat(actualcompatiblecolors["a5"]!))
        CompatibleImage6.backgroundColor = UIColor(red:CGFloat(actualcompatiblecolors["r6"]!), green:CGFloat(actualcompatiblecolors["g6"]!), blue:CGFloat(actualcompatiblecolors["b6"]!), alpha:CGFloat(actualcompatiblecolors["a6"]!))
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
