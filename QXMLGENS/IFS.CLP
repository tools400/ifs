/* -------------------------------------------------------------------------- */
/* IFS        - SCRIPT MEMBER (German)                                        */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
/* >>PRE-COMPILER<<                                                           */
/*   >>CRTCMD<<  XMLGEN  XMLSCRIPT(&SM) SCRIPTSRCF(&SL/&SF);                  */
/*   >>IMPORTANT<<                                                            */
/*     >>PARM<<  SRCTOFILE(&LI/QXML);                                         */
/*     >>PARM<<  XMLMBR(*SCRIPT);                                             */
/*     >>PARM<<  ENCODING('ISO-8859-1');                                      */
/*     >>PARM<<  AUTHOR('Thomas Raddatz');                                    */
/*   >>END-IMPORTANT<<                                                        */
/*   >>EXECUTE<<                                                              */
/* >>END-PRE-COMPILER<<                                                       */
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QIFS) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Select language (GER, ENG)') +
                          XVALUES(GER ENG) XVAR(&LANG)

             XMLGENCND  XMSG('Use *LIBL at runtime? (L_YES, L_NO)') +
                          XVALUES(L_YES L_NO) XVAR(&L_LIBL)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QIFS)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL  ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_ENG  ) XMBRATR(CLP   ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_GER  ) XMBRATR(CLP   ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README   ) XMBRATR(TXT   ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CLIB      ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS       ) XMBRATR(MAKSRV) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSR01    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1000   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1001   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1002   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1003   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1004   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1005   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1006   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1007   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1008   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1009   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1011   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1012   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1013   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1014   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1015   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1016   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1017   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1018   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1019   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1020   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1021   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1022   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1023   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1024   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1025   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1026   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1027   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1028   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1029   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1030   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1031   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1032   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFS1033   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PIFS      ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_01) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_02) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_03) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_04) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_05) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_06) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_07) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_08) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_09) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_10) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_30) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_31) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_32) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_33) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_98) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(IFSTEST_99) XMBRATR(RPGLE ) +
                          XFROMSRCF(QIFS      ) XFROMSRCL(TOOLS400   ) +
                          XTOSRCF(QIFS      ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QIFS) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&LANG' '&L_LIBL'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

