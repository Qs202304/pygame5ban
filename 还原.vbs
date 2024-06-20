Option Explicit
Dim fso, NewsFolder, fileTypeFolder, file, originalFolderPath, targetFile, newName, count
Set fso = CreateObject("Scripting.FileSystemObject")
originalFolderPath = fso.GetParentFolderName(WScript.ScriptFullName)

' 检查"课件"文件夹是否存在
If fso.FolderExists(originalFolderPath & "\课件") Then
    Set NewsFolder = fso.GetFolder(originalFolderPath & "\课件")
    ' 遍历每个文件类型的文件夹
    For Each fileTypeFolder in NewsFolder.SubFolders
        ' 遍历文件夹中的每个文件
        For Each file in fileTypeFolder.Files
            targetFile = originalFolderPath & "\" & file.Name
            ' 检查是否存在重名文件
            If fso.FileExists(targetFile) Then
                count = 1
                ' 生成新的文件名，直到找到一个唯一的文件名
                Do
                    newName = fso.GetBaseName(file) & "_" & count & "." & fso.GetExtensionName(file)
                    targetFile = originalFolderPath & "\" & newName
                    count = count + 1
                Loop While fso.FileExists(targetFile)
                ' 重命名现有文件
                file.Name = newName
            End If
            ' 移动文件回原始文件夹
            file.Move targetFile
        Next
    Next
    ' 删除空的文件类型文件夹
    For Each fileTypeFolder in NewsFolder.SubFolders
        If fileTypeFolder.Files.Count = 0 Then
            fileTypeFolder.Delete
        End If
    Next
End If

Set fso = Nothing
Set NewsFolder = Nothing
Set fileTypeFolder = Nothing
Set file = Nothing
