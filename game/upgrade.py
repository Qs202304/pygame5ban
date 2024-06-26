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
                    # 这里改为0
                    data[magic[i]] = 0
                    
                type += 1
    else:
        data = "非法"
    return data

# alive用于判定并输出存活名单供用户选择
def alive(data,group):
    if group == 0:
        idnum = [0,5,10]
    if group == 1:
        idnum = [15,20,25]
    else:
        print("非法")
    for i in idnum:
        if data[i] != "Down":
            alivename = []
            alivename.append(data[i])
            alivename.append(i)
    return alivename

# alivecount用于判定并输出存活人数
def alivecount(data,group):
    if group == 0:
        idnum = [0,5,10]
    if group == 1:
        idnum = [15,20,25]
    else:
        print("非法")
    for i in idnum:
        if data[i] != "Down":
            count += 1
            
    return count

# aliveshowandselect用于输出存活名单供用户选择
def aliveshowandselect(data,group):
    s = alivecount(data,group)
    t = alive(data,group)
    print("选择出战队员：")
    for i in range(s):
        print(i,"：",t[2*i])
    n = int(input("请输入编号："))
    number = t[n+1]
    return number

# ifisdead用于判定是否死亡，并将死亡队员改为Down
def ifisdead(data):
    hp=[1,6,11,16,21,26]
    for i in hp:
        if data[i] <= 0:
            if data[i-1] != "Down":
                print(data[i-1],"队员死亡")
                data[i-1] = "Down"
                data[i] = 0

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
    n = int(input("请输入编号："))
    if n>=0 and n<=count2:
        return available[n+1]
        
# atkalive用于输出存活队员，并随机决定谁被攻击
def atkalive(data,group):
    randatk = random.randint(1,alivecount(data,group))
    name = alive(data,group)
    beatked = name[int(2*randatk+1)]
    return beatked

# groupselect用于判断队员在哪个组
def groupselect(user):
    if user<=11:
        return 0
    elif user>11 and user<=26:
        return 1
    else:
        return "非法"
    
