      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1004
      *
      * &1[1004] Fehler beim Lesen aus der IFS-Datei '&2' aufgetret
      *
     D IFS1004         DS
     D  IFS10041                    001A   INZ(*BLANKS)
     D  IFS10042                    128A   INZ(*BLANKS)
     D  IFS10043                    010P 0 INZ(*ZEROS )
     D  IFS10044                    128A   INZ(*BLANKS)
     D IFS1004#        S              8B 0 INZ(0263)
      *
