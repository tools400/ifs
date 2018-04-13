      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1001
      *
      * &1[1001] Fehler beim Schließen der IFS-Datei '&2' aufgetret
      *
     D IFS1001         DS
     D  IFS10011                    001A   INZ(*BLANKS)
     D  IFS10012                    128A   INZ(*BLANKS)
     D  IFS10013                    010P 0 INZ(*ZEROS )
     D  IFS10014                    128A   INZ(*BLANKS)
     D IFS1001#        S              8B 0 INZ(0263)
      *
