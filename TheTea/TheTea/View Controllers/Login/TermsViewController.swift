//
//  TermsViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/27/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    private let backgroundImageView = UIImageView(image: UIImage(named: "placeholderBackground2"))
    private let gradientLayer = CAGradientLayer()
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Terms & Conditions"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched))
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        gradientLayer.colors = [
            UIColor(red:0.94, green:0.53, blue:1, alpha:0.9).cgColor,
            UIColor(red:0.47, green:0.77, blue:1, alpha:0.9).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundImageView.layer.addSublayer(gradientLayer)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.font = UIFont(name: "Montserrat-Medium", size: 16)
        textView.isEditable = false
        textView.backgroundColor = .clear
        view.addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 118).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        updateText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    func updateText() {
        textView.text = "Hella direct trade twee brooklyn, mixtape farm-to-table scenester keytar kale chips prism readymade gochujang. Pug trust fund pop-up marfa, mustache shoreditch literally. 3 wolf moon franzen mlkshk cray lumbersexual put a bird on it roof party pop-up sartorial godard affogato stumptown ramps yr vaporware. Health goth polaroid gastropub bitters, cliche butcher readymade. Subway tile squid cred food truck, migas selvage lumbersexual irony swag bicycle rights trust fund selfies.\n\nTaiyaki la croix raw denim mumblecore godard. Wolf umami meditation live-edge chambray mumblecore. Bespoke selvage umami selfies banh mi, neutra post-ironic gastropub whatever. La croix deep v chillwave, green juice beard small batch aesthetic post-ironic polaroid kogi DIY.\n\nYuccie neutra authentic pork belly unicorn palo santo fingerstache. Photo booth wolf put a bird on it knausgaard kombucha. Hot chicken normcore disrupt quinoa, la croix blog schlitz fashion axe farm-to-table viral fanny pack. 3 wolf moon authentic taiyaki try-hard, XOXO vape lomo. Ugh PBR&B chillwave iPhone, copper mug organic marfa banh mi affogato activated charcoal keytar cray listicle green juice distillery.\n\nHella austin pinterest butcher disrupt occupy locavore vice tumeric. Shaman asymmetrical semiotics microdosing twee mlkshk paleo tattooed. Shabby chic selvage taxidermy helvetica occupy master cleanse gochujang roof party literally intelligentsia meditation mixtape narwhal before they sold out. Microdosing crucifix meditation mlkshk, gentrify adaptogen vaporware XOXO chillwave deep v. Bitters vexillologist single-origin coffee, mumblecore authentic pok pok cardigan XOXO. Bitters chillwave raw denim actually kombucha squid green juice authentic copper mug.\n\nGluten-free mixtape photo booth, migas franzen neutra copper mug gochujang biodiesel. Pop-up pork belly fanny pack, man bun organic 90's kickstarter iPhone stumptown pour-over godard beard activated charcoal man braid kinfolk. Raw denim edison bulb meditation jianbing gluten-free whatever bushwick fam craft beer street art taiyaki banjo seitan. Kombucha chicharrones PBR&B subway tile pug yr mumblecore dreamcatcher vice cornhole. Food truck banh mi quinoa, man braid knausgaard kinfolk lo-fi waistcoat shaman. Four dollar toast sustainable flannel live-edge, before they sold out tbh next level tumblr copper mug hoodie. Banh mi squid etsy post-ironic glossier vape direct trade."
    }
    
    @objc func doneButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}
