      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1000
      *
      * &1[1000] Fehler beim Öffnen der IFS-Datei '&2' mit Fehlerco
      *
     D IFS1000         DS
     D  IFS10001                    001A   INZ(*BLANKS)
     D  IFS10002                    128A   INZ(*BLANKS)
     D  IFS10003                    010P 0 INZ(*ZEROS )
     D  IFS10004                    128A   INZ(*BLANKS)
     D IFS1000#        S              8B 0 INZ(0263)
      *
