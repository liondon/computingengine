# -*- coding: utf-8 -*-
"""
Created on Fri Sep 21 10:55:07 2018

@author: montie01
"""
#address of th server
SERVER="192.168.56.2"
ftpSERVER="192.168.56.2"
#where to make calculation
w='/data/tmp/'

#matalabfolder with webserver stuff of the server
matlabWEBSERVER='/data/project/CAMRIE/matlab/WEBSERVER/'


ftpUser="prova"
ftpPWD="prova"


ftpUser="prova"
ftpPWD="prova"



def getServer():
    data = {
    "version":"2019may",
    "server": SERVER,
    "workingPATH":w,
    "matlab":matlabWEBSERVER,
    "ftpU":ftpUser,
    "ftpP": ftpPWD,
    "qurl":"http://192.168.56.2/apps/CAMRIE/Q",
    'ftpSERVER':ftpSERVER
    }
    return data

#a=getServer()
#print a['server']
