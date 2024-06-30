import random
import os

# Randval函数生成随机HP，攻击，暴击和法术值
def randval(type):
    if type == 0:
        randvalue = random.randint(150, 300)
    elif type == 1:
        randvalue = random.randint(20, 30)
    elif type == 2:
        randvalue = random.randint(40, 50)
    elif type == 3:
        randvalue = random.randint(10, 30)
    else:
        print("error")
    return randvalue

# Readfile用于读取settings.txt文件的内容并以列表的形式返回
def readfile():
    file = open("settings.txt", "r")
    lines = file.readlines()
    # 去除换行符
    for i in range(len(lines)):
        lines[i] = lines[i].replace("\n", "")
    file.close()
    # 返回一个列表，列表中的元素是settings.txt文件中每一行的内容
    return lines

# Writefile用于将新的属性值写入settings.txt文件
def writefile(data):
    # 直接覆盖写入settings.txt文件
    file = open("settings.txt", "w")
    # 写入新的属性值，data是一个列表
    for i in data:
        file.write(str(i)+"\n")
    file.close()

# changeval用于改变名称，然后并初始化属性，也可直接初始化属性而不改名
def changeval(data,type):
    if type > 0:
        while type < 3:
            if type == 1:
                idnum = [0,5,10,15,20,25]
                namelist = []
                for i in idnum:
                    namelist.append(data[i])
                flag = False
                while flag == False:
                    os.system("cls")
                    print("以下为人员列表：")
                    for i in range(6):
                        print(str(i+1)+"："+str(namelist[i]))
                    s = input("请输入要修改的名称：")
                    if str(s) in namelist:
                        t = input("请输入新的名称：")
                        if t not in namelist:
                            # 更改名称
                            data[idnum[namelist.index(s)]] = t
                            # 也应用于namelist
                            namelist[namelist.index(s)] = t
                    u = input("是否继续修改？(Y/N)")
                    if u == "Y" or u == "y":
                        flag = False
                    elif u == "N" or u == "n":
                        flag = True
                    else:
                        print("输入错误，请重新输入")
                        flag = False
                type += 1
            elif type == 2:
                hp=[1,6,11,16,21,26]
                atk=[2,7,12,17,22,27]
                sup=[3,8,13,18,23,28]
                magic=[4,9,14,19,24,29]
                for i in range(6):
                    data[hp[i]] = randval(0)
                for i in range(6):
                    data[atk[i]] = randval(1)
                for i in range(6):
                    data[sup[i]] = randval(2)
                for i in range(6):
                    data[magic[i]] = randval(3)
                    
                type += 1
    else:
        data = "非法"
    return data

# whichgroup用于判断组别
def whichgroup(group):
    gp = str(group)
    if gp == "0":
        idnum = [0,5,10]
    elif gp == "1":
        idnum = [15,20,25]
    else:
        print("error")
    return idnum

# alive用于判定并输出存活名单供用户选择
def alive(data,group):
    idnum = whichgroup(group)
    alivename = []
    for i in idnum:
        if data[i] != "Down":
            alivename.append(data[i])
            alivename.append(i)
    return alivename

# alivecount用于判定并输出存活人数
def alivecount(data,group):
    gp = str(group)
    idnum = whichgroup(group)
    count = 0
    for i in idnum:
        if data[i] != "Down":
            count += 1
            
    return count

# aliveshowandselect用于输出存活名单供用户选择
def aliveshowandselect(data,group):
    gp = str(group)
    s = alivecount(data,str(gp))
    t = alive(data,str(gp))
    print("选择出战队员：")
    for i in range(s):
        print(i,"：",t[2*i])
    n = int(input("请输入编号："))
    number = t[2*n+1]
    return number

# ifisdead用于判定是否死亡，并将死亡队员改为Down
def ifisdead(data):
    hp=[1,6,11,16,21,26]
    for i in hp:
        if int(data[i]) <= 0:
            if data[i-1] != "Down":
                print(data[i-1],"队员死亡")
                data[i-1] = "Down"
                data[i] = 0
                
    return data

# magicatk用于选择法术攻击
def magicatk(data,user):
    magickind = [15,"火球术",20,"闪电术",30,"冰冻术",40,"治疗术",70,"复活术"]
    count = [1,3,5,7,9]
    count2 = 0
    available = []
    for i in range(5):
        num = count[i]
        if magickind[num-1]<=int(data[user+4]):
            available.append(magickind[num])
            available.append(magickind[num-1])
            count2 = count2 + 1
    print("选择你的法术：")
    for i in range(count2):
        print(i,"：",available[2*i],"，消耗",available[2*i+1],"点法力")
    noo = input("请输入编号（不存在按下回车）：")
    if noo =="":
        return "unselect"
    else:
        n = int(noo)
        if n>=0 and n<=count2:
            return available[2*n+1]
        
# atkalive用于输出存活队员，并随机决定谁被攻击
def atkalive(data,group):
    randatk = random.randint(1,alivecount(data,group))
    name = alive(data,group)
    beatked = name[int(2*randatk)-1]
    return beatked

# groupselect用于判断队员在哪个组
def groupselect(user):
    if user<=11:
        return 0
    elif user>11 and user<=26:
        return 1
    else:
        return "非法"

# ifalldead用于判断是否有一队全部死亡
def ifalldead(data):
    if data[0] == "Down" and data[5] == "Down" and data[10] == "Down":
        return 0
    elif data[15] == "Down" and data[20] == "Down" and data[25] == "Down":
        return 1
    else:
        return False

