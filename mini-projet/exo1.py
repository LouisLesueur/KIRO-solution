from math import *
from pulp import *

# matrice des incidences I
# 1 2 3 4 A B C D E F U : num ligne -> num colonne
I = [[0,0,0,0,0,1,1,0,0,0,0],
     [0,0,0,0,1,1,0,0,0,0,0],
     [0,0,0,0,1,0,0,0,1,0,0],
     [0,0,0,0,0,0,0,0,1,1,0],
     [0,0,0,0,0,0,0,1,0,0,0],
     [0,0,0,0,0,0,0,1,0,0,0],
     [0,0,0,0,0,0,0,1,0,0,1],
     [0,0,0,0,0,0,0,0,0,0,1],
     [0,0,0,0,0,0,0,1,0,1,0,],
     [0,0,0,0,0,0,0,0,0,0,1],
     [0,0,0,0,0,0,0,0,0,0,0]]

# matrice des coûts M
M = [[1000000,1000000,1000000,1000000,1000000,14,19,1000000,1000000,1000000,1000000],
     [1000000,1000000,1000000,1000000,9,10,1000000,1000000,1000000,1000000,1000000],
     [1000000,1000000,1000000,1000000,12,1000000,1000000,1000000,18,1000000,1000000],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,26,10,1000000],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,25,1000000,1000000,1000000],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,11,1000000,1000000,1000000],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,8,1000000,1000000,14],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,15],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,4,1000000,7,1000000],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,20],
     [1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000]]

problem1 = LpProblem("problem1",LpMinimize)

# variables indiquant si un chemin est emprunté (vaut 0 ou 1)
X = LpVariable.dicts("X",[(i,j) for i in range(len(M)) for j in range(len(M[0]))], 0, 1, cat="Integer")

# variable indiquant le flot sur chaque arc
F = LpVariable.dicts("F",[(i,j) for i in range(len(M)) for j in range(len(M[0]))], 0, 200)

l_cost = []
for i in range(len(M)):
    for j in range(len(M[0])) :
        l_cost.append(X[(i,j)]*M[i][j])

problem1 += sum(l_cost), "fonction objectif"

# ajout des contraintes
# conservation du débit (sauf pour puits et usine)
for i in range(4, len(M)-1):
    flot_inc = 0
    flot_sort = 0
    for j in range(0, len(M[0])):
        if I[i][j] == 1:
            flot_sort += F[(i,j)]
        elif I[j][i] == 1:
            flot_inc += F[(j,i)]
    problem1 += flot_inc == flot_sort, "conservation debit "+str(i)

# contraintes sur les flots
for i in range(len(M)):
    for j in range(len(M[0])):
        problem1 += X[(i,j)] <= F[(i,j)], "x = 0 si pas de flot "+str(i)+" "+str(j)
        problem1 += X[(i,j)] >= 1/400*F[(i,j)], "x = 1 si un flot "+str(i)+" "+str(j)
        # il peut y avoir un flot seulement si incident
        problem1 += X[(i,j)] <= I[i][j] ,'incidence '+str(i)+" "+str(j)
# sortie des puits
problem1 += F[(0,5)]+F[(0,6)] == 205, "sortie du puit 1"
problem1 += F[(1,4)]+F[(1,5)] == 75, "sortie du puit 2"
problem1 += F[(2,4)]+F[(2,8)] == 95, "sortie du puit 3"
problem1 += F[(3,8)]+F[(3,9)] == 195, "sortie du puit 4"
problem1 += F[(6,10)]+F[(7,10)]+F[(9,10)] == 570, "entree usine"

LpSolverDefault.msg = 1
problem1.writeLP("problem.lp")
problem1.solve()
print("Status:", LpStatus[problem1.status])

print("Cost of building : ", value(problem1.objective))
for v in problem1.variables():
    if v.varValue > 0:
        print(v.name, " = ", v.varValue)

################# question 2 #####################
problem2 = LpProblem("problem2",LpMinimize)

# variables indiquant si un chemin est emprunté (vaut 0 ou 1)
X = LpVariable.dicts("X",[(i,j) for i in range(len(M)) for j in range(len(M[0]))], 0, 1, cat="Integer")

# variable indiquant le flot sur chaque arc
F = LpVariable.dicts("F",[(i,j) for i in range(len(M)) for j in range(len(M[0]))], 0, 400)

# variable indiquant si on prend un petit ou un grand caniveau
G = LpVariable.dicts("G",[(i,j) for i in range(len(M)) for j in range(len(M[0]))], 0, 1, cat="Integer")

l_cost = []
for i in range(len(M)):
    for j in range(len(M[0])) :
        l_cost.append(X[(i,j)]*M[i][j]+0.5*M[i][j]*G[(i,j)])
problem2 += sum(l_cost), "fonction objectif"

# ajout des contraintes
# conservation du débit (sauf pour puits et usine)
for i in range(4, len(M)-1):
    flot_inc = 0
    flot_sort = 0
    for j in range(0, len(M[0])):
        if I[i][j] == 1:
            flot_sort += F[(i,j)]
        elif I[j][i] == 1:
            flot_inc += F[(j,i)]
    problem2 += flot_inc == flot_sort, "conservation debit "+str(i)

# contraintes sur les flots
for i in range(len(M)):
    for j in range(len(M[0])):
        problem2 += X[(i,j)] <= F[(i,j)], "x = 0 si pas de flot "+str(i)+" "+str(j)
        problem2 += X[(i,j)] >= 1/400*F[(i,j)], "x = 1 si un flot "+str(i)+" "+str(j)
        # il peut y avoir un flot seulement si incident
        problem2 += X[(i,j)] <= I[i][j] ,'incidence '+str(i)+" "+str(j)
        # flot > 200 : g = 1
        problem2 += G[(i,j)] >= 1/200*(F[(i,j)]-200), 'gros caneau si f sup 200 '+str(i)+" "+str(j)

# sortie des puits
problem2 += F[(0,5)]+F[(0,6)] == 205, "sortie du puit 1"
problem2 += F[(1,4)]+F[(1,5)] == 75, "sortie du puit 2"
problem2 += F[(2,4)]+F[(2,8)] == 95, "sortie du puit 3"
problem2 += F[(3,8)]+F[(3,9)] == 195, "sortie du puit 4"
problem2 += F[(6,10)]+F[(7,10)]+F[(9,10)] == 570, "entree usine"

LpSolverDefault.msg = 1
problem2.writeLP("problem.lp")
problem2.solve()
print("Status:", LpStatus[problem2.status])

print("Cost of building : ", value(problem2.objective))
for v in problem2.variables():
    if v.varValue > 0:
        print(v.name, " = ", v.varValue)
