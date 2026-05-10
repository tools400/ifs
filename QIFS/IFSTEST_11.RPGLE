**FREE
//===============================================================*
//    CALL PGM(IFSTEST_11) PARM('/home/raddatz/fileName')        *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/IFS    ) +         *
//                              BNDDIR(QC2LE         ) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
CTL-OPT DEBUG OPTION(*SRCSTMT: *NODEBUGIO);
CTL-OPT DECEDIT('0,') DATEDIT(*DMY.);
CTL-OPT DATFMT(*ISO) TIMFMT(*ISO);
CTL-OPT EXPROPTS(*RESDECPOS);
CTL-OPT EXTBININT(*YES);
//===============================================================*
//
// ------------------------------------
//  Type Definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QIFS,PIFS

// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Global Constants
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_11');
  gi_path CHAR(32) CONST;
END-PR;

DCL-PR main;
  i_path CHAR(32) CONST;
END-PR;

//===============================================================*
//  Program Entry Point
//===============================================================*
DCL-PI PGM_ENTRY_POINT;
  gi_path CHAR(32) CONST;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main(gi_path);

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  DCL-PI *N;
    i_path CHAR(32) CONST;
  END-PI;

  //  Helper fields
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  DCL-S bytesRed INT(10) INZ;
  DCL-S buffer CHAR(64) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Open IFS file (The file must not yet exists!)
  // Open flags:     read & write
  //                 share with readers
  //                 create file, send message if file exists
  //                 open for text data
hFile = f_openIfsFile(%trim(i_path)
                      : O_CREAT + O_RDWR + O_CCSID + O_TRUNC +
                        O_TEXTDATA + O_TEXT_CREAT
                      : 1208);

  // Write to file
f_writeIfsFile(hFile: 'Hello World! (äöüÖÄÜß)': 0);
f_writeIfsFile(hFile: x'0D0A': 0);
f_writeIfsFile(hFile: %char(%timestamp()): 0);

  // Close IFS file
f_closeIfsFile(hFile);

return;


END-PROC MAIN;