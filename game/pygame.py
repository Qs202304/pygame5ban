import random

def randhp():
    return random.randint(150, 300)

def displayprocess(fplayer,splayer):
    # 为攻击方式添加1-5的随机数
    point = random.randint(1, 5)
    if point == 1:
        announce = fplayer + "使用烟锤冲击，" + splayer + "被击中了！失血40点"
        onchange = -40
    elif point == 2:
        announce = fplayer + "使用脉冲轰炸，" + splayer + "被击中了！失血80点"
        onchange = -80
    elif point == 3:
        announce = fplayer + "使用战地医疗！血量恢复40点"
        onchange = 30
    elif point == 4:
        announce = fplayer + "手下留情，没有使用招术，" + splayer + "拱手感谢！"
        onchange = 0
    elif point == 5:
        announce = fplayer + "使出绝招，使用大唐盛世，"
        # 再次用1-2随机数判断是自杀还是攻击
        expoint = random.randint(1, 2)
        if expoint == 1:
            announce += "但是，自己也被击中了！失血100点"
            onchange = -100
        elif expoint == 2:
            announce += "成功击中敌人！敌人直接毙命！"
            onchange = "die"
        else:
            print("出错了！")
            return 0
    else:
        print("出错了！")
        return 0
    print(announce)
    return onchange

# 主程序
player1 = input("玩家1的名字为")
player2 = input("玩家2的名字为")

hp1 = randhp()
hp2 = randhp()

print(player1 + "初始血量为" + str(hp1) + "点")
print(player2 + "初始血量为" + str(hp2) + "点")

while hp1 > 0 and hp2 > 0:
    hpchange = displayprocess(player1, player2)
    if hpchange == "die":
        print(player2 + "被击败了！")
        hp2 = 0
        break
    elif hpchange >= 0:
        hp1 += hpchange
    elif hpchange < 0:
        hp2 += hpchange
    else:
        print("出错了！")
        break
    hpchange = displayprocess(player2, player1)
    if hp2 > 0:
        if hpchange == "die":
            print(player1 + "被击败了！")
            hp1 = 0
            break
        elif hpchange >= 0:
            hp2 += hpchange
        elif hpchange < 0:  
            hp1 += hpchange
        else:
            print("出错了！")
            break

#判定Winner
if hp1 > 0 and hp2 <= 0:
    print(player1 + "血量还剩" + str(hp1) + "点，" + player2 + "已经 Game over！")
elif hp1 <= 0 and hp2 > 0:
    print(player2 + "血量还剩" + str(hp2) + "点，" + player1 + "已经 Game over！")
else:    #hp1和hp2都小于等于0
    print("平局！")
