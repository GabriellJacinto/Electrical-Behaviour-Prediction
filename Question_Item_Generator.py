import random
while True:
    paridade = input("Pares(P), Ímpares(I) ou Mixed? ").upper()
    intervalo = input("Qual o intervalo dos itens (ex.: 1-5,10-58,2-9 etc)? ")
    quantidade = int(input("Quantas questões você quer fazer? "))
    questões = []

    def Gerador (paridade, n):
        if paridade[0] == "I" or paridade[0] == "Í":
            if (n%2==0):
                return (n+1)
            else:
                return(n)
        elif paridade[0] == "P":
            if (n%2!=0):
                return (n+1)
            else:
                return(n)
        else:
                return(n)
            
    while quantidade > len(questões):
        for i in range (quantidade-len(questões)):
            n = (random.randint((int(intervalo[:intervalo.index("-")])),(int(intervalo[intervalo.index("-")+1:]))))
            questões.append(Gerador(paridade, n))
        for i in questões:
            while questões.count(i) != 1:
                questões.remove(i)

    questões.sort()
    print(questões)
    input("-> Done")

