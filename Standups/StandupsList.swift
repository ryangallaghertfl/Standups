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
    
  }
  enum Action {
  
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      }
    }
  }
}


struct StandupsListView: View {
    var body: some View {
        List {
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
