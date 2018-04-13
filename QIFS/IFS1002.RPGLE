      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1002
      *
      * &1[1002] Fehler beim Schreiben in die IFS-Datei '&2' aufget
      *
     D IFS1002         DS
     D  IFS10021                    001A   INZ(*BLANKS)
     D  IFS10022                    128A   INZ(*BLANKS)
     D  IFS10023                    010P 0 INZ(*ZEROS )
     D  IFS10024                    128A   INZ(*BLANKS)
     D IFS1002#        S              8B 0 INZ(0263)
      *
