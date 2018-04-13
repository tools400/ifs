      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1006
      *
      * &1[1006] Fehler beim Ermitteln der Größe der IFS-Datei '&2'
      *
     D IFS1006         DS
     D  IFS10061                    001A   INZ(*BLANKS)
     D  IFS10062                    128A   INZ(*BLANKS)
     D  IFS10063                    010P 0 INZ(*ZEROS )
     D  IFS10064                    128A   INZ(*BLANKS)
     D IFS1006#        S              8B 0 INZ(0263)
      *
