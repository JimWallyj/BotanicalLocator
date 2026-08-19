//
//  MomentEntryView.swift
//  BotanicalLocator
//
//  Created by JIM WALEJKO on 8/16/26.
//

import SwiftUI
//  PhotosUI provides basic access to the photo library on the device. The framework handles requesting permissions and manages the interaction.
import PhotosUI

struct MomentEntryView: View {
    @State private var title = ""  //  Entry title
    @State private var note =  ""  //  Multi-line text field
    @State private var imageData: Data?  //  State for the image data
    //  PhotosPickerItem represents the selected image from the photo library. It is used to save the image.
    @State private var newImage: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            ScrollView {  //  Needed in order to keep content accessible when the keyboard is shown.
                contentStack
            }
            .scrollDismissesKeyboard(.interactively)  //  To dismiss the keyboard when it’s scrolled offscreen.
            .navigationTitle("Grateful For")
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
                        .scaledToFit()  //  maintain the aspect ratio of the selected photo.
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
}
