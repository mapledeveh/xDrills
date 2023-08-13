//
//  ContentView.swift
//  xDrills
//
//  Created by Alex Nguyen on 2023-05-17.
//

import SwiftUI

struct GameView: View {
    private var multiplier = 2
    private var difficulty = 5 // number of questions
    
    @State private var answer: Int?
    @State private var multiplicand = Int.random(in: 2...12)
    
    @FocusState private var showKeyboard: Bool
    @State private var totalQuestions = 0
    @State private var score = 0
    
    @State private var showEndGame = false
    @State private var showResult = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var endGameTitle = ""
    @State private var endGameMessage = ""
    
    func evaluateAnswer() {
        if answer == multiplier * multiplicand {
            showResult = true
            alertTitle = "Correct!"
            alertMessage = "This is the correct answer."
            score += 1
        } else {
            showResult = true
            alertTitle = "Wrong!"
            alertMessage = "The correct answer is \(multiplier * multiplicand)."
        }
    }
    
    func submitAnswer() {
        evaluateAnswer()
        nextGame()
    }
        
    func nextGame() {
        multiplicand = Int.random(in: 2...12)
        totalQuestions += 1
        answer = nil
        
        if totalQuestions == difficulty {
            gameFinished()
        }
    }
    
    func gameFinished() {
        
        showEndGame = true
        endGameTitle = "Finished!"
        endGameMessage = "You have finished \(difficulty) questions.\n\(score) answer\(answer == 1 ? " was" : "s were") correct.\nDo you want to restart this level?"
    }
    
    func restartGame() {
        totalQuestions = 1
        multiplicand = Int.random(in: 2...12)
        score = 0
        answer = nil
    }
    
    init(multiplier: Int = 2, difficulty: Int = 5) {
        self.multiplier = multiplier
        self.difficulty = difficulty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.yellow, .red], startPoint: .bottomTrailing, endPoint: .topLeading)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("\(multiplier) x \(multiplicand) = ?")
                        .font(.largeTitle)
                        .foregroundStyle(Gradient(colors: [.green, .blue]))
                        .frame(width: 200, height: 150)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                   
                    Spacer()
                    
                    Section {
                        
                        Text("Score: \(score)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .shadow(radius: 15)
                    }
                    Spacer()
                    
                    HStack {
                        TextField("Answer", value: $answer, format: .number)
                            .keyboardType(.numberPad)
                            .focused($showKeyboard)
                            .padding(14)
                            .background()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Button{
                            submitAnswer()
                        } label: {
                            HStack {
                                Image(systemName: "paperplane")
                                Text("Submit")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding(50)
                    
                    HStack {
                        Button("Skip", role: .cancel, action: nextGame)
                            .padding()
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                }
                .alert(alertTitle, isPresented: $showResult) {
                    Button("Continue") { }
                } message: {
                    Text(alertMessage)
                }
            }
            .alert(endGameTitle, isPresented: $showEndGame) {
                Button("Exit") { }
                Button("Restart") { }
            } message: {
                Text(endGameMessage)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        showKeyboard = false
                    }
                }
            }
            .onSubmit {
                submitAnswer()
            }
        }
    }
}


struct ContentView: View {
    @State private var multiplier = 2
    @State private var difficulty = 5
    
    var body: some View {
        NavigationView {
            
            VStack {
                LinearGradient(colors: [.yellow, .red], startPoint: .bottomTrailing, endPoint: .topLeading)
                    .ignoresSafeArea()
                
                
                Form {
                    Section {
                        Picker("Choose a table", selection: $multiplier) {
                            ForEach(2...12, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.navigationLink)
                        
                    }
                    
                    Section {
                        Text("\(difficulty) Questions")
                            .font(.largeTitle)
                        Picker("Difficulty", selection: $difficulty) {
                            ForEach([5, 10, 15, 20], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    } footer: {
                        Text("The number of questions you would like to practice.")
                    }
                    
                    
                }
                
                NavigationLink(destination: GameView(multiplier: multiplier, difficulty: difficulty), label: {
                    Text("Game On")
                        .frame(width: 200)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
            }
            .navigationTitle("xDrills")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
