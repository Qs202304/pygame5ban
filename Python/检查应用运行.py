import os
import tkinter as tk
import time

camera_process_name = "EasiCameraGuardian"  # 进程名称
root = tk.Tk()
root.overrideredirect(True)  # 如果您想要窗口有边框和标题栏，请注释掉这行代码
root.geometry("200x120+0+0")  # 设置窗口大小和位置

# 设置高DPI缩放
root.tk.call('tk', 'scaling', 1.5)  # 根据您的屏幕调整这个值

# 创建一个标签，稍后会更新这个标签的属性
label = tk.Label(root, text="📷", font=("Arial", 50))
label.pack(expand=True, fill='both')

def update_icon(is_camera_on):
    """
    更新图标状态。如果摄像头打开，则显示红色背景；否则显示绿色背景。
    """
    if is_camera_on:
        label.config(text="📷", bg="red", fg="white")
    else:
        label.config(text="🚩", bg="green", fg="white")
    root.update()

def check_camera_process(process_name):
    """
    检测特定进程是否正在运行。
    """
    try:
        processes = os.popen('tasklist').read()
        return process_name in processes
    except Exception as e:
        print(f"发生错误: {e}")
        return False

def toggle_camera():
    """
    切换摄像头状态。
    """
    is_camera_on = check_camera_process(camera_process_name)
    if is_camera_on:
        os.system(f"taskkill /F /IM {camera_process_name}.exe")  # 关闭摄像头进程
    else:
        os.system(f"start {camera_process_name}.exe")  # 启动摄像头进程
    update_icon(not is_camera_on)

# 创建一个按钮
toggle_button = tk.Button(root, text="杀无赦", command=toggle_camera)
toggle_button.pack()

root.attributes("-topmost", 1)

def main():
    """
    主函数，循环检查进程并更新图标状态。
    """
    # root.withdraw()  # 初始时隐藏窗口，如果您想在启动时显示窗口，请注释掉这行代码
    while True:
        is_camera_on = check_camera_process(camera_process_name)
        update_icon(is_camera_on)
        time.sleep(1)  # 每1秒检查一次

if __name__ == "__main__":
    main()
