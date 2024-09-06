//
//  addHabitViewController.swift
//  habitTracker
//
//  Created by Djordje Arandjelovic on 21.8.24..
//

import UIKit

class AddHabitViewController: UIViewController {
    
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var habitDescriptionTextField: UITextField!
    
    var onSave: ((Habit) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Habit"
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        guard let habitName = habitNameTextField.text, !habitName.isEmpty else {
            showAlert(title: "Error", message: "Please enter a habit name")
            return
        }
        
        let newHabit = Habit(name: habitName, description: habitDescriptionTextField.text ?? "")
        
        onSave?(newHabit)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
