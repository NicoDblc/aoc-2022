import strutils
import elf

# Data assignation
var rawSectionData = readFile("input")
var rawRaw = rawSectionData.splitLines()

var allElfPairs = newSeq[ElfPair]()
for line in rawRaw:
    if line.len() > 0:
        allElfPairs.add(createElfPair(line))
# End Data assignation

# parts
proc part1 = 
    var commonSectionCount = 0
    for elfpair in allElfPairs:
        if elfpair.containsCommonSection:
            commonSectionCount += 1

    echo "Common elf pairs: ", commonSectionCount

proc part2 = 
    var overlappingSectionCount = 0
    for elfpair in allElfPairs:
        if elfpair.containsOverlap:
            overlappingSectionCount += 1
    echo "Overlaping elf pairs: ", overlappingSectionCount
# End parts

# Main
block main:
    part1()
    part2()

