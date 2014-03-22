Sub StaticTextScreen_Show(textFilePath as String)
	StaticTextScreen_WithBreadcrumb_Show(textFilePath, "")
End Sub

Sub StaticTextScreen_WithBreadcrumb_Show(textFilePath as String, breadcrumb as String)
	Print "Loading text file: " + textFilePath

	textContents = ReadAsciiFile(textFilePath)

	messagePort = CreateObject("roMessagePort")
	screen = CreateObject("roParagraphScreen")

	screen.SetMessagePort(messagePort)

	If breadcrumb <> "" Then
		screen.SetTitle(breadcrumb)
	End If

	tokens = textContents.Tokenize(Chr(10))

	Print "File loaded.  Tokens Found:" + Str(tokens.Count())

	tokens.ResetIndex()

	nextItem = tokens.GetIndex()

	if (nextItem <> invalid) Then
		screen.AddHeaderText(nextItem)

		nextItem = tokens.GetIndex()
	End If

	While nextItem <> Invalid
		screen.AddParagraph(nextItem)
		nextItem = tokens.GetIndex()
	End While

	screen.AddButton(0, "Close")

	screen.Show()

	While True
		message = wait(0, screen.GetMessagePort())

		Print "Message Type: " + Type(message)

		If message = Invalid Then
			' I've found that occasionally I get an Invalid message object.
		ElseIf message.IsScreenClosed() Then
			Return
		ElseIf Type(message) = "roParagraphScreenEvent" Then
			' Events specific to this screen type.  Here's where most commands
			' will come through.

			Exit While
		Else
			Print "Message Type: " + Str(Type(message))
		End If 

	End While

End Sub