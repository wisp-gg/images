import os
import struct
import zipfile

def getHeader(data, header):
    for x in data.split("\n"):
        key, value = x.strip().split(":")
        if key.lower() == header.lower():
            return value.strip()

    raise Exception("Couldn't find header " + header)

def getJavaVersion(target):
    with zipfile.ZipFile(target, "r") as zip:
        manifest_data = zip.read("META-INF/MANIFEST.MF").decode()
        main_class_path = getHeader(manifest_data, "Main-Class")

        with zip.open(main_class_path.replace(".", "/") + ".class") as main_class_data:
            header = main_class_data.read(4)
            if header != b"\xca\xfe\xba\xbe":
                raise Exception("Magic header of main java class is not CAFEBABE?")

            minor_version, = struct.unpack('>H', main_class_data.read(2))
            major_version, = struct.unpack('>H', main_class_data.read(2))
            
            return major_version, minor_version

default = "java11"
def getExecutablePath(target):
    try:
        major_version, minor_version = getJavaVersion(target)

        if major_version >= 60: # TODO: replace with java 17 when released
            return "java16"
        elif major_version >= 55:
            return "java11"
        else:
            return "java8"
    except:
        return default

def getJarFromStartup():
    startup = os.getenv("MODIFIED_STARTUP", "")
    splitted = startup.split(" ")
    for x in splitted:
        if x.strip().endswith(".jar"):
            executable = getExecutablePath(x.strip())
            splitted[0] = executable
            break

    return " ".join(splitted)

print(getJarFromStartup())