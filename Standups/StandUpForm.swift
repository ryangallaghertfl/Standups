//
//  StandUpForm.swift
//  Standups
//
//  Created by Ryan Gallagher on 12/12/2023.
//

import ComposableArchitecture
import SwiftUI

struct StandupFormFeature: Reducer {
  struct State: Equatable {
    @BindingState var focus: Field?
    @BindingState var standup: Standup

    enum Field: Hashable {
      case attendee(Attendee.ID)
      case title
    }

    init(focus: Field? = .title, standup: Standup) {
      self.focus = focus
      self.standup = standup
      if self.standup.attendees.isEmpty {
        self.standup.attendees.append(Attendee(id: UUID()))
      }
    }
  }
  enum Action: BindableAction {
    case addAttendeeButtonTapped
    case binding(BindingAction<State>)
    case deleteAttendees(atOffsets: IndexSet)
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .addAttendeeButtonTapped:
        let id = self.uuid()
        state.standup.attendees.append(Attendee(id: id))
        state.focus = .attendee(id)
        return .none

      case .binding(_):
        return .none

      case let .deleteAttendees(atOffsets: indices):
        state.standup.attendees.remove(atOffsets: indices)
        if state.standup.attendees.isEmpty {
          state.standup.attendees.append(Attendee(id: self.uuid()))
        }
        guard let firstIndex = indices.first
        else { return .none }
        let index = min(firstIndex, state.standup.attendees.count - 1)
        state.focus = .attendee(state.standup.attendees[index].id)
        return .none
      }
    }
  }
}

struct StandupFormView: View {
    let store: StoreOf<StandupFormFeature>
    var body: some View {
        Form {
            Section {
                TextField("Title", text: "")
                HStack {
                    Slider(value: 5, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    Spacer()
                    Text("5 min")
                }
        ThemePicker(selection: .bubblegum)
      } header: {
        Text("Standup Info")
      }
      Section {
          ForEach(Attendee) { $attendee in
          TextField("Name", text: $attendee.name)
        }
        .onDelete { indices in
          //Do something
        }

        Button("Add attendee") {
          //Do something
        }
      } header: {
        Text("Attendees")
      }
    }
  }
}

struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: self.$selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            StandupFormView(store: Store(initialState: StandupFormFeature.State(standup: .mock)) {
                StandupFormFeature()
            }
            )
        }
    }
}
