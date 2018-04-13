      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1003
      *
      * &1[1003] Fehler beim Verschieben der IFS-Datei '&2' nach '&
      *
     D IFS1003         DS
     D  IFS10031                    001A   INZ(*BLANKS)
     D  IFS10032                    128A   INZ(*BLANKS)
     D  IFS10033                    128A   INZ(*BLANKS)
     D  IFS10034                    010P 0 INZ(*ZEROS )
     D  IFS10035                    128A   INZ(*BLANKS)
     D IFS1003#        S              8B 0 INZ(0391)
      *
