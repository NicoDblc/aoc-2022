import std/parseopt
import strutils
import os
import std/algorithm


var filePath: string
for kind, key, val in getopt():
    if key == "f":
        filePath = val

if os.fileExists(filePath):
    var fileString = readFile(filePath)
    var allElfData = fileString.split("\r\n\r\n")
    var elfSumData = newSeq[int](allElfData.len())

    for index, elfData in allElfData:
        var elfDataEntries = elfData.split("\r\n")
        var elfSum = 0
        for entry in elfDataEntries:
            if entry.isEmptyOrWhitespace == false:
                elfSum = elfSum + entry.strip(false, true, {'\n'}).parseInt()
        elfSumData[index] = elfSum
    elfSumData.sort(SortOrder.Descending)
    if elfSumData.len() >= 3:
        echo "Sum of top 3: ", elfSumData[0] + elfSumData[1] + elfSumData[2]

else:
    echo "Invalid file entered"