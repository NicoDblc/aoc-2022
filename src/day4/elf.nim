import strutils

type
    SectionDefinition* = tuple
        sectionStart: int
        sectionEnd: int
    ElfPair* = object
        first: SectionDefinition
        second: SectionDefinition

# Section Creation
proc createSection*(rawSection: string) : SectionDefinition = 
    var sectionData = rawSection.split("-")
    result = (sectionStart: sectionData[0].parseInt(), sectionEnd: sectionData[1].parseInt())

proc createElfPair*(rawPair: string) : ElfPair =
    var rawElfPair = rawPair.split(",")
    result = ElfPair(first: createSection(rawElfPair[0]), second: createSection(rawElfPair[1]))
# End Section Creation

# Section Tests
proc isSectionContained(sectionToTest: SectionDefinition, containerSection: SectionDefinition) : bool =
    sectionToTest.sectionStart >= containerSection.sectionStart and sectionToTest.sectionEnd <= containerSection.sectionEnd

proc doesSectionOverlap(section1: SectionDefinition, section2: SectionDefinition) : bool =
    section1.sectionEnd >= section2.sectionStart and section1.sectionEnd <= section2.sectionEnd

proc containsCommonSection*(elfPair: ElfPair) : bool =
    elfPair.first.isSectionContained(elfPair.second) or elfPair.second.isSectionContained(elfPair.first)
        
proc containsOverlap*(elfPair: ElfPair) : bool =
    elfpair.first.doesSectionOverlap(elfPair.second) or elfPair.second.doesSectionOverlap(elfPair.first)
# End Section Tests