#!/usr/bin/python3
#
# Kanji grade check for Ome Sato Foundation seminar.
# Usage: python3 kanjicheck.py target_file_name
# If your file has kanji characters which are not taught up to 4th grade
# the tool pickup the characters and designate where they are.
# Written by Naohiko Shimizu, 29 May 2023.
# Copyright (c) 2023 Naohiko Shimizu
#

import sys
import regex
from csv import reader
GradeLimit = 4
s1_list=list("一右雨円王音下火花貝学気九休玉金空月犬見五口校左三山子四糸字耳七車手十出女小上森人水正生青夕石赤千川先早草足村大男竹中虫町天田土二日入年白八百文木本名目立力林六")
s2_list=list("引羽雲園遠何科夏家歌画回会海絵外角楽活間丸岩顔汽記帰弓牛魚京強教近兄形計元言原戸古午後語工公広交光考行高黄合谷国黒今才細作算止市矢姉思紙寺自時室社弱首秋週春書少場色食心新親図数西声星晴切雪船線前組走多太体台地池知茶昼長鳥朝直通弟店点電刀冬当東答頭同道読内南肉馬売買麦半番父風分聞米歩母方北毎妹万明鳴毛門夜野友用曜来里理話")
s3_list=list("悪安暗医委意育員院飲運泳駅央横屋温化荷界開階寒感漢館岸起期客究急級宮球去橋業曲局銀区苦具君係軽血決研県庫湖向幸港号根祭皿仕死使始指歯詩次事持式実写者主守取酒受州拾終習集住重宿所暑助昭消商章勝乗植申身神真深進世整昔全相送想息速族他打対待代第題炭短談着注柱丁帳調追定庭笛鉄転都度投豆島湯登等動童農波配倍箱畑発反坂板皮悲美鼻筆氷表秒病品負部服福物平返勉放味命面問役薬由油有遊予羊洋葉陽様落流旅両緑礼列練路和")
s4_list=list("愛案以衣位囲胃印英栄塩億加果貨課芽改械害街各覚完官管関観願希季紀喜旗器機議求泣救給挙漁共協鏡競極訓軍郡径型景芸欠結建健験固功好候航康告差菜最材昨札刷殺察参産散残士氏史司試児治辞失借種周祝順初松笑唱焼象照賞臣信成省清静席積折節説浅戦選然争倉巣束側続卒孫帯隊達単置仲貯兆腸低底停的典伝徒努灯堂働特得毒熱念敗梅博飯飛費必票標不夫付府副粉兵別辺変便包法望牧末満未脈民無約勇要養浴利陸良料量輪類令冷例歴連老労録")
s5_list=list("圧移因永営衛易益液演応往桜恩可仮価河過賀快解格確額刊幹慣眼基寄規技義逆久旧居許境均禁句群経潔件券険検限現減故個護効厚耕鉱構興講混査再災妻採際在財罪雑酸賛支志枝師資飼示似識質舎謝授修述術準序招承証条状常情織職制性政勢精製税責績接設舌絶銭祖素総造像増則測属率損退貸態団断築張提程適敵統銅導徳独任燃能破犯判版比肥非備俵評貧布婦富武復複仏編弁保墓報豊防貿暴務夢迷綿輸余預容略留領")
s6_list=list("異遺域宇映延沿我灰拡革閣割株干巻看簡危机揮貴疑吸供胸郷勤筋系敬警劇激穴絹権憲源厳己呼誤后孝皇紅降鋼刻穀骨困砂座済裁策冊蚕至私姿視詞誌磁射捨尺若樹収宗就衆従縦縮熟純処署諸除将傷障城蒸針仁垂推寸盛聖誠宣専泉洗染善奏窓創装層操蔵臓存尊宅担探誕段暖値宙忠著庁頂潮賃痛展討党糖届難乳認納脳派拝背肺俳班晩否批秘腹奮並陛閉片補暮宝訪亡忘棒枚幕密盟模訳郵優幼欲翌乱卵覧裏律臨朗論")

def iter(content):
    for ch in content:
        yield ch
        
def leftShiftIndex(arr, n):
   arr[:] = arr[n:] + arr[:n]
   del arr[0]

def bsearch(data: list, target: int, compare):
    lo = -1
    hi = len(data)
    while (hi - lo > 1):
        m = lo + (int)((hi - lo) / 2)
        if compare(data[m], target):
            lo = m
        else:
            hi = m
    return (True,hi) if (hi != len(data) and data[hi] == target) else (False,hi)

def compareCharCode(a,b):
    return True if a-b<0 else False

def check(content):
    maxgrade=0
    linecount=1
    skipflag = False
    chbuf = []
    ruby = ""
    markedChar = []
    for ch in iter(content):
        chbuf += ch
        if len(chbuf) > 5:
            leftShiftIndex(chbuf,0)
            ruby = ''.join(chbuf)
            if ruby == '\\ruby':
                skipflag = True
            
        if (skipflag == True):
            if ch == '}':
                skipflag = False
            continue

        if ch == '\n':
            linecount = linecount + 1
        if regex.match('^\p{Script=Han}+$', ch):
            charCode = ord(ch)
            res,index = bsearch(markedChar,charCode,compareCharCode)
            if res is False:
                markedChar.insert(index,charCode)
            else:
                continue
            
            if ch in s1_list:
                if maxgrade < 1:
                    maxgrade=1
                if GradeLimit < 1:
                    print("G1", ch, "at", linecount)
            elif ch in s2_list:
                if maxgrade < 2:
                    maxgrade=2
                if GradeLimit < 2:
                    print("G2", ch, "at", linecount)
            elif ch in s3_list:
                if maxgrade < 3:
                    maxgrade=3
                if GradeLimit < 3:
                    print("G3", ch, "at", linecount)
            elif ch in s4_list:
                if maxgrade < 4:
                    maxgrade=4
                if GradeLimit < 4:
                    print("G4", ch, "at", linecount)
            elif ch in s5_list:
                if maxgrade < 5:
                    maxgrade=5
                if GradeLimit < 5:
                    print("G5", ch, "at", linecount)
            elif ch in s6_list:
                if maxgrade < 6:
                    maxgrade=6
                if GradeLimit < 6:
                    print("G6", ch, "at", linecount)
            else:
                maxgrade=7
                print("G7", ch, "at", linecount)
    return maxgrade

if __name__ == '__main__':
    args = sys.argv
    if len(args) == 2:
        try:
         f = open(sys.argv[1],'r',encoding='utf-8')
         content = f.read()
        except FileNotFoundError:
            print('Argument file is not found')
            quit()
        print("maxgrade="+str(check(content)))
    else:
        print('text file argument is required')
