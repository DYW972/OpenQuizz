//
//  ViewController.swift
//  Open Quizz
//
//  Created by Yohan W. Dunon on 22/11/2019.
//  Copyright © 2019 Yohan W. Dunon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var newGameBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game()
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup button
        setupObjects()
        /// Handle notifications
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        /// Start the game
        startNewGame()
        /// Handle user's gesture
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    // MARK: ACTIONS
    
    /// Create a new game when user tap on button
    @IBAction func didTapNewGameBtn() {
        startNewGame()
    }
    
    // MARK: METHODS
    
    /// Styling question view and new game button
    private func setupObjects() {
        questionView.layer.cornerRadius = 10
        newGameBtn.layer.cornerRadius = newGameBtn.bounds.height / 2
    }
    
    /// Prepare the view when user tap on new game button
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameBtn.isHidden = true
        questionView.title = "Loading..."
        questionView.style = .Standard
        scoreLabel.text = "0/10"
        game.refesh()
    }
    
    /// Prepare view while question is loaded.
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameBtn.isHidden = false
        questionView.title = game.currentQuestion.title
    }
    
    /// Handle gesture
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .onGoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    //// Transform question view while following gesture
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        /// Get translation made by user
        let translation = gesture.translation(in: questionView)
        /// Create transfromation with translation
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        /// Get screen size
        let screenWidth = UIScreen.main.bounds.width
        /// Calculate angle with view translation
        let translationPercent = translation.x/(screenWidth/2)
        /// Calculate roation angle between -pi/6 & pi/6
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        /// Create transformation with rotation
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        /// Create final transformation with transformation with translation and transformation with rotation
        let transform = translationTransform.concatenating(rotationTransform)
        /// Give question view final transformation
        questionView.transform = transform
        /// Changed translation's style
        if translation.x > 0 {
            questionView.style = .Correct
        } else {
            questionView.style = .Incorrect
        }
    }
    
    /// Handle user's choice and make animation
    private func answerQuestion(){
        switch questionView.style {
        case .Correct:
            game.awserCurrentQuestion(with: true)
        case .Incorrect:
            game.awserCurrentQuestion(with: false)
        default:
            break
        }
        
        /// Observe score and call animate score label method
        let notifName = Notification.Name(rawValue: "ScoreChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(transformScoreLabel), name: notifName, object: nil)
        /// Create and animate translation with screen widht and translation direction
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .Correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        /// view animation
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (success) in
            if success {
                self.showQuestionView()
            }
        }
    }
    
    /// Handle notification that score changed and animate score label
    @objc func transformScoreLabel(){
        /// Get screen size
        questionView.transform = .identity
        scoreLabel.transform = CGAffineTransform(translationX: 0, y: 2)
        /// Update score after gesture
        scoreLabel.text = "\(game.score) / 10"
        /// score label animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.scoreLabel.transform = .identity
        }, completion: nil)
    }
    
    /// Animate the question view after user made choice.
    private func showQuestionView(){
        /// Refresh question view
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .Standard
        /// Check the game state for question view title
        switch game.state {
        case .onGoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        
        /// view animation
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
    }
}

