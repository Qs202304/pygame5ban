Option Explicit
Dim fso, NewsFolder, fileTypeFolder, file, originalFolderPath, targetFile, newName, count
Set fso = CreateObject("Scripting.FileSystemObject")
originalFolderPath = fso.GetParentFolderName(WScript.ScriptFullName)

' ���"�μ�"�ļ����Ƿ����
If fso.FolderExists(originalFolderPath & "\�μ�") Then
    Set NewsFolder = fso.GetFolder(originalFolderPath & "\�μ�")
    ' ����ÿ���ļ����͵��ļ���
    For Each fileTypeFolder in NewsFolder.SubFolders
        ' �����ļ����е�ÿ���ļ�
        For Each file in fileTypeFolder.Files
            targetFile = originalFolderPath & "\" & file.Name
            ' ����Ƿ���������ļ�
            If fso.FileExists(targetFile) Then
                count = 1
                ' �����µ��ļ�����ֱ���ҵ�һ��Ψһ���ļ���
                Do
                    newName = fso.GetBaseName(file) & "_" & count & "." & fso.GetExtensionName(file)
                    targetFile = originalFolderPath & "\" & newName
                    count = count + 1
                Loop While fso.FileExists(targetFile)
                ' �����������ļ�
                file.Name = newName
            End If
            ' �ƶ��ļ���ԭʼ�ļ���
            file.Move targetFile
        Next
    Next
    ' ɾ���յ��ļ������ļ���
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
