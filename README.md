# IFS - A Tools/400 Service Program

IFS is service program that offers services for reading and writing IFS files and directories.

## Dependencies

Dependencies:

- [BASICS1](https://github.com/tools400/basics1)

## Installation

Compile members with the following PDM option:

   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO)
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)
     USER1(*LIST) USER2(*FULL)

Members of type MAKPGM or BND are used for linking programs (MAKPGM)
and service programs (BND).

---

2018, Thomas Raddatz
