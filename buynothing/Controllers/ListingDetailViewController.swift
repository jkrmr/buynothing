//
//  ListingDetailViewController.swift
//  buynothing
//
//  Created by Jake Romer on 4/14/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class ListingDetailViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var listingTitle: UILabel!

  var listing: Listing!

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = listing.image
    listingTitle.text = listing.title
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  @IBAction func closeButtonWasPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
