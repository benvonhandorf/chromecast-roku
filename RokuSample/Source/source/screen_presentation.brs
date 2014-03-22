Sub PresentationScreen_Show(presentationData as Object)
	messagePort = CreateObject("roMessagePort")
	screen = CreateObject("roPosterScreen")

	screen.SetMessagePort(messagePort)

	categoryNames = []

	For Each c in presentationData.categories
		categoryNames.Push(c.title)
	End For

	screen.SetListStyle("arced-landscape")

	screen.SetListNames(categoryNames)

	selectedCategory = 0
	ShowSlidesInSection(screen, presentationData, selectedCategory)

	screen.Show()

	While True ''TODO: Refactor the message loop somewhere?
		message = wait(0, messagePort)

		If message = Invalid Then
			'' Continue
		ElseIf message.IsScreenClosed() Then
			Return
		ElseIf message.IsListFocused() Then
			selectedCategory = message.GetIndex()

			ShowSlidesInSection (screen, presentationData, selectedCategory)
		ElseIf message.IsListItemSelected() Then
			slideIndex = message.GetIndex()

			slide = GetSlide(presentationData, selectedCategory, slideIndex)

			ShowSlide(slide, presentationData)
		End If
	End While

End Sub

Sub ShowSlidesInSection(screen as Object, presentationData As Object, selectedCategory as Integer)
	Print "Showing category:" + Str(selectedCategory)
	category = presentationData.categories.GetEntry(selectedCategory)

	screen.SetContentList(category.slides)
	screen.SetFocusedListItem(0)
End Sub

Sub ShowSlide(slide as Object, presentationData as Object)
	Print "Showing slide:" + slide.ShortDescriptionLine1

	If slide.DoesExist("SlideText") Then
		' We want to show a text file.  Fire up a text screen

	End If

End Sub