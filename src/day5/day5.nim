import strutils
import algorithm
import sequtils

var rawData = readFile("test").split("\r\n\r\n")
var containerLines = rawData[0].split("\r\n ")[0].splitLines()
var stacks = newSeq[seq[char]]((containerLines[0].len() + 1) div 4)
stacks = stacks.mapIt(newSeq[char]())

for containerLine in containerLines.reversed():
    var adjustedLine = " " & containerLine
    for index, letter in adjustedLine:
        if letter == '[':
            stacks[(index + 1) div 4].add(adjustedLine[index + 1])

type Instruction = object
    amount: int
    at: int
    to: int

proc toInstruction(rawInstruction: seq[int]) : Instruction = 
    assert(rawInstruction.len() == 3)
    result.amount = rawInstruction[0]
    result.at = rawInstruction[1] - 1 # to account for the instruction index starting at 1
    result.to = rawInstruction[2] - 1

# Splitted in 2 parts to not be disgusting.
var translatedInstructions = rawData[1].splitLines().mapIt(it.multiReplace(("move ",""),("from ", ""),("to ","")).split(" "))
var instructions = translatedInstructions.mapIt(it.mapIt(it.parseInt())).mapIt(it.toInstruction())

proc part1 = 
    for instruction in instructions:
        for amount in 0..<instruction.amount:
            stacks[instruction.to].add(stacks[instruction.at].pop())

proc part2 =
    for instruction in instructions:
        stacks[instruction.to].add(stacks[instruction.at][^instruction.amount .. ^1])
        stacks[instruction.at].setLen(stacks[instruction.at].len() - instruction.amount)

# part1()
part2()
echo stacks.mapIt(it[^1])
