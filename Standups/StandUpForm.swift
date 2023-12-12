//
//  StandUpForm.swift
//  Standups
//
//  Created by Ryan Gallagher on 12/12/2023.
//

import ComposableArchitecture
import SwiftUI

struct StandupFormView: View {
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
          ForEach(attendees) { $attendee in
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
      StandupFormView()
    }
  }
}
