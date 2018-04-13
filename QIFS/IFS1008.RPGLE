      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1008
      *
      * &1[1008] Fehler beim Setzen des Schreib-/Lesezeigers der IF
      *
     D IFS1008         DS
     D  IFS10081                    001A   INZ(*BLANKS)
     D  IFS10082                    128A   INZ(*BLANKS)
     D  IFS10083                    010P 0 INZ(*ZEROS )
     D  IFS10084                    128A   INZ(*BLANKS)
     D  IFS10085                    010P 0 INZ(*ZEROS )
     D  IFS10086                    010P 0 INZ(*ZEROS )
     D IFS1008#        S              8B 0 INZ(0275)
      *
