//
//  ContentDetailView.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentDetailView: View {
    var body: some View {
        List {
            
            Text("Runkeeper drops its Wear OS app due to a 'buggy experience' - Engadget")
                .font(.system(size: 30))
                .fontWeight(.black)
            
            Image(systemName: "")
                .background(Color.black)
                .frame(height: 300)
            
            Text("The representative added that only a \"very small\" chunk of the community used the app, though the message suggested this wasn't the main reason. Other developers who've scrapped smartwatch apps have frequently cited either demand or a lack of necessity. Slack… The representative added that only a \"very small\" chunk of the community used the app, though the message suggested this wasn't the main reason. Other developers who've scrapped smartwatch apps have frequently cited either demand or a lack of necessity. Slack…")
                .font(.system(size: 22))
                .fontWeight(.medium)
            
            HStack {
                Text("Source:")
                Text("http://www.google.fr")
                
            }
            
            Spacer()
        }
        .padding()
    }
}

#if DEBUG
struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
#endif
