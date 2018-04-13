      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1005
      *
      * &1[1005] Fehler beim Löschen der IFS-Datei '&2' aufgetreten
      *
     D IFS1005         DS
     D  IFS10051                    001A   INZ(*BLANKS)
     D  IFS10052                    128A   INZ(*BLANKS)
     D  IFS10053                    010P 0 INZ(*ZEROS )
     D  IFS10054                    128A   INZ(*BLANKS)
     D IFS1005#        S              8B 0 INZ(0263)
      *
