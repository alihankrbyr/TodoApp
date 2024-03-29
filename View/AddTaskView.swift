//
//  AddTaskView.swift
//  TodoApp
//
//  Created by Alihan Karabayır on 17.01.2023.
//

//
//  AddTaskView.swift
//  TodoApp
//
//  Created by Alihan Karabayır on 17.01.2023.
//

import SwiftUI

struct AddTaskView: View {
    
    // calback
    var onAdd: (Task)->()
    // View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCategory: Category = .general
    
    /// - Category animation properties
    @State private var animateColor:Color = Category.general.color
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading ){
            VStack(alignment: .leading,spacing: 10 ){
                Button{
                    
                }label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                
                Text("Create New Task")
                    .ubuntu(28, .light)
                    .foregroundColor(.white)
                    .padding(.vertical,15)
                TitleView("NAME")
                
                TextField("Make New Video",text: $taskName)
                    .ubuntu(16, .regular)
                    .tint(.white)
                    .padding(.top,2)
                
                Rectangle()
                    .fill(.white.opacity(0.7))
                    .frame(height: 1)
                
                TitleView("DATE")
                    .padding(.top,15)
                HStack(alignment: .bottom,spacing: 12 ){
                    HStack(spacing: 12){
                      
                            Text(taskDate.ToString("EEEE dd, MM YYYY"))
                                .ubuntu(16, .regular)
                            /// - Custom DAte Picker
                            Image(systemName: "calendar")
                                
                                .font(.title3)
                                .foregroundColor(.white)
                                .overlay{
                                    DatePicker("", selection: $taskDate,displayedComponents: [.date])
                                    .blendMode(.destinationOver)
                                  
                                    
                                }
                                
                    }
                    
                    .offset(y: -5)
                    .overlay(alignment: .bottom){
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y:5)
                    }
                    
                    HStack(spacing: 12){
                      
                            Text(taskDate.ToString("hh:mm a"))
                                .ubuntu(16, .regular)
                            /// - Custom DAte Picker
                            Image(systemName: "clock")
                                
                                .font(.title3)
                                .foregroundColor(.white)
                                .overlay{
                                    DatePicker("", selection: $taskDate,displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                                  
                                    
                                }
                                
                    }
                    
                    .offset(y: -5)
                    .overlay(alignment: .bottom){
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y:5)
                    }
                }
                .padding(.bottom,15)
            }
            .environment(\.colorScheme, .dark)
            .hAlign(.leading)
            .padding(15)
            .background{
                ZStack{
                    taskCategory.color
                    GeometryReader{
                        let size = $0.size
                        Rectangle()
                            .fill(animateColor)
                            .mask{
                                Circle()
                                
                            }
                            .frame(width: animate ? size.width * 2 : 0 , height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2): size)
                    }
                    .clipped()
                }
                
               
                    .ignoresSafeArea()
            }
            
            VStack(alignment: .leading,spacing: 10){
                TitleView("DESCRIPTION",.gray)
                
                TextField("About Your Task", text: $taskDescription)
                    .ubuntu(16, .regular)
                    .padding(.top,2)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height:1)
                
                TitleView("CATEGORY",.gray)
                    .padding(.top,15)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 20), count: 3),spacing: 15){
                    ForEach(Category.allCases,id:  \.rawValue){Category in
                        Text(Category.rawValue.uppercased())
                            .hAlign(.center)
                            .ubuntu(12, .regular)
                            .padding(.vertical,5)
                            .background{
                                RoundedRectangle(cornerRadius: 5 ,style: .continuous)
                                    .fill(Category.color.opacity(0.25))
                                
                                
                            }
                            .foregroundColor(Category.color)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard !animate else{return}
                                animateColor=Category.color
                                withAnimation(.interactiveSpring(response: 0.7,dampingFraction: 1,blendDuration: 1)){
                                    animate=true
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    animate=false
                                    taskCategory=Category
                                }
                            }
                    }
                }
                .padding(.top,5)
                Button{
                    /// creating Task And Pass it to the callback
                    let task = Task(dateAdded: taskDate, taskName: taskName, taskDescription: taskDescription, taskCategory: taskCategory)
                    onAdd(task)
                    dismiss()
                    
                }label: {
                    Text("Create Task")
                        .ubuntu(16, .regular)
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .hAlign(.center)
                        .background{
                            Capsule()
                                .fill(animateColor.gradient)
                            
                        }
                
                }
                .vAlign(.bottom)
                .disabled(taskName == "" || animate)
                .opacity((taskName == "" ? 0.6 :1))
                
            }
            .padding(15)
            
        }
        .vAlign(.top)
        
    }
    @ViewBuilder
    func TitleView(_ value: String,_ COLOR: Color = .white.opacity(0.7))->some View{
        Text(value)
            .ubuntu(12, .regular)
            .foregroundColor(COLOR)
    }
      
    }
    
    struct AddTaskView_Previews: PreviewProvider {
        static var previews: some View {
            AddTaskView{task in
                
            }
          
        }
    }
