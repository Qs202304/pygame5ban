import tkinter as tk
import random

class Skill:
    def __init__(self, name, damage, heal, special_effect=None):
        self.name = name
        self.damage = damage
        self.heal = heal
        self.special_effect = special_effect

class Player:
    def __init__(self, name):
        self.name = name
        self.hp = random.randint(100, 200)
        self.attack = random.randint(10, 30)
        self.defense = random.randint(5, 20)

    def is_alive(self):
        return self.hp > 0

    def attack_player(self, other, skill):
        if skill.damage > 0:
            damage = skill.damage - other.defense
            damage = damage if damage > 0 else 0
            other.hp -= damage
            return f"{self.name}使用{skill.name}，对{other.name}造成{damage}点伤害！"
        return "攻击没有造成伤害！"

    def heal_self(self, skill):
        if skill.heal > 0:
            self.hp += skill.heal
            return f"{self.name}使用{skill.name}，恢复{skill.heal}点血量！"
        return "治疗没有效果！"

# 创建技能
fireball = Skill("火球术", damage=30, heal=0)
heal_spell = Skill("治疗术", damage=0, heal=30)

# GUI部分
def update_hp_label(player, label):
    label['text'] = f"{player.name}的血量：{player.hp}"

def attack(target):
    if target == player1:
        announce = player2.attack_player(player1, fireball)
        update_hp_label(player1, player1_hp_label)
    else:
        announce = player1.attack_player(player2, fireball)
        update_hp_label(player2, player2_hp_label)
    text_area.insert(tk.END, announce + "\n")

def heal(player):
    announce = player.heal_self(heal_spell)
    update_hp_label(player, player1_hp_label if player == player1 else player2_hp_label)
    text_area.insert(tk.END, announce + "\n")

# 创建窗体和控件
window = tk.Tk()
window.title("战斗模拟器")

# 获取玩家输入名字
player1_name = input("请输入玩家1的名字：")
player2_name = input("请输入玩家2的名字：")

player1 = Player(player1_name)
player2 = Player(player2_name)

player1_hp_label = tk.Label(window, text=f"{player1.name}的血量：{player1.hp}")
player1_hp_label.pack()

player2_hp_label = tk.Label(window, text=f"{player2.name}的血量：{player2.hp}")
player2_hp_label.pack()

text_area = tk.Text(window, height=10, width=50)
text_area.pack()

attack_button1 = tk.Button(window, text=f"攻击{player2.name}", command=lambda: attack(player2))
attack_button1.pack()

attack_button2 = tk.Button(window, text=f"攻击{player1.name}", command=lambda: attack(player1))
attack_button2.pack()

heal_button1 = tk.Button(window, text=f"{player1.name}治疗", command=lambda: heal(player1))
heal_button1.pack()

heal_button2 = tk.Button(window, text=f"{player2.name}治疗", command=lambda: heal(player2))
heal_button2.pack()

# 运行GUI
window.mainloop()
