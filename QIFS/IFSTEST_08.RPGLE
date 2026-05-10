**FREE
//===============================================================*
//    CALL PGM(IFSTEST_08)                                       *
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
/COPY QBASICS1,PBASICS1

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_08');
END-PR;

DCL-PR main;
END-PR;

//===============================================================*
//  Program Entry Point
//===============================================================*
DCL-PI PGM_ENTRY_POINT;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  DCL-PI *N;
  END-PI;

  //  Helper fields
  DCL-S curDir LIKE(ifs_path_t) INZ;
  DCL-S tmpDir LIKE(ifs_path_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Retrieving current directory
curDir = f_getIfsCurDir(msg);

msg = f_newMsg('CPF9897': 'Current directory: ' + curDir);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

  // Changing current directory
tmpDir = '/tmp';
if (f_chgIfsCurDir(tmpDir: msg) <> RC_OK);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
endif;

msg = f_newMsg('CPF9897': 'Current directory changed to: ' + tmpDir);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

  // Restoring current directory to its original value
if (f_chgIfsCurDir(curDir: msg) <> RC_OK);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
endif;

msg = f_newMsg('CPF9897': 'Current directory restored to: ' +
                          f_getIfsCurDir(*omit));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

return;


END-PROC MAIN;