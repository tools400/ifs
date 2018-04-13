      *===============================================================*
      *    CALL PGM(IFSTEST_09) PARM('/home/raddatz/test_ifs/*')      *
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
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('IFSTEST_09')
     D  gi_path                      32A   const
      *
     D main...
     D                 PR
     D  i_path                       32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_path                      32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_path);

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
     D  i_path                       32A   const
      *
      *  Helper fields
     D numEntries      S             10I 0                     inz
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         f_sndPgmMsg(f_newMsg(cMsg_ID_NONE
                     : 'Delete all files and subdirectories:')
                     : cMsg_Prv: cMsg_ToCtlBdy);

         numEntries = f_dltIfsDir(i_path
                                  : cIFS_RMDIR_DELETE_FILES +
                                    cIFS_RMDIR_DELETE_SUB_DIRECTORIES +
                                    cIFS_RMDIR_TEST_MODE
                                  : msg);

         if (numEntries < 0);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         f_sndPgmMsg(f_newMsg(cMsg_ID_NONE
                     : 'Delete all files, but no subdirectories:')
                     : cMsg_Prv: cMsg_ToCtlBdy);

         numEntries = f_dltIfsDir(i_path
                                  : cIFS_RMDIR_DELETE_FILES +
                                    cIFS_RMDIR_TEST_MODE
                                  : msg);

         if (numEntries < 0);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         f_sndPgmMsg(f_newMsg(cMsg_ID_NONE: 'Delete only the given directory:')
                     : cMsg_Prv: cMsg_ToCtlBdy);

         numEntries = f_dltIfsDir(i_path
                                  : cIFS_RMDIR_TEST_MODE
                                  : msg);

         if (numEntries < 0);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
