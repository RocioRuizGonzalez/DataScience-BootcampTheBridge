########################################
######## SUMA NÚMEROS IMPARES ##########


# Autor: ksjnkdjn
# Fecha: lkdnldsnv
# Contacto: lsnfdsljvnl


def suma_impares(ls):
    '''
    Función que, dados todos los números, 
    me suma los impares
    '''
    suma=0
    for num in ls:
        if num%2!=0:
            suma += num
    return suma


def suma_pares(ls):
    '''
    Función que, dados todos los números, 
    me suma los pares
    '''
    suma=0
    for num in ls:
        if num%2==0:
            suma += num
    return suma