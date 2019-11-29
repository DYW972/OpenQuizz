//
//  Game.swift
//  Open Quizz
//
//  Created by Yohan W. Dunon on 24/11/2019.
//  Copyright © 2019 Yohan W. Dunon. All rights reserved.
//

import Foundation

class Game {
    enum State {
        case onGoing, over
    }
    
    var score = 0
    var questions = [Question]()
    var state: State = .onGoing
    private var currentIndex = 0
    public var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    func awserCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
            let notifName = Notification.Name(rawValue: "ScoreChanged")
            let scoreChangedNotification = Notification(name: notifName)
            NotificationCenter.default.post(scoreChangedNotification)
        }
        nextQuestion()
    }
    
    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
    
    func refesh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get {(questions) -> () in
            self.questions = questions
            self.state = .onGoing
            
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let questionsLoadedNotification = Notification(name: name)
            NotificationCenter.default.post(questionsLoadedNotification)
        }
    }
    
}
