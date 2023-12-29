Dim txtArgument, voice
txtArgument = WScript.Arguments.Item(0)
If WScript.Arguments.Count > 1 Then
    voice = WScript.Arguments.Item(1)
Else
    voice = 0
End If

' tts
Dim sapi
Set sapi = createObject("sapi.spvoice")
Set sapi.Voice = sapi.GetVoices.Item(voice)
sapi.Speak txtArgument