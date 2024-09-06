//
//  HabitDetailViewController.swift
//  habitTracker
//
//  Created by Djordje Arandjelovic on 20.8.24..
//

import UIKit

class HabitDetailViewController: UIViewController {
    
    var habit: Habit?
    
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var habitDescriptionTextView: UITextField!
    @IBOutlet weak var completionCountLabel: UILabel!
    
    var onSave: ((Habit) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let habit = habit {
            self.title = habit.name
            habitNameTextField.text = habit.name
            habitDescriptionTextView.text = habit.description
            completionCountLabel.text = "Completed \(habit.completionCount) times"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChanges))
    }
    
    @objc func saveChanges() {
        guard let name = habitNameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Habit name cannot be empty")
            return
        }
        
        habit?.name = name
        habit?.description = habitDescriptionTextView.text ?? ""
        
        if let habit = habit {
            onSave?(habit)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
