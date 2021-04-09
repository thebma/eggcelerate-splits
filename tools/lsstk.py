import sys, os, ntpath
import xml.etree.ElementTree as XmlTree
from optparse import OptionParser

def ReadLssFile(path):
    if not os.path.exists(path):
        print("Could not find the .lss file.")
        return ""

    if os.path.splitext(path)[-1::][0] != ".lss":
        print("Given input is not a .lss file.")
        return ""
    
    try:
        lss = open(path, 'r')
        output = lss.read()
        lss.close()

        return output
    except Exception as e:
        print(f"Error occured when parsing lss file: {e}")

def CleanXML(xml):
    #Seems like livesplit adds 3 magic bytes 0xEF, 0xBB, and 0xBF. 
    if xml[0] != "<":
        offset = 0

        while xml[offset] != "<":
            offset = offset + 1
        
        print(f"Cleaned input, set offset to {offset}")
        return xml[offset:len(xml)]

    return xml

def Lsstk_strip(data):
    name = data["name"]
    path = data["path"]
    xml = data["xml"]

    removeTags = ( 
        "AttemptHistory", 
        "SegmentHistory", 
        "SplitTime",
        "BestSegmentTime",
        "AutoSplitterSettings"
    )

    fillTags = {
        "AttemptCount": "0"
    }

    removedChilds = 0
    clearedElem = 0
    changedElem = 0

    for elem in xml.iter():
        if elem.tag in fillTags: 
            elem.text = fillTags[elem.tag]
            changedElem = changedElem + 1

        elif elem.tag in removeTags: 
            for child in list(elem):
                elem.remove(child)
                removedChilds = removedChilds + 1
            
            elem.text = ""
            clearedElem = clearedElem + 1

    outPath = os.path.join(path, f"{name}_cleaned.lss") 
    xml.write(outPath, encoding="utf-8")

    print(f"Cleared {clearedElem} elements with a total of {removedChilds} subnodes and changed value of {changedElem} nodes.")

def Lsstk_merge(data):
    #TODO: Merge older .lss with same split and transpose the history, best segments, and times, etc.
    return

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-a", "--action", dest="action", action="store", help="Which action to perform. supported: cleardata")
    parser.add_option("-i", "--input", dest="input", action="store", help="Input .lss file to parse.")
    options, args = parser.parse_args()

    inp = options.input
    action = options.action

    if not inp:
        print("No .lss file provided.")
        sys.exit(1)

    if not action:
        print("No action specified")
        sys.exit(1)

    output = ReadLssFile(inp)

    if not output:
        print(f"Failed reading the .lss file")
        sys.exit(1)

    actionMap = {
        "cleardata":    lambda data: Lsstk_strip(data),
        "cd":           lambda data: Lsstk_strip(data)
    }

    if not action in actionMap:
        print(f"Unrecognized action '{action}'")
        sys.exit(1)

    xml = XmlTree.fromstring(CleanXML(output))
    tree = XmlTree.ElementTree(xml)

    data = {
        "name": os.path.splitext(ntpath.basename(inp))[0],
        "path": os.path.dirname(inp),
        "xml": tree
    }

    func = actionMap[action]
    func(data)

    print("ok")

