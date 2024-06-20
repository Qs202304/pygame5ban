Option Explicit
Dim fso, tempFolder, logFile, logPath

Set fso = CreateObject("Scripting.FileSystemObject")

' 设置日志文件路径
logPath = "D:\CleanUpLog.txt"
Set logFile = fso.CreateTextFile(logPath, True)

' 记录脚本开始运行的时间
logFile.WriteLine "清理开始于: " & Now

' 清理Windows临时文件夹
tempFolder = fso.GetSpecialFolder(2)
Call ClearFolder(tempFolder)

' 清理D盘的EasiCameraPhoto文件夹
Call ClearFolder("D:\EasiCameraPhoto")

' 清理D盘的EasiRecorder文件夹
Call ClearFolder("D:\EasiRecorder")

' 清理系统临时文件夹
Call ClearFolder(fso.GetSpecialFolder(2).Path & "\..\Local\Temp")

' 清理Internet Explorer临时文件夹
Call ClearFolder(fso.GetSpecialFolder(2).Path & "\..\Local\Microsoft\Windows\INetCache")

' 记录脚本结束运行的时间
logFile.WriteLine "清理结束于: " & Now
logFile.Close

Sub ClearFolder(FolderPath)
    On Error Resume Next
    Dim folder, file, subfolder, lastModified, daysOld

    ' 检查文件夹路径是否存在
    If Not fso.FolderExists(FolderPath) Then
        logFile.WriteLine "文件夹不存在: " & FolderPath
        Exit Sub
    End If

    Set folder = fso.GetFolder(FolderPath)
    If folder Is Nothing Then
        logFile.WriteLine "无法获取文件夹: " & FolderPath
        Exit Sub
    End If

    Set files = folder.Files

    ' 设置文件的最后修改日期限制（天数）
    daysOld = 3

    For Each file In files
        lastModified = DateDiff("d", file.DateLastModified, Now)
        If lastModified > daysOld Then
            If Not file.Attributes And 1 Then ' 检查文件是否为只读
                fso.DeleteFile(file.Path), True
                logFile.WriteLine "已删除文件: " & file.Path
            End If
        End If
    Next

    Set subfolders = folder.SubFolders
    For Each subfolder In subfolders
        ClearFolder(subfolder.Path) ' 递归清理子文件夹
    Next

    If Err.Number <> 0 Then
        logFile.WriteLine "发生错误: " & Err.Description & " 在 " & FolderPath
        Err.Clear
    End If
    On Error GoTo 0
End Sub

MsgBox "清理完成！详细信息请查看日志文件：" & logPath
