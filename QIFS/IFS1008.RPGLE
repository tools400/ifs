**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1008

// &1[1008] Fehler beim Setzen des Schreib-/Lesezeigers der IF

dcl-ds IFS1008;
  IFS10081 char(001) inz(*blanks);
  IFS10082 char(128) inz(*blanks);
  IFS10083 packed(010) inz(*zeros);
  IFS10084 char(128) inz(*blanks);
  IFS10085 packed(010) inz(*zeros);
  IFS10086 packed(010) inz(*zeros);
end-ds;
dcl-s IFS1008# bindec(8) inz(0275);
