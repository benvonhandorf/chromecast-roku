
Function GetPlayerVersion() As String
	deviceInfo = CreateObject("roDeviceInfo")
	version = deviceInfo.GetVersion()
	Return version
End Function

Function HasTextScreen() As Boolean
	' The very nice roTextScreen was added in version 4.3
	version = GetPlayerVersion()

	versionSufficient = Val(version.Mid(2,4)) > 4.3

	return versionSufficient
End Function

Function GetSlide(presentationData, slide)
	Return GetSlideInCategory(presentationData, 0, slide)
End Function

Function GetSlideInCategory(presentationData as Object, category as Integer, slide as Integer)
	slidesInCategory = GetSlidesInCategory(presentationData, category)

	If slide > slidesInCategory - 1 Then
		Return GetSlide(presentationData, category + 1, slide - slidesInCategory)
	Else
		Return presentationData.categories.GetEntry(category).slides.GetEntry(slide)
	End If
End Function

Function GetSlidesInCategory(presentationData as Object, category as Integer)
	Return presentationData.categories.GetEntry(category).slides.Count()
End Function

Sub SetSlideIndices(presentationData)
	counter = 0

	For category in presentationData.categories
		For slide in category.slides
			slide.SlideIndex = counter

			counter = counter + 1
		End For
	End For
End Sub