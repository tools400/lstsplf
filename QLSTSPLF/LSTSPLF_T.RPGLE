      *=====================================================================*                 RADDAT
      *  Author  :  Thomas Raddatz                                          *                 RADDAT
      *  Date    :  16.09.2002                                              *                 RADDAT
      *  E-mail  :  thomas.raddatz@tools400.de                              *                 RADDAT
      *  Homepage:  www.tools400.de                                         *                 RADDAT
      *=====================================================================*                 RADDAT
      *                                                                     *                 RADDAT
      *  This software is free software, you can redistribute it and/or     *                 RADDAT
      *  modify it under the terms of the GNU General Public License (GPL)  *                 RADDAT
      *  as published by the Free Software Foundation.                      *                 RADDAT
      *                                                                     *                 RADDAT
      *  See GNU General Public License for details.                        *                 RADDAT
      *          http://www.opensource.org                                  *                 RADDAT
      *          http://www.opensource.org/licenses/gpl-license.html        *                 RADDAT
      *                                                                     *                 RADDAT
      *=====================================================================*                 RADDAT
      *  History:                                                           *                 RADDAT
      *                                                                     *                 RADDAT
      *  Datum       Name          Änderung                                 *                 RADDAT
      *  ----------  ------------  ---------------------------------------  *                 RADDAT
      *  26.09.2002  Th.Raddatz    Added reference field msg_t.             *                 RADDAT
      *  26.09.2002  Th.Raddatz    Added msg parameter to the               *                 RADDAT
 RAD  *                            f_opnSplFLst() procedure call to get     *                 RADDAT
 RAD  *                            error message back to caller.            *                 RADDAT
      *                                                                     *                 RADDAT
      *=====================================================================*                 RADDAT
 RAD  *   >>PRE-COMPILER<<                                                  *                 RADDAT
 RAD  *                                                                     *                 RADDAT
 RAD  *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *                 RADDAT
 RAD  *                              SRCFILE(&SL/&SF) +                     *                 RADDAT
 RAD  *                              SRCMBR(&SM);                           *                 RADDAT
 RAD  *                                                                     *                 RADDAT
 RAD  *     >>COMPILE<<                                                     *                 RADDAT
      *       >>PARM<< TRUNCNBR(*NO);                                       *                 RADDAT
      *       >>PARM<< DBGVIEW(*LIST);                                      *                 RADDAT
 RAD  *     >>END-COMPILE<<                                                 *                 RADDAT
 RAD  *                                                                     *                 RADDAT
 RAD  *     >>EXECUTE<<                                                     *                 RADDAT
 RAD  *                                                                     *                 RADDAT
 RAD  *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *                 RADDAT
 RAD  *                              MODULE(*PGM) +                         *                 RADDAT
 RAD  *                              BNDSRVPGM(&LI/LSTSPLF) +               *                 RADDAT
 RAD  *                              ACTGRP(*NEW) +                         *                 RADDAT
 RAD  *                              DETAIL(*BASIC);                        *                 RADDAT
 RAD  *                                                                     *                 RADDAT
 RAD  *   >>END-PRE-COMPILER<<                                              *                 RADDAT
      *=====================================================================*                 RADDAT
     H EXTBININT(*YES)                                                                        RADDAT
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)                                                  RADDAT
      *=====================================================================*                 RADDAT
      *                                                                                       RADDAT
 CPY  /COPY QLSTSPLF,PLSTSPLF                                                                 RADDAT
      *                                                                                       RADDAT
      *  Referenzfelder                                                                       RADDAT
      /IF NOT DEFINED (msg_t)                                                                 RADDAT
      /DEFINE msg_t                                                                           RADDAT
     D msg_t         E DS                  extname(XDMSG    ) based(pDummy)                   RADDAT
     D                                     prefix(msg_t_    )                                 RADDAT
      /ENDIF                                                                                  RADDAT
      *                                                                                       RADDAT
      *  *ENTRY Parameterliste                                                                RADDAT
     D LSTSPLF_T...                                                                           RADDAT
     D                 PR                  extpgm('LSTSPLF_T')                                RADDAT
     D  gi_user                      10A   const                                              RADDAT
     D  gi_outQ                      10A   const                                              RADDAT
     D  gi_outQLib                   10A   const                                              RADDAT
      *                                                                                       RADDAT
      *  Referenzfelder                                                                       RADDAT
      *                                                                                       RADDAT
      *  Prototypen für interne Funktionen                                                    RADDAT
     D p_main...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D  i_user                       10A   const                                              RADDAT
     D  i_outQ                       10A   const                                              RADDAT
     D  i_outQLib                    10A   const                                              RADDAT
      *                                                                                       RADDAT
      *  globale Konstanten                                                                   RADDAT
     D cTrue           C                   const(*on )                                        RADDAT
     D cFalse          C                   const(*off)                                        RADDAT
      *                                                                                       RADDAT
      ********************************************************************                    RADDAT
      *  Hauptsteuerleiste des RPG                                                            RADDAT
      ********************************************************************                    RADDAT
      *                                                                                       RADDAT
     D LSTSPLF_T...                                                                           RADDAT
     D                 PI                                                                     RADDAT
     D  gi_user                      10A   const                                              RADDAT
     D  gi_outQ                      10A   const                                              RADDAT
     D  gi_outQLib                   10A   const                                              RADDAT
      *                                                                                       RADDAT
     C                   Callp     p_main(gi_user: gi_outQ: gi_outQLib)                       RADDAT
      *                                                                                       RADDAT
     C                   Eval      *inlr = *on                                                RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Main Prozedur                                                                        RADDAT
      *  (so hat man auch in der "Hauptsteuerleiste" lokale Variablen)                        RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P p_main...                                                                              RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D p_main...                                                                              RADDAT
     D                 PI                                                                     RADDAT
     D  i_user                       10A   const                                              RADDAT
     D  i_outQ                       10A   const                                              RADDAT
     D  i_outQLib                    10A   const                                              RADDAT
      *                                                                                       RADDAT
      *  Lokale Arbeitsfelder                                                                 RADDAT
     D isDone1         S               N   inz                                                RADDAT
     D isDone2         S               N   inz                                                RADDAT
      *                                                                                       RADDAT
     D handle1         S                   like(lstSplF_handle_t)  inz                        RADDAT
     D handle2         S                   like(lstSplF_handle_t)  inz                        RADDAT
      *                                                                                       RADDAT
     D data            S                   like(data_1)         inz                           RADDAT
      *                                                                                       RADDAT
     D data_1        E DS                  extname(XDSPLF0100)  inz                           RADDAT
     D                                     prefix(data_1_    )                                RADDAT
      *                                                                                       RADDAT
     D data_2        E DS                  extname(XDSPLF0100)  inz                           RADDAT
     D                                     prefix(data_2_    )                                RADDAT
      *                                                                                       RADDAT
     D spla0100_1    E DS                  extname(XDSPLA0100)  inz                           RADDAT
     D                                     prefix(spla0100_1_)                                RADDAT
      *                                                                                       RADDAT
     D spla0100_2    E DS                  extname(XDSPLA0100)  inz                           RADDAT
     D                                     prefix(spla0100_2_)                                RADDAT
      *                                                                                       RADDAT
     D screen_msg      DS                                                                     RADDAT
     D  blank1                        1A   inz                                                RADDAT
     D  col1                         10A   inz                                                RADDAT
     D  blank2                        1A   inz                                                RADDAT
     D  col2                         10A   inz                                                RADDAT
     D  blank3                        3A   inz                                                RADDAT
     D  col3                         10A   inz                                                RADDAT
     D  blank4                        1A   inz                                                RADDAT
     D  col4                         10A   inz                                                RADDAT
      *                                                                                       RADDAT
     D ok              S              1A   inz                                                RADDAT
     D msg             S                   like(msg_t     )  inz                              RADDAT
      *                                                                                       RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
      *  Ausgeben Überschrift                                                                 RADDAT
     C                   Clear                   screen_msg                                   RADDAT
     C     screen_msg    Dsply                                                                RADDAT
     C                   Clear                   screen_msg                                   RADDAT
     C                   Eval      col1 = 'User:'                                             RADDAT
     C                   Eval      col2 = '*USRDTA'                                           RADDAT
     C                   Eval      col3 = 'OutQ:'                                             RADDAT
     C                   Eval      col4 = '*USERNAME'                                         RADDAT
     C     screen_msg    Dsply                                                                RADDAT
     C                   Clear                   screen_msg                                   RADDAT
     C                   Eval      col1 = *ALL'-'                                             RADDAT
     C                   Eval      col2 = *ALL'-'                                             RADDAT
     C                   Eval      col3 = *ALL'-'                                             RADDAT
     C                   Eval      col4 = *ALL'-'                                             RADDAT
     C     screen_msg    Dsply                                                                RADDAT
      *                                                                                       RADDAT
      *  Öffnen der 1. Liste                                                                  RADDAT
     C                   Eval      isDone1 = f_opnSplFLst(i_user      :         user          RADDAT
     C                                                    '*ALL'      :         outQ          RADDAT
     C                                                    ''          :         outQLib       RADDAT
     C                                                    '*ALL'      :         formType      RADDAT
     C                                                    '*ALL'      :         usrDta        RADDAT
     C                                                    '*USRDTA'   :         sort by       RADDAT
     C                                                    handle1     :         handle        RADDAT
     C                                                    msg         )                       RADDAT
      *                                                                                       RADDAT
      *  Öffnen der 2. Liste                                                                  RADDAT
     C                   Eval      isDone2 = f_opnSplFLst('*ALL'      :         user          RADDAT
     C                                                    i_outQ      :         outQ          RADDAT
     C                                                    i_outQLib   :         outQLib       RADDAT
     C                                                    '*ALL'      :         formType      RADDAT
     C                                                    '*ALL'      :         usrDta        RADDAT
     C                                                    '*USERNAME' :         sort by       RADDAT
     C                                                    handle2     :         handle        RADDAT
     C                                                    msg         )                       RADDAT
      *                                                                                       RADDAT
      *  Lesen 1. Eintrag der 1. Liste                                                        RADDAT
     C                   Eval      isDone1 = f_getFirstSplF(handle1 :                         RADDAT
     C                                                      data    )                         RADDAT
 B01 C                   If        isDone1                                                    RADDAT
     C                   Eval      data_1  = data                                             RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Clear                   data_1                                       RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *  Lesen 1. Eintrag der 2. Liste                                                        RADDAT
     C                   Eval      isDone2 = f_getFirstSplF(handle2 :                         RADDAT
     C                                                      data    )                         RADDAT
 B01 C                   If        isDone2                                                    RADDAT
     C                   Eval      data_2  = data                                             RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Clear                   data_2                                       RADDAT
 E01 C                   Endif                                                                RADDAT
     C                                                                                        RADDAT
      *                                                                                       RADDAT
 B01 C                   Dow       isDOne1 or isDone2                                         RADDAT
      *                                                                                       RADDAT
      *  Abrufen der Spoolfileattribute                                                       RADDAT
 B02 C                   If        isDone1                                                    RADDAT
     C                   Eval      SPLA0100_1 = f_rtvSplFA(data_1_intJobID  :                 RADDAT
     C                                                     data_1_intSplFID )                 RADDAT
 X02 C                   Else                                                                 RADDAT
     C                   Clear                   SPLA0100_1                                   RADDAT
 E02 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
 B02 C                   If        isDone2                                                    RADDAT
     C                   Eval      SPLA0100_2 = f_rtvSplFA(data_2_intJobID  :                 RADDAT
     C                                                     data_2_intSplFID )                 RADDAT
 X02 C                   Else                                                                 RADDAT
     C                   Clear                   SPLA0100_2                                   RADDAT
 E02 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *  Anzeigen gelesene Einträge                                                           RADDAT
     C                   Reset                   screen_msg                                   RADDAT
     C                   Eval      col1 = spla0100_1_splFName                                 RADDAT
     C                   Eval      col2 = spla0100_1_usrDta                                   RADDAT
     C                   Eval      col3 = spla0100_2_splFName                                 RADDAT
     C                   Eval      col4 = spla0100_2_user                                     RADDAT
     C     screen_msg    Dsply                                                                RADDAT
      *                                                                                       RADDAT
      *  Lesen weitere Einträge Liste 1                                                       RADDAT
     C                   Eval      isDone1 = f_getNextSplF(handle1  :                         RADDAT
     C                                                    data      )                         RADDAT
 B02 C                   If        isDone1                                                    RADDAT
     C                   Eval      data_1  = data                                             RADDAT
 X02 C                   Else                                                                 RADDAT
     C                   Clear                   data_1                                       RADDAT
 E02 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *  Lesen weitere Einträge Liste 2                                                       RADDAT
     C                   Eval      isDone2 = f_getNextSplF(handle2  :                         RADDAT
     C                                                    data      )                         RADDAT
 B02 C                   If        isDone2                                                    RADDAT
     C                   Eval      data_2  = data                                             RADDAT
 X02 C                   Else                                                                 RADDAT
     C                   Clear                   data_2                                       RADDAT
 E02 C                   Endif                                                                RADDAT
 E01 C                   Enddo                                                                RADDAT
      *                                                                                       RADDAT
      *  Anzeigen "Ende" Nachricht                                                            RADDAT
     C                   Clear                   screen_msg                                   RADDAT
     C                   Eval      col1 =                                                     RADDAT
     C                               %trim(%editc(f_getNumSplFAvl(handle1):'Z'))              RADDAT
     C                   Eval      col2 =                                                     RADDAT
     C                               %trim(%editc(f_getNumSplFAvl(handle2):'Z'))              RADDAT
     C     screen_msg    Dsply                   ok                                           RADDAT
      *                                                                                       RADDAT
      *  Schließen 1. Liste                                                                   RADDAT
     C                   Eval      isDone1 = f_cloSplFLst(handle1    )                        RADDAT
      *                                                                                       RADDAT
      *  Schließen 2. Liste                                                                   RADDAT
     C                   Eval      isDone2 = f_cloSplFLst(handle2    )                        RADDAT
      *                                                                                       RADDAT
     C                   Return                                                               RADDAT
      *                                                                                       RADDAT
     P p_main...                                                                              RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
