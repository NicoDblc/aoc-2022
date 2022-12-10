import sequtils
import strutils
import sugar
import algorithm

var forestLinesData = readFile("test").splitLines

var forest = newSeqWith(forestLinesData[0].len, newSeq[int](
        forestLinesData.len))
for index, line in forestLinesData:
    forest[index] = collect:
        for i in line: int(i)-48

proc testTreeLine(line: seq[int], treeHeight: int): bool =
    line.filter(proc(value: int): bool = value >= treeHeight).len == 0

proc isTreeVisible(x: int, y: int): bool =
    if x == 0 or x == forest[0].len - 1:
        return true
    if y == 0 or y == forest.len - 1:
        return true

    var treeValue = forest[y][x]    
    if testTreeLine(forest[y][0..<x], treeValue) or testTreeLine(forest[y][x+1..^1], treeValue):
        return true

    var column = collect:
        for line in forest: line[x]
    if testTreeLine(column[0..<y], treeValue) or testTreeLine(column[y+1..^1], treeValue):
        return true

proc part1=
    var totalTreesVisible = 0
    for y, line in forest:
        for x, val in line:
            if isTreeVisible(x,y):
                totalTreesVisible += 1    
    echo totalTreesVisible

proc getViewDistance(line: seq[int], treeHeight: int) : int =
    var baseTree = 0
    for h in line:
        if h >= baseTree:
             result += 1
             baseTree = h
        if h >= treeHeight:
            return

proc computeViewDistance(x:int,y:int) : int =
    var viewDistance = newSeq[int](4)
    
    viewDistance[0] = if x > 0: getViewDistance(forest[y].reversed()[^x..^1], forest[y][x]) else: 0
    viewDistance[1] = if x < forest[y].len: getViewDistance(forest[y][x+1..^1], forest[y][x]) else: 0
    var column = collect:
        for line in forest: line[x]
    viewDistance[2] = if y > 0: getViewDistance(column.reversed()[^y..^1], forest[y][x]) else:0
    viewDistance[3] = if y < column.len: getViewDistance(column[y+1..^1], forest[y][x]) else: 0
    viewDistance.foldl(a*b)

proc part2:int=
    for y, line in forest:
        for x, val in line:
            var viewDistance = computeViewDistance(x,y)
            if viewDistance > result:
                result = viewDistance
                echo (x,y), viewDistance

echo part2()