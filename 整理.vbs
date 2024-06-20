Option Explicit
Dim fso, folder, files, NewsFolder, file, fileType, targetFolder, scriptName
Dim dictFileTypes, message, OK, arrFiles, i, targetFolderPath, fileToMove
Set fso = CreateObject("Scripting.FileSystemObject")
Set folder = fso.GetFolder(".")
Set files = folder.Files
Set dictFileTypes = CreateObject("Scripting.Dictionary")
scriptName = fso.GetBaseName(WScript.ScriptFullName) & ".vbs"

' ���"�μ�"�ļ����Ƿ���ڣ�����������򴴽�
If Not fso.FolderExists(folder.Path & "\�μ�") Then
    Set NewsFolder = fso.CreateFolder(folder.Path & "\�μ�")
Else
    Set NewsFolder = fso.GetFolder(folder.Path & "\�μ�")
End If

For Each file in files
    fileType = LCase(fso.GetExtensionName(file))
    ' ���Կ�ݷ�ʽ���ű��ļ��Լ�ָ�����ļ�����
    If fileType <> "lnk" And LCase(file.Name) <> LCase(scriptName) And _
       fileType <> "exe" And fileType <> "ini" And fileType <> "vbs" And fileType <> "bat" Then
        If Not dictFileTypes.Exists(fileType) Then
            dictFileTypes.Add fileType, file.Name
        Else
            dictFileTypes(fileType) = dictFileTypes(fileType) & vbCrLf & file.Name
        End If
    End If
Next

' ... [֮ǰ�Ĵ���] ...

For Each fileType In dictFileTypes.Keys
    targetFolderPath = NewsFolder.Path & "\" & fileType
    ' ���Ŀ���ļ����Ƿ���ڣ�����������򴴽�
    If Not fso.FolderExists(targetFolderPath) Then
        fso.CreateFolder(targetFolderPath)
    End If
    arrFiles = Split(dictFileTypes(fileType), vbCrLf)
    For i = 0 To UBound(arrFiles)
        fileToMove = targetFolderPath & "\" & arrFiles(i)
        ' ���Ŀ���ļ������Ƿ����ͬ���ļ�
        If fso.FileExists(fileToMove) Then
            ' ����ѯ���Ƿ񸲸�
            If MsgBox("�ļ� " & arrFiles(i) & " �Ѵ��ڡ��Ƿ񸲸�?", vbYesNo + vbQuestion, "�ļ�����ȷ��") = vbYes Then
                ' ����û�ѡ�񸲸ǣ�����ɾ�������ļ�
                fso.DeleteFile(fileToMove)
                ' Ȼ���ƶ����ļ�
                fso.GetFile(arrFiles(i)).Move fileToMove
            End If
        Else
            ' ���û��ͬ���ļ�����ֱ���ƶ�
            fso.GetFile(arrFiles(i)).Move fileToMove
        End If
    Next
    message = "�ƶ��ļ�����: " & fileType & vbCrLf & "�ļ��б�:" & vbCrLf & dictFileTypes(fileType)
    MsgBox message, vbInformation, "�ļ��ƶ�֪ͨ"
Next

OK ="ȫ����������ɣ�"
MsgBox OK, vbInformation, "�ļ��ƶ�֪ͨ"



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
