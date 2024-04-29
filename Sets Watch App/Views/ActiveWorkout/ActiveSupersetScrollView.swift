//
//  ActiveSupersetScrollView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/26/24.
//

import SwiftUI

struct ActiveSupersetScrollView: View {
    @Environment(Workout.self) var current_workout: Workout
    @State private var scroll_id: Int?
    @State private var scroll_view_size: CGSize = .init(width: 10, height: 10)
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<current_workout.supersets.count, id:\.self) { index in
                    SingleSupersetView(active_ss: current_workout.supersets[index])
                        .containerRelativeFrame(.horizontal, alignment: .center)
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                        }
                        .id(index)
                        .background(
                            GeometryReader(content: { geo -> Color in
                                DispatchQueue.main.async {
                                    if (geo.size == scroll_view_size)
                                    {
                                        return
                                    }
                                    withAnimation {
                                        scroll_view_size = geo.size
                                    }
                                    print("New size: \(scroll_view_size)")
                                }
                                return Color.clear
                            })
                        )
                }
            }
            .scrollTargetLayout()
        }
        .frame(idealHeight: scroll_view_size.height, maxHeight: scroll_view_size.height*1.5)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scroll_id)
        .scrollIndicators(.hidden)
        .onAppear(perform: {
            scroll_id = current_workout.active_superset_idx
        })
        .onChange(of: current_workout.active_superset_idx, { oldValue, newValue in
            scroll_id = newValue
        })
        .onChange(of: scroll_id) { oldValue, newValue in
            guard let oldValue = oldValue else {return}
            guard let newValue = newValue else {return}
            print("Scroll Id Change: \(oldValue), \(newValue)")
            if (newValue == current_workout.active_superset_idx)
            {
                print("Same as active id, no change")
                return
            }
            current_workout.UpdateSuperSetIndex(index: newValue)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    @State var ss = example_workout.supersets.first!
    @State var rt = ss.rest_timer
    return ZStack(alignment: .top, content: {
        ActiveSupersetScrollView()
            .environment(example_workout)
    })
}
