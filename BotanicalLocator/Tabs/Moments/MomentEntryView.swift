//
//  MomentEntryView.swift
//  BotanicalLocator
//
//  Created by JIM WALEJKO on 8/16/26.
//

import SwiftUI
//  PhotosUI provides basic access to the photo library on the device. The framework handles requesting permissions and manages the interaction.
import PhotosUI
import SwiftData

struct MomentEntryView: View {
    @State private var title = ""  //  Entry title
    @State private var note =  ""  //  Multi-line text field
    @State private var imageData: Data?  //  State for the image data
    //  PhotosPickerItem represents the selected image from the photo library. It is used to save the image.
    @State private var newImage: PhotosPickerItem?
    
    @State private var isShowingCancelConfirmation = false  //  state variable to control a confirmation
    
    //  Dismiss the screen if successful save moment
    @Environment(\.dismiss) private var dismiss
    //  Access DataContainer through the environment.
    @Environment(DataContainer.self) private var dataContainer
    
    var body: some View {
        NavigationStack {
            ScrollView {  //  Needed in order to keep content accessible when the keyboard is shown.
                contentStack
            }
            .scrollDismissesKeyboard(.interactively)  //  To dismiss the keyboard when it’s scrolled offscreen.
            .navigationTitle("Grateful For")
            //  Add toolbar with a button to let people save their entry.
            .toolbar {
                
                //  Add a cancel button so people can discard a new entry instead of saving. Instead of dismissing immediately, use state variable isShowingCancelConfirmation to control a confirmation.
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        //  Improve the cancel action by dismissing immediately if no data is entered.
                        if title.isEmpty, note.isEmpty, imageData == nil {
                            dismiss()
                        } else {
                            isShowingCancelConfirmation = true
                        }
                    }
                    //  Present a confirmationDialog so people don’t accidentally discard information they’ve entered.
                    .confirmationDialog("Discard Moment", isPresented: $isShowingCancelConfirmation) {
                        Button("Discard Moment", role: .destructive) {
                            dismiss()  //  Dismiss the view after discarding an entry.
                            
                        }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", systemImage: "checkmark") {
                        //  In the button’s action closure, create a moment using the data from your state properties.

                        //  create a moment using the data from the state properties
                        let newMoment = Moment(
                            title: title,
                            note: note,
                            imageData: imageData,
                            timestamp: .now
                        )
                        //  Insert the save moment into the model context, try to save it
                        dataContainer.context.insert(newMoment)
                        do {
                            try dataContainer.context.save()
                            dismiss()
                        } catch {
                            // Don't dismiss
                        }
                    }
                    .disabled(title.isEmpty)  //  Require the title by disabling the toolbar button when the title is empty.
                }
            }
        }
    }
    
    private var photoPicker: some View {  //  Used in contentStack
        //  Open the photo library
        PhotosPicker(selection: $newImage) {
            Group {  //  Separates the icon from the rounded photo area. Group applies the same clip shape to the photo area and the selected photo.
           //  Once the transfer of photo data to the app completes, convert the image data to a UIImage that SwiftUI.Image can display.
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()  //  maintain the aspect ratio of the selected photo. If there is no selected photo, continue displaying the photo icon.
                } else {
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.largeTitle)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
        //  Respond to photo selection:
        .onChange(of: newImage) {
            guard let newImage else { return }
            //  Asynchronous Task. loadTransferable function transfers the image from the Photos library into the app in the requested Data format.
            Task {
                imageData = try await newImage.loadTransferable(type: Data.self)
            }
        }
    }
    
    // Encapsulates the view's layout.  Used only in MomentEntryView
    var contentStack: some View {
        VStack(alignment: .leading) {
            TextField(text: $title) {
                Text("Title (Required)")
            }
            
            .font(.title.bold())
            .padding(.top, 48)
            Divider()  //  Divider line in order to empasize the importance.
            
            TextField("Log your small wins", text: $note, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(5...Int.max)  //  Minimum 5 lines to unlimited text
            
            photoPicker  //  Displayed below note
        }
        .padding()
    }
    
    
}

#Preview {
     MomentEntryView()
    //use the .sampleDataContainer() modifier to set up SwiftData and sample moment entries for the preview.
    .sampleDataContainer()
    
}
