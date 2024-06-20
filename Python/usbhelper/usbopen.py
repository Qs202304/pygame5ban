import time
import win32file
import subprocess

def locate_usb():
    drive_list = []
    drivebits = win32file.GetLogicalDrives()
    for d in range(1, 26):
        mask = 1 << d
        if drivebits & mask:
            # 检查驱动器是否存在
            drname = '%c:\\' % chr(ord('A') + d)
            t = win32file.GetDriveType(drname)
            if t == win32file.DRIVE_REMOVABLE:
                # 如果是可移动驱动器，添加到列表
                drive_list.append(drname)
    return drive_list

if __name__ == "__main__":
    last_usb_state = None  # 记录上一次U盘状态
    while True:
        usb_drives = locate_usb()
        if usb_drives:
            print("检测到U盘：", usb_drives)
            if last_usb_state != "inserted":
                # 如果U盘被插入且上一次状态不是插入，则打开文件资源管理器
                subprocess.Popen(["explorer", usb_drives[0]])
                last_usb_state = "inserted"
        else:
            print("未检测到U盘")
            if last_usb_state == "inserted":
                # 如果U盘被拔出且上一次状态是插入，则关闭文件资源管理器
                # subprocess.Popen(["taskkill", "/f", "/im", "explorer.exe"])
                # 然而上面的代码会把桌面也一并关闭，就不必关上了
                last_usb_state = "removed"
        time.sleep(1)  # 每1秒检查一次
