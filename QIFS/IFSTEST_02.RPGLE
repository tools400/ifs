**FREE
//===============================================================*
//    CALL PGM(IFSTEST_02) PARM('/home/raddatz/Lazy_Dog.txt')    *
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
//                              BNDSRVPGM(&LI/IFS      +         *
//                                        &LI/BASICS1) +         *
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

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_02');
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
  DCL-S buffer CHAR(256) INZ(*ALLx'00');
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Open IFS file (The file must exists!)
  // Open flags:     read
  //                 share with readers
  //                 open for text data
hFile = f_openIfsFile(%trim(i_path): O_RDONLY + O_SHARE_RDONLY +
                                     O_TEXTDATA);

  // Read lines until EOF
bytesRed = f_readLineIfsFile(
              hFile: %addr(buffer): %size(buffer): *omit: msg);
dow   bytesRed <> cIFS_EOF;
   msg = f_newMsg('CPF9897': 'Num bytes: ' +
                     %char(bytesRed) + ':' + f_left(buffer: bytesRed));
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

   reset buffer;
   bytesRed = f_readLineIfsFile(
                 hFile: %addr(buffer): %size(buffer): *omit: msg);
enddo;

  // Close IFS file
f_closeIfsFile(hFile);

return;


END-PROC MAIN;