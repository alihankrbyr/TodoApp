//
//  Home.swift
//  TodoApp
//
//  Created by Alihan Karabayır on 17.01.2023.
//


import SwiftUI

struct Home: View {
    
    /// -view Properties
    @State private var currentDay: Date = .init()
    @State private var tasks:[Task] =  sampleTasks
    @State private var addNewTasks:Bool=false
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            TimelineView()
                .padding(15)
        }
        .safeAreaInset(edge: .top,spacing: 0){
            HeaderView()
            
        }
        .fullScreenCover(isPresented: $addNewTasks){
            AddTaskView{
                task in
                /// simply add it to task
                tasks.append(task)
            }
            
        }
        
    }
    
    //TimeLine View
    @ViewBuilder
    func TimelineView()->some View{
        ScrollViewReader {proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack{
                let hours=Calendar.current.hours
                ForEach(hours,id: \.self){hour in
                    TimelineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear{
                proxy.scrollTo(midHour)
            }
        }
    }
    /// -timeline Vİew Row
    @ViewBuilder
    func TimelineViewRow(_ date: Date)->some View{
        HStack(alignment: .top){
            Text(date.ToString("h a"))
                .ubuntu(14, .regular)
                .frame(width: 45,alignment: .leading)
            
            //- Filtering Tasks
            let calendar = Calendar.current
            let filteredTasks = tasks.filter{
                if let hour = calendar.dateComponents([.hour], from : date).hour,
                   let taskHour = calendar.dateComponents([.hour], from:
                                                            $0.dateAdded).hour,
                   hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay){
                    return true
                }
                    return false
            }
            if filteredTasks.isEmpty{
                Rectangle()
                    .stroke(.gray .opacity(0.5), style: StrokeStyle(lineWidth: 0.5,lineCap: .butt,lineJoin: .bevel,dash: [5],dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y:10)
            }else{
                
                /// Task View
                VStack(spacing: 10){
                    ForEach (filteredTasks){task in
                        TaskRow(task)
                    }
                }
                
             
            }
            
            
        }
        .hAlign(.leading)
        .padding(.vertical,15)
        
        
    }
    /// Task Row
    ///
    @ViewBuilder
    func  TaskRow(_ task: Task)-> some View{
        VStack(alignment: .leading, spacing: 10 ){
            Text(task.taskName.uppercased())
                .ubuntu(16, .regular )
                .foregroundColor(task.taskCategory.color)
            if task.taskDescription != ""{
                Text(task.taskDescription)
                    .ubuntu(14, .light )
                    .foregroundColor(task.taskCategory.color.opacity(0.8))
            }
        }
        .hAlign(.leading)
        .padding(12)
        .background{
            VStack(alignment: .leading){
              Rectangle()
                    .fill(task.taskCategory.color)
                    .frame(width: 4)
                
                
                Rectangle()
                    .fill(task.taskCategory.color.opacity(0.25))
            }
            
        }
        
    }
    
    
    /// -Header View

    @ViewBuilder
    func HeaderView()->some View{
        VStack{
            HStack{
                VStack(alignment: .leading , spacing:6 ){
                    Text("Today")
                        .ubuntu(30,.light)
                    
                    Text("Welcome , Alihan Karabayır")
                        .ubuntu(14,.light)
                }
                .hAlign(.leading)
                Button{
                    addNewTasks.toggle()
                } label: {
                    HStack(spacing: 10){
                        Image(systemName: "plus")
                        Text("Add Task")
                            .ubuntu(17, .regular)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal,15)
                    .background{
                        Capsule()
                            .fill(Color("Blue").gradient)
                        
                    }
                    .foregroundColor(.white)
                }
            } //hstack
            
            
            
            
            
            // -Today Date in String
            
            Text(Date().ToString("MMMM YYYY"))
                .ubuntu(16, .medium)
                .hAlign(.leading)
                .padding(.top,15)
            
            
            
            /// -Current Week row
            WeekRow()
            
            
        }
        .padding(15)
        .background(){
            VStack(spacing: 0){
                Color.white
                ///- Gradient Opacity Background
                Rectangle()
                    .fill(.linearGradient(colors: [.white , .clear ,] ,startPoint: .top, endPoint: .bottom))
                .frame(height:20)
                
            }
            .ignoresSafeArea()
        }
    }
    
    /// -week Row
    @ViewBuilder
    func WeekRow()->some View{
        HStack(spacing: 0){
            ForEach(Calendar.current.currentWeek){weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6){
                    Text(weekDay.string.prefix(3))
                        .ubuntu(12, .medium)
                    Text(weekDay.date.ToString("DD"))
                    .ubuntu(16, status ? .medium : .regular)
                    
                }
                .foregroundColor(status ? Color("Blue"): .gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)){
                        currentDay = weekDay.date
                    }
                    
                }
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal,-15)
    }
    
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Mark Vİew Extensions
extension View{
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
}
// Mark DAte Extemsions
extension Date{
    func ToString(_ format: String)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat=format
        return formatter.string(from: self)
    }
}
// mark Caleander extension

extension Calendar{
    /// return 24 hours
    var hours:[Date]{
        let startOfday = self.startOfDay(for: Date())
        var hours:[Date]=[]
        for index in 0..<24{
            if let date=self.date(byAdding: .hour, value: index, to: startOfday){
                hours.append(date)
            }
        }
        return hours
    }
    
    
    
    /// return current week in array format
    var currentWeek:[WeekDay]{
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start
           else{return[]}
        var week: [WeekDay] = []
    
        for index in 0..<7{
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay){
                let weekDaySymbol:String = day.ToString("EEEE")
                let isToday=self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
            }
        }
        return week
        
    }
    
    
    // used to store data of each week day
    struct WeekDay: Identifiable{
        var id: UUID = .init()
        var string:String
        var date:Date
        var isToday:Bool=false    }
    
}
