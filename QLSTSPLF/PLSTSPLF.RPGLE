      *=====================================================================*                 RADDAT
      *  Author  :  Thomas Raddatz                                          *                 RADDAT
      *  Date    :  16.09.2002                                              *                 RADDAT
      *  E-mail  :  thomas.raddatz@tools400.de                              *                 RADDAT
      *  Homepage:  www.tools400.de                                         *                 RADDAT
      *=====================================================================*                 RADDAT
      *                                                                                       RADDAT
      *  Referenzfelder                                                                       RADDAT
      /IF NOT DEFINED(spla0100_t)                                                             RADDAT
      /DEFINE spla0100_t                                                                      RADDAT
     D spla0100_t    E DS                  extname(XDSPLA0100) based(pDummy)                  RADDAT
     D                                     prefix(spla0100_t )                                RADDAT
      /ENDIF                                                                                  RADDAT
      *                                                                                       RADDAT
      *===============================================================*                       RADDAT
      *  Reference fields                                                                     RADDAT
      *===============================================================*                       RADDAT
     D lstSplF_handle_t...                                                                    RADDAT
     D                 S               *   based(pDummy)                                      RADDAT
      *
      *==================================================================*                    RADDAT
      *  Open List Of Spooled Files                                                           RADDAT
      *==================================================================*                    RADDAT
      *
     D f_opnSplFLst...                                                                        RADDAT
     D                 PR              N   opdesc                                             RADDAT
     D                                     extproc('LSTSPLF+                                  RADDAT
     D                                     _f_opnSplFLst+                                     RADDAT
     D                                     ')                                                 RADDAT
     D  i_user                       10A   value                                              RADDAT
     D  i_outQ                       10A   value                                              RADDAT
     D  i_outQLib                    10A   value                                              RADDAT
     D  i_formType                   10A   value                                              RADDAT
     D  i_userData                   10A   value                                              RADDAT
     D  i_orderBy                    10A   value
     D  o_handle                                  like(lstSplF_handle_t)                      RADDAT
     D  o_msg                     32767A          options(*nopass :                           RADDAT
     D                                                    *varsize)                           RADDAT
      *
      *==================================================================*                    RADDAT
      *  Close List Of Spooled Files                                                          RADDAT
      *==================================================================*                    RADDAT
      *
     D f_cloSplFLst...                                                                        RADDAT
     D                 PR              N
     D                                     extproc('LSTSPLF+                                  RADDAT
     D                                     _f_cloSplFLst+                                     RADDAT
     D                                     ')                                                 RADDAT
     D  io_handle                                 like(lstSplF_handle_t)                      RADDAT
      *
      *==================================================================*                    RADDAT
      *  Get First Spooled File                                                               RADDAT
      *==================================================================*                    RADDAT
      *
     D f_getFirstSplF...                                                                      RADDAT
     D                 PR              N   opdesc                                             RADDAT
     D                                     extproc('LSTSPLF+                                  RADDAT
     D                                     _f_getFirstSplF+                                   RADDAT
     D                                     ')                                                 RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
     D  o_data                    32767A   options(*varsize)                                  RADDAT
      *
      *==================================================================*                    RADDAT
      *  Get Next Spooled File                                                                RADDAT
      *==================================================================*                    RADDAT
      *
     D f_getNextSplF...                                                                       RADDAT
     D                 PR              N   opdesc                                             RADDAT
     D                                     extproc('LSTSPLF+                                  RADDAT
     D                                     _f_getNextSplF+                                    RADDAT
     D                                     ')                                                 RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
     D  o_data                    32767A   options(*varsize)                                  RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Get Number of Spooled Files available                                                RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     D f_getNumSplFAvl...                                                                     RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('LSTSPLF+                                  RADDAT
     D                                     _f_getNumSplFAvl+                                  RADDAT
     D                                     ')                                                 RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Retrieve Spooled File Attributes                                                     RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     D f_rtvSplFA...                                                                          RADDAT
     D                 PR                  opdesc like(spla0100_t)                            RADDAT
     D                                     extproc('LSTSPLF+                                  RADDAT
     D                                     _f_rtvSplFA+                                       RADDAT
     D                                     ')                                                 RADDAT
     D  i_intJobID                   16A   const                                              RADDAT
     D  i_intSplFID                  16A   const                                              RADDAT
     D  o_msg                     32767A         options(*nopass :                            RADDAT
     D                                                   *varsize)                            RADDAT
      *
