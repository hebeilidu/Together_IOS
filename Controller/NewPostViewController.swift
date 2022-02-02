//
//  NewPostViewController.swift
//  Together
//
//  Created by lcx on 2021/11/6.
//

import UIKit
import MapKit
import Amplify

class NewPostViewController: UIViewController {
    @IBOutlet weak var postTitle: TextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var maxParticipants: UILabel!
    @IBOutlet weak var descriptions: TextView!
    @IBOutlet weak var departurePlace: TextView!
    @IBOutlet weak var destination: TextView!
    @IBOutlet weak var destinationAutocomplete: UITableView!
    @IBOutlet weak var departurePlaceAutocomplete: UITableView!
    @IBOutlet weak var departurePlaceOpenInMap: UIButton!
    @IBOutlet weak var destinationOpenInMap: UIButton!
    @IBOutlet weak var transportation: UISegmentedControl!
    @IBOutlet weak var message: MessageLabel!
    
    private var post: Post!
    private let delegate: NewPostViewDelegate
    private var currentTextView: TextView?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    private lazy var requiredInputs: [TextView:String] = {
        return [
            postTitle: "Title Required",
            departurePlace: "Departure Place Required",
            destination: "Destination Required"
        ]
    } ()
    
    init?(coder: NSCoder, delegate: NewPostViewDelegate, post: Post? = nil) {
        self.delegate = delegate
        self.post = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Learned from https://dev.to/jeff_codes/swift-5-location-search-with-auto-complete-location-suggestions-20a1
        searchCompleter.delegate = self
        postTitle.placeholder = "Title"
        descriptions.placeholder = "Description"
        departurePlace.placeholder = "Choose a departure place"
        destination.placeholder = "Choose a destination"
        
        departurePlaceOpenInMap.isEnabled = false
        destinationOpenInMap.isEnabled = false
        
        departurePlace.autocompleteTable = departurePlaceAutocomplete
        destination.autocompleteTable = destinationAutocomplete
        departurePlace.openMapButton = departurePlaceOpenInMap
        destination.openMapButton = destinationOpenInMap
        
        if post != nil {
            loadPost()
        } else {
            datePicker.minimumDate = datePicker.date
        }
    }
    
    private func loadPost() {
        postTitle.text = post.title
        transportation.selectedSegmentIndex = Transportation.getIntValue(of: post.transportation)
        departurePlace.text = post.departurePlace
        destination.text = post.destination
        if let AWSDate = post.departureTime {
            datePicker.minimumDate = AWSDate.foundationDate
            datePicker.date = AWSDate.foundationDate
        }
        descriptions.text = post.description
        maxParticipants.text = "\(post.maxMembers ?? 2)"
        if maxParticipants.toInt() > 2 {
            minus.isEnabled = true
        }
        if maxParticipants.toInt() == 20 {
            plus.isEnabled = false
        }
    }
    
    private func updatePost() {
        post.title = postTitle.text
        post.departurePlace = departurePlace.text
        post.destination = destination.text
        post.transportation = Transportation.getInstance(of: transportation.selectedSegmentIndex)
        post.departureTime = Temporal.DateTime(datePicker.date)
        post.maxMembers = maxParticipants.toInt()
        post.description = descriptions.text == descriptions.placeholder ? "" : descriptions.text
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        for (view, error) in requiredInputs {
            if view.text == "" || view.text == view.placeholder {
                view.layer.borderWidth = 1
                view.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
                view.layer.cornerRadius = 10
                message.showFailureMessage(error, timeInterval: 3.0)
                return
            }
        }
        
        guard let user = Amplify.Auth.getCurrentUser() else { return }
        if post == nil {
            post = Post(owner: user.username, members: [user.username])
        }
        updatePost()
        
        self.dismiss(animated: true) {
            DispatchQueue.global().async {
                Amplify.DataStore.save(self.post) { [self]
                    result in
                    switch(result) {
                    case .success:
                        DispatchQueue.main.async {
                            delegate.handleSuccess()
                        }
                    case .failure:
                        delegate.handleFailure()
                    }
                }
            }
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        let num = maxParticipants.toInt() - 1
        if num == 2 {
            minus.isEnabled = false
        }
        maxParticipants.text = "\(num)"
        plus.isEnabled = true
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        let num = maxParticipants.toInt() + 1
        if num == 20 {
            plus.isEnabled = false
        }
        maxParticipants.text = "\(num)"
        minus.isEnabled = true
    }
    
    @IBAction func openMapButtonPressedForDeparturePlace(_ sender: UIButton) {
        openInMap(for: departurePlace.text)
    }
    
    @IBAction func openMapButtonPressedForDestination(_ sender: UIButton) {
        openInMap(for: destination.text)
    }
    
    private func openInMap(for location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first else { return }
            MKMapItem(placemark: MKPlacemark(placemark: placemark)).openInMaps()
        }
    }
}

extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.text == view.placeholder {
            view.text = ""
        }
        currentTextView = view
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if !view.hasText {
            view.text = view.placeholder
        }
        view.removeAutocompleteTable()
        currentTextView = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.text != "" {
            view.layer.borderWidth = 0
        }
        if view == destination || view == departurePlace {
            if view.text == "" {
                view.removeAutocompleteTable()
            } else {
                searchCompleter.queryFragment = textView.text
            }
        }
    }
}

extension NewPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = searchResults[indexPath.row].title + (
            searchResults[indexPath.row].subtitle == "Search Nearby"
            ? ""
            : "\n" + searchResults[indexPath.row].subtitle
        )
        if tableView == departurePlaceAutocomplete {
            autocompleteSelected(departurePlace, text)
        } else if tableView == destinationAutocomplete {
            autocompleteSelected(destination, text)
        }
    }
    
    private func autocompleteSelected(_ textView: TextView, _ text: String) {
        UIView.animate(withDuration: 0.3) {
            textView.text = text
        }
        textView.resignFirstResponder()
    }
}

extension NewPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "autocompleteCell",
            for: indexPath
        )
        cell.textLabel?.text = searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle == "Search Nearby"
            ? ""
            : searchResults[indexPath.row].subtitle
        return cell
    }
}

extension NewPostViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        currentTextView?.loadSearchResults()
    }
}
