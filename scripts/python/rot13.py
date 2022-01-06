import sys
import codecs

encrypted = codecs.encode(" ".join(sys.argv[1:]), 'rot_13')
print(encrypted)
