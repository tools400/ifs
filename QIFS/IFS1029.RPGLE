**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1029

// &1[1029] Das aktuelle Verzeichnis konnte nicht ermittelt we

dcl-ds IFS1029;
  IFS10291 packed(010) inz(*zeros);
  IFS10292 char(128) inz(*blanks);
end-ds;
dcl-s IFS1029# bindec(8) inz(0134);
