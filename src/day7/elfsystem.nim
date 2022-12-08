import sequtils

type 
    BaseFile* = ref object of RootObj
        name*: string
    File* = ref object of BaseFile
        size*: int64
    Directory* = ref object of BaseFile
        files*: seq[File]
        directories*: seq[Directory]
        parent: Directory
    Command* = object
        command*: string
        output*: seq[string]

proc totalSize*(directory: Directory) : int64 =
    if directory.files.len > 0:
        result = directory.files.mapIt(it.size).foldl(a + b)
    if directory.directories.len > 0:
        result += directory.directories.mapIt(it.totalSize).foldl(a + b)

proc newDir*(currentDirectory:Directory, newDirectoryName: string)=
    currentDirectory.directories.add(Directory(name:newDirectoryName, files: newSeq[File](), directories: newSeq[Directory](), parent: currentDirectory))

proc getDirectory*(directory: Directory, newDirectoryName: string) : Directory = 
    if newDirectoryName == "..":
        return directory.parent
    var matchingDirectories = directory.directories.filter(proc(dir:Directory):bool= dir.name == newDirectoryName)
    result = if matchingDirectories.len > 0: matchingDirectories[0] else: directory

proc addFile*(directory: Directory,fileSize: int, fileName: string) =
    directory.files.add(File(name: fileName, size: fileSize))