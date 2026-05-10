**FREE
//===============================================================*
//    CALL PGM(IFSTEST_07) PARM('/home/raddatz/fileName.ext')    *
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

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_07');
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
  DCL-S x INT(10) INZ;
  DCL-S y INT(10) INZ;
  DCL-S path VARCHAR(32) INZ;
  DCL-S extension VARCHAR(32) INZ;
  DCL-S extension1 VARCHAR(32) INZ;
  DCL-S extension2 VARCHAR(32) INZ;
  DCL-S path1 VARCHAR(32) INZ;
  DCL-S path2 VARCHAR(32) INZ;
  DCL-S path_wo_ext VARCHAR(32) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path = %trimR(i_path);

  // Retrieve extension of passed in path
x = f_scanR('.': path);
if (x > 0) and (x < %len(path));
   extension1 = %subst(path: x + 1);
   extension2 = f_rtvIfsFileExtFromPath(path);
   p_assert(extension1 = extension2);
   msg = f_newMsg('CPF9897': 'Ext.= ' + path + ' - ' + extension2);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
endif;

  // Remove extension of passed in path
if (x > 1);
   path1 = %subst(path: 1: x - 1);
   path2 = f_rmvIfsFileExtFromPath(path);
   p_assert(path1 = path2);
   msg = f_newMsg('CPF9897': 'Path= ' + path + ' - ' + path2);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
endif;

  // Retrieve extensions
extension = 'anExt';

for y = %len(extension) + 2 downto 0;

   path = '/home/theFileName.' + extension;
   path = %subst(path: 1: %len(path) - y);

   x = f_scanR('.': path);
   if (x > 0) and (x < %len(path));
      extension1 = %subst(path: x + 1);
   else;
      extension1 = '';
   endif;
   extension2 = f_rtvIfsFileExtFromPath(path);
   p_assert(extension1 = extension2);
   msg = f_newMsg('CPF9897': 'Ext.= ' + path + ' - ' + extension2);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

endfor;

return;


END-PROC MAIN;