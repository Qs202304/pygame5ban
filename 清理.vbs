Option Explicit
Dim fso, tempFolder, logFile, logPath

Set fso = CreateObject("Scripting.FileSystemObject")

' ������־�ļ�·��
logPath = "D:\CleanUpLog.txt"
Set logFile = fso.CreateTextFile(logPath, True)

' ��¼�ű���ʼ���е�ʱ��
logFile.WriteLine "����ʼ��: " & Now

' ����Windows��ʱ�ļ���
tempFolder = fso.GetSpecialFolder(2)
Call ClearFolder(tempFolder)

' ����D�̵�EasiCameraPhoto�ļ���
Call ClearFolder("D:\EasiCameraPhoto")

' ����D�̵�EasiRecorder�ļ���
Call ClearFolder("D:\EasiRecorder")

' ����ϵͳ��ʱ�ļ���
Call ClearFolder(fso.GetSpecialFolder(2).Path & "\..\Local\Temp")

' ����Internet Explorer��ʱ�ļ���
Call ClearFolder(fso.GetSpecialFolder(2).Path & "\..\Local\Microsoft\Windows\INetCache")

' ��¼�ű��������е�ʱ��
logFile.WriteLine "���������: " & Now
logFile.Close

Sub ClearFolder(FolderPath)
    On Error Resume Next
    Dim folder, file, subfolder, lastModified, daysOld

    ' ����ļ���·���Ƿ����
    If Not fso.FolderExists(FolderPath) Then
        logFile.WriteLine "�ļ��в�����: " & FolderPath
        Exit Sub
    End If

    Set folder = fso.GetFolder(FolderPath)
    If folder Is Nothing Then
        logFile.WriteLine "�޷���ȡ�ļ���: " & FolderPath
        Exit Sub
    End If

    Set files = folder.Files

    ' �����ļ�������޸��������ƣ�������
    daysOld = 3

    For Each file In files
        lastModified = DateDiff("d", file.DateLastModified, Now)
        If lastModified > daysOld Then
            If Not file.Attributes And 1 Then ' ����ļ��Ƿ�Ϊֻ��
                fso.DeleteFile(file.Path), True
                logFile.WriteLine "��ɾ���ļ�: " & file.Path
            End If
        End If
    Next

    Set subfolders = folder.SubFolders
    For Each subfolder In subfolders
        ClearFolder(subfolder.Path) ' �ݹ��������ļ���
    Next

    If Err.Number <> 0 Then
        logFile.WriteLine "��������: " & Err.Description & " �� " & FolderPath
        Err.Clear
    End If
    On Error GoTo 0
End Sub

MsgBox "������ɣ���ϸ��Ϣ��鿴��־�ļ���" & logPath
