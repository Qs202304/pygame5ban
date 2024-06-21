Option Explicit
Dim fso, folder, files, NewsFolder, file, fileType, targetFolder, scriptName
Dim dictFileTypes, message, OK, arrFiles, i, targetFolderPath, fileToMove
Dim LogFolder
Set fso = CreateObject("Scripting.FileSystemObject")
Set folder = fso.GetFolder(".")
Set files = folder.Files
Set dictFileTypes = CreateObject("Scripting.Dictionary")
scriptName = fso.GetBaseName(WScript.ScriptFullName) & ".vbs"

' һ������������ӵ���־����
Function WriteLog(sMessage, sLogPath)
    Dim fso, logFile, sFormattedMessage
    Set fso = CreateObject("Scripting.FileSystemObject")
    ' ȷ����־�ļ�·������
    If Not fso.FileExists(sLogPath) Then
        Set logFile = fso.CreateTextFile(sLogPath, True)
    Else
        Set logFile = fso.OpenTextFile(sLogPath, 8, True)
    End If
    ' ��ʽ����Ϣ��ʱ���
    sFormattedMessage = Now & " - " & sMessage
    ' д����־
    logFile.WriteLine sFormattedMessage
    logFile.Close
    Set logFile = Nothing
    Set fso = Nothing
End Function

' �������־·��
LogFolder = inputbox("��ȷ����־·����"&vbCrLf&"����֪���Ǹ����õģ��뱣��Ĭ�ϣ�","������������������־·��","D:\MoveFileLog.txt")

WriteLog "��������ѿ�ʼ", LogFolder

' ���"�μ�"�ļ����Ƿ���ڣ�����������򴴽�
If Not fso.FolderExists(folder.Path & "\�μ�") Then
    Set NewsFolder = fso.CreateFolder(folder.Path & "\�μ�")
Else
    Set NewsFolder = fso.GetFolder(folder.Path & "\�μ�")
End If

' ���һ��������ȷ���ļ�����
Function GetFileType(fileExt)
    Select Case fileExt
        Case "ppt", "pptx"
            GetFileType = "PowerPoint��ʾ�ĸ�"
        Case "doc", "docx"
            GetFileType = "Word�ĵ�"
        Case "xls", "xlsx"
            GetFileType = "Excel���"
        Case "mp4", "mkv", "avi"
            GetFileType = "��Ƶ"
        Case "png", "jpg", "bmp", "gif"
            GetFileType = "ͼƬ"
        ' ����ʾ��
        'Case "�ļ���ʽ1", "�ļ���ʽ2"
            'GetFileType = "�ļ�������"
        Case "pdf"
            GetFileType = "PDF�ĵ�"
        Case "zip", "rar"
            GetFileType = "ѹ���ļ�"
        Case "exe"
            GetFileType = "��ִ���ļ�"
        Case "ini"
            GetFileType = "�����ļ�"
        Case "vbs"
            GetFileType = "VBScript�ű��ļ�"
        Case "bat"
            GetFileType = "�������ļ�"
        Case "lnk"
            GetFileType = "��ݷ�ʽ"
            ' ��Ӹ����ļ����͵��ж�
        Case "mp3", "wav"
            GetFileType = "��Ƶ�ļ�"
        Case "html", "htm"
            GetFileType = "��ҳ�ļ�"
        Case "js"
            GetFileType = "JavaScript�ļ�"
        Case "css"
            GetFileType = "CSS�ļ�"
        Case "xml"
            GetFileType = "XML�ļ�"
        Case "py"
            GetFileType = "Python�ļ�"
        Case "java"
            GetFileType = "Java�ļ�"
            ' ��Ӹ����ļ����͵��ж�
        Case "txt"
            GetFileType = "�ı��ĵ�"
        Case "log"
            GetFileType = "��־�ļ�"
        Case "md"
            GetFileType = "Markdown�ļ�"
        Case "json"
            GetFileType = "JSON�ļ�"
        Case "sql"
            GetFileType = "SQL�ļ�"
        Case "csv"
            GetFileType = "CSV�ļ�"
        Case Else
            GetFileType = "�����ļ�"
    End Select
End Function

For Each file in files
    fileType = LCase(fso.GetExtensionName(file))
    ' ���Կ�ݷ�ʽ���ű��ļ��Լ�ָ�����ļ�����
    If fileType <> "lnk" And LCase(file.Name) <> LCase(scriptName) And _
       fileType <> "exe" And fileType <> "ini" And fileType <> "vbs" And fileType <> "bat" Then
        ' ʹ��GetFileType��������ȡ�ļ�����
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
    ' ���Ŀ���ļ����Ƿ���ڣ�����������򴴽�
    If Not fso.FolderExists(targetFolderPath) Then
        fso.CreateFolder(targetFolderPath)
    End If
    arrFiles = Split(dictFileTypes(groupType), vbCrLf)
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
    ' ���ļ��ƶ����¼��־
    WriteLog "�ļ� " & arrFiles(i) & " ���ƶ��� " & fileToMove, LogFolder
    Next
    message = "�ƶ��ļ�����: " & groupType & vbCrLf & "�ļ��б�:" & vbCrLf & dictFileTypes(groupType)
    MsgBox message, vbInformation, "�ļ��ƶ�֪ͨ"
Next

' ���ļ��ƶ����¼��־
WriteLog "������������", LogFolder

OK ="ȫ����������ɣ���־��鿴��ָ����Ŀ¼��"
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
