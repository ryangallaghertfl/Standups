//
//  StandupsList.swift
//  Standups
//
//  Created by Ryan Gallagher on 06/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct StandupsListFeature: Reducer {
  struct State {
      //array uses unique id rather than array index
    var standups: IdentifiedArrayOf<Standup> = []
  }
  enum Action {
    case addButtonTapped
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.standups.append(
          Standup(
            id: UUID(),
            theme: .allCases.randomElement()!
          )
        )
        return .none
      }
    }
  }
}



struct StandupsListView: View {
    let store: StoreOf<StandupsListFeature>
    
    var body: some View {
        //only observing standups from the store
        WithViewStore(self.store, observe: \.standups) { viewStore in
              List {
                ForEach(viewStore.state) { standup in
                }
              }
        .navigationTitle("Daily Standups")
        .toolbar {
            ToolbarItem {
                Button("Add"){}
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            StandupsListView()
        }
    }
}
