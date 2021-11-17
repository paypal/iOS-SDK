import SwiftUI

struct FloatingLabelTextField: View {

    let placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .offset(y: text.isEmpty ? 0 : -25)
                .scaleEffect(text.isEmpty ? 1: 0.9, anchor: .leading)
                .font(.system(text.isEmpty ? .title3 : .title3, design: .rounded))
            TextField("", text: $text)
        }
        .padding(.top, text.isEmpty ? 0 : 18)
        .animation(.default, value: 0)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(text.isEmpty ? .black.opacity(1) : .gray, lineWidth: 2)
        )
        .cornerRadius(10)
    }
}


struct FloatingLabelTextField_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            FloatingLabelTextField(placeholder: "First Name", text: .constant(""))
            FloatingLabelTextField(placeholder: "First Name", text: .constant("Jax"))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
