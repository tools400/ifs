**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1030

// &1[1030] Das aktuelle Verzeichnis konnte nicht auf '&1' ge

dcl-ds IFS1030;
  IFS10301 char(128) inz(*blanks);
  IFS10302 packed(010) inz(*zeros);
  IFS10303 char(128) inz(*blanks);
end-ds;
dcl-s IFS1030# bindec(8) inz(0262);
