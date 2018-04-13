      *===============================================================*
      *    CALL PGM(IFSTEST_08)                                       *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/IFS      +         *
      *                                        &LI/BASICS1) +         *
      *                              BNDDIR(QC2LE         ) +         *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QIFS,PIFS
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('IFSTEST_08')
      *
     D main...
     D                 PR
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
      *
      *  Helper fields
     D curDir          S                   like(ifs_path_t ) inz
     D tmpDir          S                   like(ifs_path_t ) inz
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P main...
     P                 E
      *
