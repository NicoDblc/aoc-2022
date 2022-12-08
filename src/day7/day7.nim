import sequtils
import strutils
import elfsystem
import algorithm

var input = readFile("input")
var rawCommandsAndResults = input.split("$")
var rootDirectory = Directory(name:"/",files:newSeq[elfsystem.File](), directories: newSeq[Directory]())
var currentDirectory = rootDirectory

var commands = newSeq[Command]()
for command in rawCommandsAndResults:
    var commandAndOutputs = command.split("\r\n")
    commands.add(Command(command: commandAndOutputs[0].strip(true, false, {' '}), output: commandAndOutputs[1..^1].filter(proc(str:string):bool=str!="")))

for command in commands:
    if command.command.contains("cd"):
        var location = command.command.split(" ")[1]
        currentDirectory = currentDirectory.getDirectory(location)
        continue
    if command.command.contains("ls"):
        # add the missing dirs
        for output in command.output:
            var fileInfo = output.split(" ")
            if fileInfo[0] == "dir":
                if currentDirectory.directories.filter(proc(dir:Directory):bool=dir.name == fileInfo[1]).len == 0:
                    currentDirectory.newDir(fileInfo[1])
            else:
                # echo command
                currentDirectory.addFile(fileInfo[0].parseInt(), fileInfo[1])

proc getAllDirs(dir:Directory):seq[Directory]=
    result = newSeq[Directory]()
    result.add(dir.directories)
    for subDir in dir.directories:
        result.add(subDir.getAllDirs)
    
proc displayHierarchy(dir:Directory) =
    echo "Dir: ", dir.name
    echo "Files: ", dir.files.mapIt((it.name, it.size))
    echo "Dirs: ", dir.directories.mapIt((it.name, it.totalSize))
    echo "---"
    for subDir in dir.directories:
        subDir.displayHierarchy

proc part1 =
    echo rootDirectory.getAllDirs.filter(proc(dir:Directory):bool=dir.totalSize <= 10_0000).mapIt(it.totalSize).foldl(a+b)

var totalused = rootDirectory.getAllDirs.mapIt(it.files).concat.mapIt(it.size).foldl(a+b)

const TotalSpace = 70_000_000
const RequiredFreeSpace = 30_000_000

proc part2 = 
    var requiredSpaceToFree = RequiredFreeSpace - (TotalSpace - totalUsed)
    var allDirsSize = rootDirectory.getAllDirs.filter(proc(dir:Directory):bool=dir.totalSize>=requiredSpaceToFree).mapIt(it.totalSize)
    allDirsSize.sort(Ascending)
    echo allDirsSize[0]
