Option Explicit
Dim fso, folder, files, NewsFolder, file, fileType, targetFolder, scriptName
Dim dictFileTypes, message, OK, arrFiles, i, targetFolderPath, fileToMove
Dim LogFolder
Set fso = CreateObject("Scripting.FileSystemObject")
Set folder = fso.GetFolder(".")
Set files = folder.Files
Set dictFileTypes = CreateObject("Scripting.Dictionary")
scriptName = fso.GetBaseName(WScript.ScriptFullName) & ".vbs"

' 一个可以随便乱扔的日志函数
Function WriteLog(sMessage, sLogPath)
    Dim fso, logFile, sFormattedMessage
    Set fso = CreateObject("Scripting.FileSystemObject")
    ' 确保日志文件路径存在
    If Not fso.FileExists(sLogPath) Then
        Set logFile = fso.CreateTextFile(sLogPath, True)
    Else
        Set logFile = fso.OpenTextFile(sLogPath, 8, True)
    End If
    ' 格式化消息与时间戳
    sFormattedMessage = Now & " - " & sMessage
    ' 写入日志
    logFile.WriteLine sFormattedMessage
    logFile.Close
    Set logFile = Nothing
    Set fso = Nothing
End Function

' 搞出来日志路径
LogFolder = inputbox("请确定日志路径："&vbCrLf&"（不知道是干嘛用的，请保持默认）","快速整理所生产的日志路径","D:\MoveFileLog.txt")

WriteLog "整理操作已开始", LogFolder

' 检查"课件"文件夹是否存在，如果不存在则创建
If Not fso.FolderExists(folder.Path & "\课件") Then
    Set NewsFolder = fso.CreateFolder(folder.Path & "\课件")
Else
    Set NewsFolder = fso.GetFolder(folder.Path & "\课件")
End If

' 添加一个函数来确定文件类型
Function GetFileType(fileExt)
    Select Case fileExt
        Case "ppt", "pptx"
            GetFileType = "PowerPoint演示文稿"
        Case "doc", "docx"
            GetFileType = "Word文档"
        Case "xls", "xlsx"
            GetFileType = "Excel表格"
        Case "mp4", "mkv", "avi"
            GetFileType = "视频"
        Case "png", "jpg", "bmp", "gif"
            GetFileType = "图片"
        ' 分类示例
        'Case "文件格式1", "文件格式2"
            'GetFileType = "文件夹名称"
        Case "pdf"
            GetFileType = "PDF文档"
        Case "zip", "rar"
            GetFileType = "压缩文件"
        Case "exe"
            GetFileType = "可执行文件"
        Case "ini"
            GetFileType = "配置文件"
        Case "vbs"
            GetFileType = "VBScript脚本文件"
        Case "bat"
            GetFileType = "批处理文件"
        Case "lnk"
            GetFileType = "快捷方式"
            ' 添加更多文件类型的判断
        Case "mp3", "wav"
            GetFileType = "音频文件"
        Case "html", "htm"
            GetFileType = "网页文件"
        Case "js"
            GetFileType = "JavaScript文件"
        Case "css"
            GetFileType = "CSS文件"
        Case "xml"
            GetFileType = "XML文件"
        Case "py"
            GetFileType = "Python文件"
        Case "java"
            GetFileType = "Java文件"
            ' 添加更多文件类型的判断
        Case "txt"
            GetFileType = "文本文档"
        Case "log"
            GetFileType = "日志文件"
        Case "md"
            GetFileType = "Markdown文件"
        Case "json"
            GetFileType = "JSON文件"
        Case "sql"
            GetFileType = "SQL文件"
        Case "csv"
            GetFileType = "CSV文件"
        Case Else
            GetFileType = "其他文件"
    End Select
End Function

For Each file in files
    fileType = LCase(fso.GetExtensionName(file))
    ' 忽略快捷方式、脚本文件以及指定的文件类型
    If fileType <> "lnk" And LCase(file.Name) <> LCase(scriptName) And _
       fileType <> "exe" And fileType <> "ini" And fileType <> "vbs" And fileType <> "bat" Then
        ' 使用GetFileType函数来获取文件类型
        Dim groupType
        groupType = GetFileType(fileType)
        If Not dictFileTypes.Exists(groupType) Then
            dictFileTypes.Add groupType, file.Name
        Else
            dictFileTypes(groupType) = dictFileTypes(groupType) & vbCrLf & file.Name
        End If
    End If
Next

For Each groupType In dictFileTypes.Keys
    targetFolderPath = NewsFolder.Path & "\" & groupType
    ' 检查目标文件夹是否存在，如果不存在则创建
    If Not fso.FolderExists(targetFolderPath) Then
        fso.CreateFolder(targetFolderPath)
    End If
    arrFiles = Split(dictFileTypes(groupType), vbCrLf)
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
    ' 在文件移动后记录日志
    WriteLog "文件 " & arrFiles(i) & " 已移动到 " & fileToMove, LogFolder
    Next
    message = "移动文件类型: " & groupType & vbCrLf & "文件列表:" & vbCrLf & dictFileTypes(groupType)
    MsgBox message, vbInformation, "文件移动通知"
Next

' 在文件移动后记录日志
WriteLog "整理操作已完成", LogFolder

OK ="全部操作已完成！日志请查看您指定的目录！"
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
