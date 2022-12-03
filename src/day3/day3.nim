import strutils
import std/tables

var itemScore = initTable[char,int]()

for letter in countup(int('A'), int('Z')):
    itemScore[char(letter)] = letter - 38
for letter in countup(int('a'), int('z')):
    itemScore[char(letter)] = letter - 96

var rucksacks = readFile("input").splitLines()

proc part1 =
    var prioritiesSum = 0
    for line in rucksacks:
        var left = line[0 .. line.len() div 2 - 1]
        var right = line[line.len() div 2 .. ^1]
        assert left.len() == right.len()
        var biggestCommon = 0
        for leftLetter in left:
            if right.contains(leftLetter):
                biggestCommon = (if itemScore[leftLetter] > biggestCommon: itemScore[leftLetter] else: biggestCommon)
        prioritiesSum += biggestCommon
    echo "Sum of priorities: ", prioritiesSum

proc part2 = 
    var groupPrioritiesSum = 0
    for groupIndex in countup(0, rucksacks.len() div 3 - 1):
        var groupLines = rucksacks[groupIndex * 3 .. groupIndex * 3 + 2]
        for letter in groupLines[0]:
            if groupLines[1].contains(letter) and groupLines[2].contains(letter):
                groupPrioritiesSum += itemScore[letter]
                break;
    echo "Group sum: ", groupPrioritiesSum

part2()