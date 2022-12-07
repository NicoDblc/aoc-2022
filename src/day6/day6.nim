import strutils

proc isRepeated(sequence: string) : bool =
    for letter in sequence:
        if sequence.count(letter) > 1:
            return true
    return false

proc findSignalStart(sequence: string, sequenceLength: int) : int =
    for index, letter in sequence[0..^sequenceLength]:
        if isRepeated(sequence[index..index + sequenceLength - 1]) == false:
            return index + sequenceLength

var input = readFile("input")
echo findSignalStart(input, 4)
echo findSignalStart(input, 14)
