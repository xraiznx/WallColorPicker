//
//  ImageDisplayViewController.swift
//  WallColor
//
//  Created by Israel Hammon on 3/6/17.
//  Copyright © 2017 Israel Hammon. All rights reserved.
//

import UIKit

extension UIImage
{
    subscript (x: Int, y: Int) -> UIColor?
    {
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) { return nil }
        
        let provider = self.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        
        let r = CGFloat((data?[pixelData])!) / 255.0
        let g = CGFloat((data?[pixelData + 1])!) / 255.0
        let b = CGFloat((data?[pixelData + 2])!) / 255.0
        let a = CGFloat((data?[pixelData + 3])!) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class ImageDisplayViewController: UIViewController
{

    var image: UIImage? // Main image variable
    var xcord: Int = 0 // X-Coordinate
    var ycord: Int = 0 // Y-Coordinate
    var rgbvaluestring: String? // String that holds rgb value
    var hexvaluestring: String? // String that holds hex value
    var redcol: CGFloat = 0.0 // Holds red value
    var greencol: CGFloat = 0.0 // Holds green value
    var bluecol: CGFloat = 0.0 // Holds blue value
    var alphacol: CGFloat = 0.0 // Holds alpha value
    var actualhue: Float? // Holds actual hue
    var actualsaturation: Float? // Holds actual saturation
    var actualvalue: Float? // Holds actual value
    var hue: Int? // Holds hue * 60
    var saturation: Int? // Holds saturation * 100
    var value: Int? // Holds value * 100
    
    @IBOutlet weak var DisplayImage: UIImageView! // Image view of main image
    @IBOutlet weak var SolidColor: UIImageView! // Image view of solid color
    @IBOutlet weak var HexValue: UILabel! // Label holds hexvalue
    @IBOutlet weak var RGBValue: UILabel! // Label holds rgbvalue
    
    // When next button is pressed, perform segue
    @IBAction func NextScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SolidColor", sender: nil)
    }
    
    // Function that starts when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            var touchPoint = touch.location(in: self.DisplayImage) // Saves location of touch
            
            touchPoint.x = touchPoint.x *  (DisplayImage.image?.size.width)! / DisplayImage.frame.width // Finds x value proportionate to image and display size
            touchPoint.y = touchPoint.y *  (DisplayImage.image?.size.height)! / DisplayImage.frame.height // Finds y value proportionate to image and display size
            
            xcord = Int(touchPoint.x) // Sets X-Coordinate to int of x value
            ycord = Int(touchPoint.y) // Sets Y-Coordinate to int of y value
            
            if let pixelcolor = image?[xcord, ycord]
            {
                // Default value assignment
                redcol = 0.0
                greencol = 0.0
                bluecol = 0.0
                alphacol = 0.0
                
                // Get RGB values and assign to variables
                pixelcolor.getRed(&redcol, green: &greencol, blue: &bluecol, alpha: &alphacol)

                // Calculate the RGB ( value * 255 )
                let redrgb = String((Int(Float(redcol) * 255)))
                let greenrgb = String((Int(Float(greencol) * 255)))
                let bluergb = String((Int(Float(bluecol) * 255)))
                
                rgbvaluestring = redrgb + "," + greenrgb + "," + bluergb // Creates RGB value string
                RGBValue.text = rgbvaluestring // Sets label to RGB value
                rgb2hsv() // Converts to HSV
                SolidColor.backgroundColor = UIColor(red: redcol, green: greencol, blue: bluecol, alpha: 1) // Sets background color of color block equal to RGB value
                hexvaluestring = String(format:"%02X", Int(redrgb)!) + String(format:"%02X", Int(greenrgb)!) + String(format:"%02X", Int(bluergb)!) // Converts value to HEX in string
                HexValue.text = hexvaluestring // Sets HEX label to HEX string value
            }
        }
    }
    // Prepare for segue ( Destination : CompatibleColorController )
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Solid Color"
        {
            let controller = segue.destination as! CompatibleColorController
            
            // Passes neccesary variables
            controller.solidcolor = SolidColor.backgroundColor!
            controller.hexvaluestring = hexvaluestring
            controller.rgbvaluestring = rgbvaluestring
            controller.previmage = image
            controller.hue = hue!
            controller.saturation = saturation!
            controller.value = value!
            controller.actualhue = CGFloat(actualhue!)
            controller.actualsaturation = CGFloat(actualsaturation!)
            controller.actualvalue = CGFloat(actualvalue!)
            controller.actualalpha = alphacol
        }
    }
    
    // Converts RGB value to HSV value
    func rgb2hsv()
    {
        // Initializes neccesary variables
        let redvalue = Float(redcol)
        let greenvalue = Float(greencol)
        let bluevalue = Float(bluecol)
        var temphue : Float?
        var tempsaturation : Float?
        var tempvalue : Float?
        
        // RGB to HSV formula
        let rgbmax = max(redvalue,greenvalue,bluevalue)
        let rgbmin = min(redvalue,greenvalue,bluevalue)
        let temp = rgbmax - rgbmin
        tempvalue = rgbmax
        if (rgbmax == redvalue) { temphue = ((greenvalue - bluevalue) / temp).truncatingRemainder(dividingBy: 6) }
        if (rgbmax == greenvalue) { temphue = ((bluevalue - redvalue) / temp) + 2 }
        if (rgbmax == bluevalue) { temphue = ((redvalue - greenvalue) / temp) + 4 }
        if (rgbmax == 0) { tempsaturation = 0 }
        if (rgbmax != 0) { tempsaturation = temp/rgbmax }
        
        // Assigns calculated hue
        if (temphue! < Float(0)) { hue = Int((temphue! * Float(60)) + Float(180))}
        else { hue = Int(temphue! * Float(60))}
            
        saturation = Int(tempsaturation! * Float(100)) // Assigns calculated saturation
        value = Int(tempvalue! * Float(100))  // Assigns calculated value
        actualhue = temphue // Assigns unalculated hue
        actualsaturation = tempsaturation // Assigns unalculated saturation
        actualvalue = tempvalue // Assigns unalculated value
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DisplayImage.image = image // Sets UIImage view equal to image
        
    }

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}
