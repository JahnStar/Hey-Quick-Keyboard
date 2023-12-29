'***************************************************************************************************
' Script: Hey-Chat-VBS v1 (29.12.2023)
' Author: Halil Emre Yildiz
' GitHub: @JahnStar
' Description: Hey Chat VBS is a simple chatbot that uses OpenAI API via Windows Script Host.
'***************************************************************************************************

Dim fso, file, endpoint, apiKey, model, randomness, voice, prompt
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile("config.ini", 1) ' 1 means ForReading
endpoint = file.ReadLine
apiKey = file.ReadLine
model = file.ReadLine
randomness = file.ReadLine
voice = file.ReadLine
Do Until file.AtEndOfStream
    prompt = prompt & file.ReadLine & vbCrLf
Loop
file.Close

Dim WshShell
Set WshShell = CreateObject("WScript.Shell")
If apiKey = "" or apiKey = "Enter your API key on this line." Then
    WshShell.Run "config.ini"
    WshShell.Run "https://platform.openai.com/api-keys"
    WScript.Quit
End if

Dim requestBody, firstMessage, message
firstMessage = Split(prompt, vbCrLf)(0)
Speak firstMessage, voice

message = FixedInputBox(firstMessage & vbCrLf & vbCrLf & "You:", "")
If IsEmpty(message) Or message = "" Then
    WScript.Quit
End If

Dim request, responseContent
Set request = CreateObject("Microsoft.XMLHTTP")

Dim messages
messages = Array(Array("system", "[You are an AI assistant who can role-play, developed by Halil Emre Yildiz (AKA Jahn Star) and you are running in VBScript. [Github](https://github.com/JahnStar)]" & Replace(Replace(prompt, """", "'"), vbCrLf, "\n")), Array("user", message))

Do While True 

    requestBody = "{""model"": """ & model & """, ""messages"": [" & WrapMessages(messages, true) & "], ""temperature"": " & randomness & "}"

    On Error Resume Next

    request.Open "POST", endpoint, False
    request.setRequestHeader "Content-Type", "application/json"
    request.setRequestHeader "Authorization", "Bearer " & apiKey
    request.send requestBody
    
    If Err.Number <> 0 Then
        MsgBox "An error occurred: " & Err.Description & vbCrLf & "Please report the issue by visiting:" & vbCrLf & _ 
        "https://github.com/JahnStar/Hey-Chat-VBS/issues", vbError, "Error"
    End If
    
    On Error GoTo 0

    If request.Status = 200 Then
        ' get response
        responseContent = ParseJSON(request.responseText, "content")
        ' add to messages
        ReDim Preserve messages(UBound(messages) + 1)
        messages(UBound(messages)) = Array("assistant", Replace(responseContent, vbCrLf, "\n"))
        ' tts
        If Left(message, 1) = "-" And voice = "-" Then voice = 0
        Speak responseContent, voice
        ' continue or quit
        message = FixedInputBox(responseContent & vbCrLf & vbCrLf & "You:", "")
        If IsEmpty(message) Or message = "" Then
            ' copy log to clipboard
            ShowConversationLogs(messages)
            WScript.Quit
        Else
            ReDim Preserve messages(UBound(messages) + 1)
            messages(UBound(messages)) = Array("user", message)
        End If
    Else
        MsgBox "Error Log: " & vbCrLf & ParseJSON(request.responseText, "message") & vbCrLf & vbCrLf & "If you think it's a mistake, please report the issue by visiting:" & vbCrLf & _ 
            "https://github.com/JahnStar/Hey-Chat-VBS/issues", vbCritical, ParseJSON(request.responseText, "code") & " error: " & request.Status
        ShowConversationLogs(messages)
        WScript.Quit 
    End If
Loop

Function Speak(text, voice)
    If voice <> "-" Then WshShell.Run "tts.vbs """ & Split(text, ":")(1) & """ " & voice
End Function

Function ShowConversationLogs(messages)
    Dim logs
    logs = Replace(WrapMessages(messages, False), "\n", vbCrLf)
    InputBox "Conversation Ended: " & vbCrLf & vbCrLf & "```" & vbCrLf & logs & vbCrLf & "```" & vbCrLf & "Press CTRL+C to copy the conversation logs:", "Hey ChatVBS v1 <Github/JahnStar>", logs
End Function

Function WrapMessages(messages, toJson)
    Dim json, i
    For i = 0 To UBound(messages)
        Dim role, content
        role = messages(i)(0)
        content = messages(i)(1)

        If (toJson = True) Then
            json = json & "{""role"": """ & role & """, ""content"": """ & content & """}"
            If i < UBound(messages) Then
                json = json & ", "
            End If
        Else
            If role <> "system" Then
                If role <> "user" Then
                    role = "- (AI) "
                Else
                    role = "- You: "
                End If
                json = json & role & content & vbCrLf
            End If
        End If
    Next
    WrapMessages = json
End Function

Function ParseJSON(jsonString, key)
    Dim startPos, endPos, keyPos, valueStartPos, valueEndPos
    Dim keyValue, valueStr

    ' Replace escaped characters
    jsonString = Replace(jsonString, "\""", "'")
    jsonString = Replace(jsonString, "\\", "\")
    jsonString = Replace(jsonString, "\n", vbCrLf)

    startPos = InStr(jsonString, """" & key & """") ' Start position of the switch
    keyPos = InStr(startPos, jsonString, ":") ' Position of the ":" character of the key

    If keyPos > 0 Then
        valueStartPos = InStr(keyPos, jsonString, """") + 1 ' Start position of the value
        valueEndPos = InStr(valueStartPos, jsonString, """") ' End position of value

        valueStr = Mid(jsonString, valueStartPos, valueEndPos - valueStartPos) ' Value string
        ParseJSON = valueStr ' Return value
    Else
        ParseJSON = "" ' Return empty string if key not found
    End If
End Function

Function FixedInputBox(message, default)
    message = InputBox(message, "Hey ChatVBS v1 <Github/JahnStar>", default)
    message = Replace(message, """", "'")
    message = Replace(message, "\""", "'")
    message = Replace(message, "\\", "\")
    FixedInputBox = Replace(message, "\n", vbCrLf)
End Function

' Request example:
' {
'   "model": "gpt-3.5-turbo",
'   "messages": [
'     {
'       "role": "system",
'       "content": "You are a helpful assistant."
'     },
'     {
'       "role": "user",
'       "content": "Hello!"
'     },
'    "temperature": 0.7
'   ]
' }
' Response example:
' {
'   "id": "chatcmpl-123",
'   "object": "chat.completion",
'   "created": 1677652288,
'   "model": "gpt-3.5-turbo-0613",
'   "system_fingerprint": "fp_44709d6fcb",
'   "choices": [{
'     "index": 0,
'     "message": {
'       "role": "assistant",
'       "content": "\n\nHello there, how may I assist you today?",
'     },
'     "logprobs": null,
'     "finish_reason": "stop"
'   }],
'   "usage": {
'     "prompt_tokens": 9,
'     "completion_tokens": 12,
'     "total_tokens": 21
'   }
' }