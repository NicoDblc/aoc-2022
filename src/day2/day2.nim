import strutils
import std/tables

# X = Rock
# Y = Paper
# Z = Scissor
var scoreMap = {"X": 1, "Y": 2, "Z": 3}.toTable
var winMap = {"X": "C", "Y": "A", "Z": "B"}.toTable
var drawTable = {"A": "X", "B": "Y", "C": "Z"}.toTable

# X = Lose
# Y = Draw
# Z = Win
var p2scoreMap = {"X": 0, "Y": 3, "Z": 6}.toTable
var loseRule = {"A": "Z", "B": "X", "C": "Y"}.toTable
var winRule = {"A": "Y", "B": "Z", "C": "X"}.toTable
var rules = {"X": loseRule, "Y": drawTable, "Z": winRule}.toTable

proc fight(elf: string, player: string): int =
    if drawTable[elf] == player:
        result = 3
    elif winMap[player] == elf:
        result = 6
    result += scoreMap[player]

proc fightPart2(elfWeapon: string, action: string): int =
    result = p2scoreMap[action]
    result += scoreMap[rules[action][elfWeapon]]

var strategy = readFile("input")
var rounds = strategy.splitLines()

var score = 0
for round in rounds:
    var letters = round.split(" ")
    if letters.len() >= 2:
        score += fightPart2(letters[0], letters[1])

echo "Your score is: ", score
