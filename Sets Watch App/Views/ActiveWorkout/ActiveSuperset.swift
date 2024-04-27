//
//  ActiveSuperset.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct ActiveSuperset: View {
    
    @EnvironmentObject var current_workout: Workout
    @State private var is_showing_settings_sheet: Bool = false
    @State private var current_remaining_time: TimeInterval = TimeInterval()
    
    @State private var view_offset: Int = -200
    @State private var is_transition: Bool = false
    
    var body: some View {
        if let active_ss = current_workout.active_superset
        {
            ZStack {
                VStack (alignment: .leading, spacing: 8) {
                    // The name of the workout
                    HStack
                    {
                        Group{
                            Text(active_ss.name)
                            Spacer()
                            Text(Utils.timeString(current_remaining_time))
                        }
                        Spacer()
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                print("Settings Tapped!")
                                self.is_showing_settings_sheet.toggle()
                            }
                    }
                    
                    ZStack
                    {
                        VStack
                        {
                            HStack
                            {
                                Text("Exercises:")
                                Spacer()
                                Text("\(active_ss.exercises_complete)/\(active_ss.exercise_list.count)")
                            }
                            if (active_ss.is_ss_complete)
                            {
                                Text("Superset Complete")
                                Button(action: {
                                    NextSuperset()
                                }, label: {
                                    Text("Next")
                                })
                            } else {
                                // show each exercise and how many sets to go
                                ForEach(active_ss.exercise_list) { single_exercise in
                                    if (single_exercise.total_complete_sets < single_exercise.sets.count)
                                    {
                                        HStack {
                                            Text(single_exercise.name)
                                            Spacer()
                                            Text("\(single_exercise.total_complete_sets)/\(single_exercise.sets.count)")
                                        }
                                    }
                                }
                            }
                        }
                        HStack
                        {
                            LeftOverlay()
                                .onTapGesture {
                                    print("Left tapped")
                                    PreviousSuperset()
                                }
                            
                            RightOverlay()
                                .onTapGesture {
                                    print("Right Tapped")
                                    NextSuperset()
                                }
                        }
                        

                    }
                }
                .padding(4)
                .background {
                    RoundedRectangle(cornerRadius: 7.0)
                        .foregroundStyle(active_ss.color)
                }
            }
            .offset(x: CGFloat(is_transition ? view_offset : 0))
            .onAppear(perform: {
                current_remaining_time = active_ss.rest_timer.time_remaining
            })
            .onReceive(active_ss.rest_timer.$time_remaining) { remaining in
                current_remaining_time = remaining
            }
            .sheet(isPresented: $is_showing_settings_sheet, content: {
                SupersetSettingsSheetView(isPresented: $is_showing_settings_sheet)
            })
        }
        
    }
    
    func NextSuperset()
    {
       
        withAnimation {
            is_transition = true
            current_workout.NextSuperset()
        } completion: {
            is_transition = false
        }

    }
    
    func PreviousSuperset()
    {
        withAnimation {
            is_transition = true
            current_workout.PreviousSuperset()
        } completion: {
            is_transition = false
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var ss = example_workout.supersets.first!
    @State var rt = ss.rest_timer
    return ActiveSuperset()
        .environmentObject(example_workout)
}
