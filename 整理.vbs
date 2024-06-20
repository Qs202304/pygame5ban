Option Explicit
Dim fso, folder, files, NewsFolder, file, fileType, targetFolder, scriptName
Dim dictFileTypes, message, OK, arrFiles, i, targetFolderPath, fileToMove
Set fso = CreateObject("Scripting.FileSystemObject")
Set folder = fso.GetFolder(".")
Set files = folder.Files
Set dictFileTypes = CreateObject("Scripting.Dictionary")
scriptName = fso.GetBaseName(WScript.ScriptFullName) & ".vbs"

' 检查"课件"文件夹是否存在，如果不存在则创建
If Not fso.FolderExists(folder.Path & "\课件") Then
    Set NewsFolder = fso.CreateFolder(folder.Path & "\课件")
Else
    Set NewsFolder = fso.GetFolder(folder.Path & "\课件")
End If

For Each file in files
    fileType = LCase(fso.GetExtensionName(file))
    ' 忽略快捷方式、脚本文件以及指定的文件类型
    If fileType <> "lnk" And LCase(file.Name) <> LCase(scriptName) And _
       fileType <> "exe" And fileType <> "ini" And fileType <> "vbs" And fileType <> "bat" Then
        If Not dictFileTypes.Exists(fileType) Then
            dictFileTypes.Add fileType, file.Name
        Else
            dictFileTypes(fileType) = dictFileTypes(fileType) & vbCrLf & file.Name
        End If
    End If
Next

' ... [之前的代码] ...

For Each fileType In dictFileTypes.Keys
    targetFolderPath = NewsFolder.Path & "\" & fileType
    ' 检查目标文件夹是否存在，如果不存在则创建
    If Not fso.FolderExists(targetFolderPath) Then
        fso.CreateFolder(targetFolderPath)
    End If
    arrFiles = Split(dictFileTypes(fileType), vbCrLf)
    For i = 0 To UBound(arrFiles)
        fileToMove = targetFolderPath & "\" & arrFiles(i)
        ' 检查目标文件夹中是否存在同名文件
        If fso.FileExists(fileToMove) Then
            ' 弹窗询问是否覆盖
            If MsgBox("文件 " & arrFiles(i) & " 已存在。是否覆盖?", vbYesNo + vbQuestion, "文件覆盖确认") = vbYes Then
                ' 如果用户选择覆盖，则先删除现有文件
                fso.DeleteFile(fileToMove)
                ' 然后移动新文件
                fso.GetFile(arrFiles(i)).Move fileToMove
            End If
        Else
            ' 如果没有同名文件，则直接移动
            fso.GetFile(arrFiles(i)).Move fileToMove
        End If
    Next
    message = "移动文件类型: " & fileType & vbCrLf & "文件列表:" & vbCrLf & dictFileTypes(fileType)
    MsgBox message, vbInformation, "文件移动通知"
Next

OK ="全部操作已完成！"
MsgBox OK, vbInformation, "文件移动通知"



Set fso = Nothing
Set folder = Nothing
Set files = Nothing
Set NewsFolder = Nothing
Set file = Nothing
Set fileType = Nothing
Set targetFolder = Nothing
Set scriptName = Nothing
Set dictFileTypes = Nothing
Set message = Nothing
Set OK = Nothing
Set arrFiles = Nothing
