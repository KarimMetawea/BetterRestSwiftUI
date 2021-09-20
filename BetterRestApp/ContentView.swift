//
//  ContentView.swift
//  BetterRestApp
//
//  Created by Karem on 9/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date()
    @State private var cofeeAmount = 1
    
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("When do you want to wake up")
                    .font(.headline)
                DatePicker("please enter a time", selection: $wakeUp,displayedComponents:.hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...12,step:0.25) {
                    Text("\(sleepAmount,specifier: "%g") hours")
                }
                Text("cofee amount")
                    .font(.headline)
                Stepper(value: $cofeeAmount, in: 1...20,step:1) {
                    Text("\(cofeeAmount) cup")
                }
                Spacer()
            }).padding()
            .navigationBarTitle("Better Rest")
            .navigationBarItems(trailing:
                                    Button(action: calculateBedTime, label: {
                                        Text("Calculate")
                                    })
            )
        }.alert(isPresented: $showingAlert, content: {
            Alert.init(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("ok")))
        })
    }
    
    func calculateBedTime(){
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(cofeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
        } catch {
            alertTitle = "error"
            alertMessage = "something went wrong"
        }
        showingAlert.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