# easter用于法术复活队员
# 切记要在编辑主战斗时备份一份data为olddata!!!
def easter(data,user,olddata):
    if groupselect(user) == 0:
        num = [0,5,10]
    elif groupselect(user) == 1:
        num = [15,20,25]
    else:
        print("非法")
    eastername = []
    count = 0
    for i in num:
        if data[i] == "Down":
            eastername.append(olddata[i])
            eastername.append(i)
            count += 1
            
    print("选择复活队员：")
    for i in range(count):
        print(i,"：",eastername[2*i])
    n = int(input("请输入编号："))
    number = eastername[n+1]
    data[number] = olddata[number]
    print(eastername[2*n],"复活成功")
    return data

# 以下为战斗函数
# 切记要在编辑主战斗时备份一份data为olddata!!!
def mainfight(data,group,olddata):
    fid = aliveshowandselect(data,group)
    fid = int(fid)
    if group == 0:
        sgroup = 1
    elif group == 1:
        sgroup = 0
    else:
        print("非法")
    sid = atkalive(data,sgroup)
    fname = data[fid]
    sname = data[sid]
    # point决定类型
    point = random.randint(1, 5)
    print(data[fid+1])
    if point == 1:
        announce = fname + "使用烟锤冲击，" + sname + "被击中了！失血"+str(data[fid+1])+"点"
        data[sid+1] = int(data[sid+1]) - int(data[fid+2])
    elif point == 2:
        announce = fname + "使用脉冲轰炸，" + sname + "被击中了！失血"+str(data[fid+2])+"点"
        data[sid+1] = int(data[sid+1]) - int(data[fid+3])
    elif point == 3:
        announce = fname + "看错了，使用了一记无用功，" + sname + "毫发无伤！"
    elif point == 4:
        announce = fname + "手下留情，没有使用招术，" + sname + "拱手感谢！"
    elif point == 5:
        announce = fname + "使出绝招，使用法术"
        # expoint决定法术类型
        expoint = magicatk(data,fid)
        if expoint == 15:
            announce += "火球术！"
            data[sid+1] = int(data[sid+1]) - 50
        elif expoint == 70:
            announce += "复活术！"
            data = easter(data,fid,olddata)
        elif expoint == 20:
            announce += "闪电术！"
            data[sid+1] = int(data[sid+1]) - 100
        elif expoint == 40:
            announce += "治疗术！"
            data[fid+1] = int(data[fid+1]) + 100
        elif expoint == 30:
            announce += "冰冻术！"
            data[30] = sgroup
        elif expoint == "unselect":
            announce += "但是法术点余额不足！刻苦修炼，获得新点数！"
            dd = data[fid+4]
            data[fid+4] = int(dd) + int(randval(3))
            print("现在点数为："+str(data[fid+4]))
            expoint = 0
        else:
            print("出错了！")
            return data
        data[fid+4] = int(data[fid+4]) - expoint
    else:
        print("出错了！")
        return data
    print(announce)
    return data

# 主函数

# 初始化
data = []
olddata = []

data = readfile()
olddata = data.copy()

# 初始化结束
while True:
    # 游戏开始

    print("欢迎来到游戏！")

# 主界面
    print("请选择操作：")
    print("1.查看角色")
    print("2.更改角色名")
    print("3.保存角色")
    print("4.读取角色")
    print("5.战斗")
    print("6.退出游戏")

    # 游戏主循环
    # 读取输入
    inputtype = input("请输入选项：")
    # 判断输入
    if inputtype == "1":
        # 显示角色
        print("角色列表：")
        for i in range(0,5):
            print("角色"+data[i*5]+"：初始HP",data[i*5+1]+"，普通攻击",data[i*5+2]+"，高级攻击",data[i*5+3])
        os.system("pause")

    elif inputtype == "2":
        data = changeval(data,1)
        
    elif inputtype == "3":
        writefile(data)
        
    elif inputtype == "4":
        data = readfile()
        
    elif inputtype == "5":
        # 战斗
        # 如果没有初始化，再一次！
        if len(data) == 0:
            data = range(0,30)
            data = changeval(data,2)
            olddata = data.copy()
        # 战斗开始
        data.append("")
        group1name = input("请输入第一组的名字：")
        group2name = input("请输入第二组的名字：")
        print("战斗开始！")
        count = 0
        turn = 0
        while ifalldead(data) == False:
            data = ifisdead(data)
            count += 1
            print("第"+str(count)+"回合！")
            if turn == 0:
                if data[30] != 0:
                    data = ifisdead(data)
                    print("轮到"+group1name+"的回合！")
                    data = mainfight(data,0,olddata)
                    turn = 1
                else:
                    data = ifisdead(data)
                    print(group1name+"本回合被冻结！")
                    # 清除冻结（删除这个元素）
                    data[30] = ""
                    turn = 1
            elif turn == 1:
                if data[30] != 1:
                    data = ifisdead(data)
                    print("轮到"+group2name+"的回合！")
                    data = mainfight(data,1,olddata)
                    turn = 0
                else:
                    data = ifisdead(data)
                    print(group2name+"本回合被冻结！")
                    # 清除冻结（删除这个元素）
                    data[30] = ""
                    turn = 0
        # 战斗结束
        print("战斗结束！")
        # 用ifalldead判断输赢
        if ifalldead(data) == 0:
            print(group2name+"胜利！")
        elif ifalldead(data) == 1:
            print(group1name+"胜利！")
        else:
            print("平局！")
        # 重置数据
        data = olddata.copy()
        
    elif inputtype == "6":
        # 退出游戏
        print("游戏退出！")
        break
    else:
        print("无效的输入！")
            





    
