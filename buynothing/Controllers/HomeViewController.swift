//
//  HomeViewController.swift
//  buynothing
//
//  Created by Jake Romer on 4/14/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

// TODO:
// - Paginate results of queries

class HomeViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  var refreshControl: UIRefreshControl!
  var listings = [Listing]() {
    didSet { collectionView.reloadData() }
  }

  var searchResults = [Listing]() {
    didSet { collectionView.reloadData() }
  }

  var inSearchMode: Bool = false

  var currentListings: [Listing] {
    if inSearchMode { return searchResults }
    return listings
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadingIndicator.startAnimating()
    hideKeyboardWhenTappedAround()

    searchBar.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self

    let listingCell = UINib(nibName: ListingCell.reuseID, bundle: nil)
    collectionView.register(listingCell, forCellWithReuseIdentifier: ListingCell.reuseID)
    collectionView.collectionViewLayout = GalleryViewLayout()
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(loadListings), for: .valueChanged)
    collectionView.addSubview(refreshControl)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadListings()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ListingDetailViewController.reuseID,
      let controller = segue.destination as? ListingDetailViewController,
      let selectedListing = sender as? Listing {
      controller.listing = selectedListing
      return
    }
  }

  func loadListings() {
    Listing.listAll { (listings) in
      guard let listings = listings else { return }

      if listings.isEmpty {
        print("no listings available near you")
        // TODO: let the user know the query returned no results
      }

      self.listings = listings
      self.loadingIndicator.stopAnimating()
    }

    refreshControl?.endRefreshing()
    loadingIndicator.stopAnimating()
  }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentListings.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingCell.reuseID, for: indexPath) as! ListingCell
    cell.listing = currentListings[indexPath.row]
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedCell = currentListings[indexPath.row]
    performSegue(withIdentifier: ListingDetailViewController.reuseID, sender: selectedCell)
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text, text.characters.count > 0 else { return }
    let searchTerms = text.scan("[:word:]+")
    guard searchTerms.count > 0 else { searchBar.text = ""; return }

    // perform search query, load results, prompt if none
    loadingIndicator.startAnimating()

    Listing.listAll(matchingTerms: searchTerms) { (listings) in
      guard let listings = listings else { return }

      if listings.isEmpty {
        print("no results")
        // TODO: let the user know the query returned no results
      }

      self.searchResults = listings
      self.inSearchMode = true
      self.collectionView.reloadData()
      self.loadingIndicator.stopAnimating()
    }

    loadingIndicator.stopAnimating()
    refreshControl?.endRefreshing()

    // Send the keyboard away
    searchBar.resignFirstResponder()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == "" {
      inSearchMode = false
      collectionView.reloadData()
    }
  }
}
