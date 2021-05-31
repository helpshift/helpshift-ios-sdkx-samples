//
//  ViewController.swift
//  HSSDKXSwiftSample
//
//  Created by Sagar Dagdu on 24/05/21.
//  Copyright © 2021 Sagar Dagdu. All rights reserved.
//

import UIKit
import HelpshiftX

fileprivate enum DemoCellAction: Int, CaseIterable {
    case showConversation
    case showFaqs
    case showFaqSection
    case showSingleFaq
    case setLanguage

    var displayTitle: String {
        get {
            switch self {
            case .showConversation:
                return "Show Conversation"
            case .showFaqs:
                return "Show Faqs"
            case .showFaqSection:
                return "Show FAQ Section"
            case .showSingleFaq:
                return "Show Single FAQ!"
            case .setLanguage:
                return "Set Language"
            }
        }
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var actionsTableView: UITableView!
    
    private let demoCellIdentifier = "DemoCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        title = "SDK-X Swift Demo"
        actionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: demoCellIdentifier)
        actionsTableView.dataSource = self
        actionsTableView.delegate = self
    }

    private func openSetLanguageAlert() {
        let alert = UIAlertController(title: "Enter language code", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.delegate = self }
        let yesAction = UIAlertAction(title: "GO", style: .default) { (_) in
            if let languageCode = alert.textFields?.first?.text {
                Helpshift.setLanguage(languageCode)
            }
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoCellAction.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.actionsTableView.dequeueReusableCell(withIdentifier: demoCellIdentifier, for: indexPath)
        cell.textLabel?.text = DemoCellAction(rawValue: indexPath.row)!.displayTitle
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let action = DemoCellAction(rawValue: indexPath.row) else { return }
        
        switch action {
        case .showConversation:
            Helpshift.showConversation(with: self, config: nil)
        case .showFaqs:
            Helpshift.showFAQs(with: self, config: nil)
        case .showFaqSection:
            #warning("TODO: Replace the SECTION-ID with appropriate section id")
            Helpshift.showFAQSection("SECTION-ID", with: self, config: nil)
        case .showSingleFaq:
            #warning("TODO: Replace the FAQ-PUBLISH-ID with appropriate faq publish id")
            Helpshift.showSingleFAQ("FAQ-PUBLISH-ID", with: self, config: nil)
        case .setLanguage:
            openSetLanguageAlert()
        }
        
    }
}
