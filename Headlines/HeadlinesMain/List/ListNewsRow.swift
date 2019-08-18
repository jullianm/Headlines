//
//  ListNewsRow.swift
//  Headlight
//
//  Created by Jullianm on 30/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ListNewsRow: View {
    var body: some View {
        HStack {
            Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
            Spacer()
            Image(systemName: "chevron.right")
        }.padding()
    }
}

#if DEBUG
struct ListNewsRow_Previews: PreviewProvider {
    static var previews: some View {
        ListNewsRow()
    }
}
#endif
