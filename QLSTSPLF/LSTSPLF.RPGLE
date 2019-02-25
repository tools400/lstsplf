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
      *  26.09.2002  Th.Raddatz    Added DEFINE statements to the           *                 RADDAT
 RAD  *                            reference fields to prevent compiler     *                 RADDAT
 RAD  *                            error message RNF3316                    *                 RADDAT
      *  26.09.2002  Th.Raddatz    Changed how the API error message is     *                 RADDAT
 RAD  *                            is assigned to o_msg in routine          *                 RADDAT
 RAD  *                            f_opnSplFLst() to ensure proper value.   *                 RADDAT
      *  03.06.2003  Th.Raddatz    Changed service program to use a pointer *                 RADDAT
      *                            instead of a data structure as the       *                 RADDAT
      *                            handle.                                  *                 RADDAT
      *                            Added reference field for handle.        *                 RADDAT
      *  30.06.2003  Th.Raddatz    Removed improper const keyword from      *                 RADDAT
      *                            prototypes: QUSCRTUS, QUSDLTUS,          *                 RADDAT
      *                                        QUSPTRUS, QUSLSPL.           *                 RADDAT
      *  30.06.2003  Th.Raddatz    Changed definition of errCode parameter  *                 RADDAT
      *                            to use reference field.                  *                 RADDAT
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
 RAD  *     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *                 RADDAT
 RAD  *                              MODULE(&LI/&OB)  +                     *                 RADDAT
 RAD  *                              EXPORT(*ALL) +                         *                 RADDAT
 RAD  *                              ACTGRP(*CALLER) +                      *                 RADDAT
 RAD  *                              DETAIL(*BASIC) +                       *                 RADDAT
 RAD  *                              ALWUPD(*YES) +                         *                 RADDAT
 RAD  *                              ALWLIBUPD(*YES) +                      *                 RADDAT
 RAD  *                              TEXT('SrvPgm  : List Spooled +         *                 RADDAT
 RAD  *                                    Files');                         *                 RADDAT
 RAD  *                                                                     *                 RADDAT
 RAD  *   >>END-PRE-COMPILER<<                                              *                 RADDAT
      *=====================================================================*                 RADDAT
     H NOMAIN                                                                                 RADDAT
     H OPTION(*SRCSTMT : *NODEBUGIO)                                                          RADDAT
     H EXTBININT(*YES) BNDDIR('QC2LE')                                                        RADDAT
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)                                                  RADDAT
     H COPYRIGHT('V1.2 - 26.09.2002 - mailto:thomas.raddatz@tools400.de')                     RADDAT
      *=====================================================================*                 RADDAT
      *                                                                                       RADDAT
      *  Referenzfelder                                                                       RADDAT
      /IF NOT DEFINED(spla0100_t)                                                             RADDAT
      /DEFINE spla0100_t                                                                      RADDAT
     D spla0100_t    E DS                  extname(XDSPLA0100) based(pDummy)                  RADDAT
     D                                     prefix(spla0100_t )                                RADDAT
      /ENDIF                                                                                  RADDAT
      *                                                                                       RADDAT
      /IF NOT DEFINED (errCode_t)                                                             RADDAT
      /DEFINE errCode_t                                                                       RADDAT
     D errCode_t     E DS                  extname(xderrcode ) based(pDummy)                  RADDAT
     D                                     prefix(errCode_t_ )                                RADDAT
      /ENDIF                                                                                  RADDAT
      *                                                                                       RADDAT
      /IF NOT DEFINED (msg_t)                                                                 RADDAT
      /DEFINE msg_t                                                                           RADDAT
     D msg_t         E DS                  extname(XDMSG     ) based(pDummy)                  RADDAT
     D                                     prefix(msg_t_     )                                RADDAT
      /ENDIF                                                                                  RADDAT
      *                                                                                       RADDAT
      *  Prototypen für exportierte Funktionen                                                RADDAT
 CPY  /COPY QLSTSPLF,PLSTSPLF                                                                 RADDAT
      *                                                                                       RADDAT
      *  Prototypen für interne Funktionen                                                    RADDAT
     D f_getEntry...                                                                          RADDAT
     D                 PR              N                                                      RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
     D  o_data                    32767A          options(*varsize)                           RADDAT
     D  i_length                     10I 0 value                                              RADDAT
      *                                                                                       RADDAT
     D f_crtUsrSpc...                                                                         RADDAT
     D                 PR              N                                                      RADDAT
     D  i_spcName                    10A   value                                              RADDAT
     D  i_spcLib                     10A   value                                              RADDAT
     D  i_text                       50A   value                                              RADDAT
     D  o_errCode                                 like(errCode_t )                            RADDAT
      *                                                                                       RADDAT
     D f_dltUsrSpc...                                                                         RADDAT
     D                 PR              N                                                      RADDAT
     D  i_spcName                    10A   value                                              RADDAT
     D  i_spcLib                     10A   value                                              RADDAT
      *                                                                                       RADDAT
     D f_getTmpName...                                                                        RADDAT
     D                 PR              N                                                      RADDAT
     D  o_fileName                   10A                                                      RADDAT
     D  o_fileLib                    10A                                                      RADDAT
      *                                                                                       RADDAT
     D f_isApiError...                                                                        RADDAT
     D                 PR              N                                                      RADDAT
     D  i_errCode                          value  like(errCode_t )                            RADDAT
      *                                                                                       RADDAT
     D f_newApiErrCode...                                                                     RADDAT
     D                 PR                         like(errCode_t )                            RADDAT
     D  i_monmsg                       N   value                                              RADDAT
      *                                                                                       RADDAT
     D f_cvtApiErrCodeToMsg...                                                                RADDAT
     D                 PR                         like(msg_t     )                            RADDAT
     D  i_errCode                          value  like(errCode_t )                            RADDAT
      *                                                                                       RADDAT
     D f_sortLst...                                                                           RADDAT
     D                 PR              N                                                      RADDAT
     D  i_pUsrSpc                      *   value                                              RADDAT
     D  i_compare                    10A   value                                              RADDAT
      *                                                                                       RADDAT
     D f_sortLstByUsrDta...                                                                   RADDAT
     D                 PR            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
     D f_sortLstByUserName...                                                                 RADDAT
     D                 PR            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
     D f_sortLstByPagesAsc...                                                                 RADDAT
     D                 PR            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
     D f_sortLstByPagesDsc...                                                                 RADDAT
     D                 PR            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren CEE-Funktionen                                                           RADDAT
     D ceegsi          PR                  extproc('CEEGSI')                                  RADDAT
     D  i_posN                       10I 0 const                                              RADDAT
     D  o_dataType                   10I 0                                                    RADDAT
     D  o_currLen                    10I 0                                                    RADDAT
     D  o_maxLen                     10I 0                                                    RADDAT
     D  o_fc                         12A          options(*omit)                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren C-Funktionen                                                             RADDAT
     D tmpnam          PR              *   extproc('tmpnam')                                  RADDAT
     D  io_pTmpName                    *   value                                              RADDAT
      *                                                                                       RADDAT
     D strtok          PR              *   extproc('strtok')                                  RADDAT
     D  i_string                       *   value options(*string)                             RADDAT
     D  i_token                        *   value options(*string)                             RADDAT
      *                                                                                       RADDAT
     D qsort           PR                  extproc('qsort')                                   RADDAT
     D  i_pBase                        *   value                                              RADDAT
     D  i_num                        10I 0 value                                              RADDAT
     D  i_width                      10I 0 value                                              RADDAT
     D  i_pCompare                     *   value procptr                                      RADDAT
      *                                                                                       RADDAT
     D memcpy          PR                  extproc('memcpy')                                  RADDAT
     D  i_dest                         *   value                                              RADDAT
     D  i_src                          *   value                                              RADDAT
     D  i_count                      10I 0 value                                              RADDAT
      *                                                                                       RADDAT
      *  globale Konstanten                                                                   RADDAT
     D cTrue           C                   const(*on )                                        RADDAT
     D cFalse          C                   const(*off)                                        RADDAT
      *                                                                                       RADDAT
      *  Externe Prototypen                                                                   RADDAT
     D QUSCRTUS...                                                                            RADDAT
     D                 PR                  extpgm('QUSCRTUS')                                 RADDAT
     D  i_qualSpcName                20A   const                                              RADDAT
     D  i_extAtr                     10A   const                                              RADDAT
     D  i_iniSize                    10I 0 const                                              RADDAT
     D  i_iniValue                    1A   const                                              RADDAT
     D  i_pubAuth                    10A   const                                              RADDAT
     D  i_text                       50A   const                                              RADDAT
     D  i_replace                    10A   const                                optGrp 1      RADDAT
     D  io_errCode                32767A          options(*varsize:             optGrp 1      RADDAT
     D                                                    *nopass )                           RADDAT
      *                                                                                       RADDAT
     D QUSDLTUS...                                                                            RADDAT
     D                 PR                  extpgm('QUSDLTUS')                                 RADDAT
     D  i_qUsrSpc                    20A   const                                              RADDAT
     D  io_errCode                32767A          options(*varsize:             optGrp 1      RADDAT
     D                                                    *nopass )                           RADDAT
      *                                                                                       RADDAT
     D QUSPTRUS...                                                                            RADDAT
     D                 PR                  extpgm('QUSPTRUS')                                 RADDAT
     D  i_qUsrSpc                    20A   const                                              RADDAT
     D  o_pUsrSpc                      *                                                      RADDAT
     D  io_errCode                32767A          options(*varsize:             optGrp 1      RADDAT
     D                                                    *nopass )                           RADDAT
      *                                                                                       RADDAT
     D QUSLSPL...                                                                             RADDAT
     D                 PR                  extpgm('QUSLSPL')                                  RADDAT
     D  i_qUsrSpc                    20A   const                                              RADDAT
     D  i_format                      8A   const                                              RADDAT
     D  i_user                       10A   const                                              RADDAT
     D  i_qOutQ                      20A   const                                              RADDAT
     D  i_formType                   10A   const                                              RADDAT
     D  i_usrDta                     10A   const                                              RADDAT
     D  io_errCode                32767A          options(*varsize:             optGrp 1      RADDAT
     D                                                    *nopass )                           RADDAT
     D  i_qJob                       26A   const  options(*nopass )             optGrp 2      RADDAT
     D  i_keys                    32767A   const  options(*varsize:             optGrp 2      RADDAT
     D                                                     *nopass )                          RADDAT
     D  i_numKeys                    10I 0 const  options(*nopass )             optGrp 2      RADDAT
     D  i_auxStgPool                 10I 0 const  options(*nopass )             optGrp 3      RADDAT
      *                                                                                       RADDAT
     D QUSRSPLA...                                                                            RADDAT
     D                 PR                  extpgm('QUSRSPLA')                                 RADDAT
     D  o_rcvVar                  32767A          options(*varsize)                           RADDAT
     D  i_rcvVarLen                  10I 0 const                                              RADDAT
     D  i_format                      8A   const                                              RADDAT
     D  i_qJob                       26A   const                                              RADDAT
     D  i_intJobID                   16A   const                                              RADDAT
     D  i_intSplFID                  16A   const                                              RADDAT
     D  i_splFName                   10A   const                                              RADDAT
     D  i_splFNbr                    10I 0 const                                              RADDAT
     D  io_errCode                32767A          options(*varsize:             optGrp 1      RADDAT
     D                                                    *nopass )                           RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Open List of Spooled Files                                                           RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *  Using format:  SPLF0100                                                              RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *                                                                                       RADDAT
      *  Funktionswert:                                                                       RADDAT
      *                                                                                       RADDAT
      *  cTrue      - Funktion fehlerfrei beendet                                             RADDAT
      *  cFalse     - Fehler aufgetreten                                                      RADDAT
      *                                                                                       RADDAT
      *  Parameter Werte:                                                                     RADDAT
      *                                                                                       RADDAT
      *  i_user     - username, *ALL, *CURRENT                                                RADDAT
      *  i_outQ     - output queue, *ALL (i_outQLib must be *BLANKS)                          RADDAT
      *  i_outQLib  - output queue library, *CURLIB, *LIBL                                    RADDAT
      *  i_formType - form type, *ALL, *STD                                                   RADDAT
      *  i_usrDta   - user data, *ALL                                                         RADDAT
      *  i_orderBy  - Sortierfolge:                                                           RADDAT
      *               *NONE           keine Sortierung                                        RADDAT
      *               *USRDTA         nach Benutzerdaten                                      RADDAT
      *               *USERNAME       nach Benutzerprofil                                     RADDAT
      *               *PAGES_ASC      nach Anzahl Seiten (aufsteigend)                        RADDAT
      *               *PAGES_DSC      nach Anzahl Seiten (absteigend)                         RADDAT
      *  o_handle   - list handle                                                             RADDAT
      *  o_msg      - error message                                                           RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_opnSplFLst...                                                                        RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D f_opnSplFLst...                                                                        RADDAT
     D                 PI              N   opdesc                                             RADDAT
     D  i_user                       10A   value                                              RADDAT
     D  i_outQ                       10A   value                                              RADDAT
     D  i_outQLib                    10A   value                                              RADDAT
     D  i_formType                   10A   value                                              RADDAT
     D  i_usrDta                     10A   value                                              RADDAT
     D  i_orderBy                    10A   value                                              RADDAT
     D  o_handle                                  like(lstSplF_handle_t)                      RADDAT
     D  o_msg                     32767A          options(*nopass :                           RADDAT
     D                                                    *varsize)                           RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Parameterpositionen                                                      RADDAT
     D cpMsg           C                   const(8)                                           RADDAT
      *                                                                                       RADDAT
      *  Deklarieren optionale Parameterfelder                                                RADDAT
     D msg           E DS                  extname(XDMSG     )  inz                           RADDAT
     D                                     prefix(msg_       )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
      *  ... f_crtUsrSpc                                                                      RADDAT
     D qUsrSpc       E DS                  extname(XDQOBJ    ) inz                            RADDAT
     D                                     prefix(qUsrSpc_   )                                RADDAT
     D text            S             50A   inz                                                RADDAT
      *  ... QUSPTRUS                                                                         RADDAT
     D pUsrSpc         S               *   inz                                                RADDAT
      *  ... QUSLSPL                                                                          RADDAT
     D qOutQ         E DS                  extname(XDQOBJ    ) inz                            RADDAT
     D                                     prefix(qOutQ_     )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren handle                                                                   RADDAT
     D handle          DS                  based(pHandle)                                     RADDAT
     D  hPointer                       *                                                      RADDAT
     D  hNbrEntry                    10I 0                                                    RADDAT
     D  hRes_01                      36A                                                      RADDAT
      *                                                                                       RADDAT
     D handleSize      S             10I 0 inz(%size(handle))                                 RADDAT
      *                                                                                       RADDAT
      *  Deklarieren API Fehlercode                                                           RADDAT
     D errCode       E DS                  extname(xderrcode) inz                             RADDAT
     D                                     prefix(errCode_  )                                 RADDAT
      *                                                                                       RADDAT
      *  Arbeitsfelder                                                                        RADDAT
     D isUsrSpc        S               N   inz                                                RADDAT
      *                                                                                       RADDAT
      *  CEEGSI                                                                               RADDAT
     D o_msgType       S             10I 0 inz                                                RADDAT
     D o_msgCurrLen    S             10I 0 inz                                                RADDAT
     D o_msgMaxLen     S             10I 0 inz                                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
      *  Wenn ein tmp. Dateiname generiert werden konnte, ...                                 RADDAT
 B01 C                   If        f_getTmpName(qUsrSpc_name: qUsrSpc_lib)                    RADDAT
      *  ... dann                                                                             RADDAT
      *      Wenn ein User Space erstellt werden konnte, ...                                  RADDAT
     C                   Eval      text = 'List Spooled Files, ' +                            RADDAT
     C                                    'SPLF0100, ' + i_orderBy                            RADDAT
 B02 C                   If        f_crtUsrSpc(qUsrSpc_name :                                 RADDAT
     C                                         qUsrSpc_lib  :                                 RADDAT
     C                                         text         :                                 RADDAT
     C                                         errCode      )                                 RADDAT
     C                   Eval      isUsrSpc = cTrue                                           RADDAT
      *      ... dann                                                                         RADDAT
      *          abrufen der Liste der Spooldateien                                           RADDAT
     C                   Eval      qOutQ_name = i_outQ                                        RADDAT
     C                   Eval      qOutQ_lib  = i_outQLib                                     RADDAT
     C                   Eval      errCode    = f_newApiErrCode(cTrue)                        RADDAT
      *                                                                                       RADDAT
     C                   Callp     QUSLSPL(qUsrSpc    :                                       RADDAT
     C                                     'SPLF0100' :                                       RADDAT
     C                                     i_user     :                                       RADDAT
     C                                     qOutQ      :                                       RADDAT
     C                                     i_formType :                                       RADDAT
     C                                     i_usrDta   :                                       RADDAT
     C                                     errCode    )                                       RADDAT
      *                                                                                       RADDAT
      *          Wenn die Liste abgerufen werden konnte, ...                                  RADDAT
 B03 C                   If        not f_isApiError(errCode)                                  RADDAT
      *          ... dann                                                                     RADDAT
      *              ermitteln Pointer auf User Space                                         RADDAT
     C                   Callp     QUSPTRUS(qUsrSpc  :                                        RADDAT
     C                                      pUsrSpc  :                                        RADDAT
     C                                      errCode  )                                        RADDAT
      *                                                                                       RADDAT
      *              Wenn der Pointer ermittelt werden konnte, ...                            RADDAT
 B04 C                   If        not f_isApiError(errCode)                                  RADDAT
      *              ... dann                                                                 RADDAT
      *                  sortieren User Space                                                 RADDAT
     C                   Eval      o_isDone = f_sortLst(pUsrSpc: i_orderBy)                   RADDAT
      *                                                                                       RADDAT
 X04 C                   Else                                                                 RADDAT
      *              ... sonst                                                                RADDAT
      *                  zurückmelden Fehler (retrieve user space pointer)                    RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
 E04 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
 X03 C                   Else                                                                 RADDAT
      *          ... sonst                                                                    RADDAT
      *              zurückmelden Fehler (retrieve member list)                               RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
 E03 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *                                                                                       RADDAT
 X02 C                   Else                                                                 RADDAT
      *      ... sonst                                                                        RADDAT
      *          zurückmelden Fehler (create user space)                                      RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
     C                   Eval      isUsrSpc = cFalse                                          RADDAT
 E02 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
 X01 C                   Else                                                                 RADDAT
      *  ... sonst                                                                            RADDAT
      *      zurückmelden Fehler (temporary object name)                                      RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
     C                   Eval      isUsrSpc = cFalse                                          RADDAT
     C                   Clear                   errCode                                      RADDAT
     C                   Eval      errCode_bytPrv = %size(errCode)                            RADDAT
     C                   Eval      errCode_bytAvl = %size(errCode)                            RADDAT
     C                   Eval      errCode_excID  = 'CPF9898'                                 RADDAT
     C                   Eval      errCode_excDta = 'Temporary object name +                  RADDAT
     C                                               could not be produced.'                  RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *  Erstellen Nachricht aus API Fehlercode                                               RADDAT
     C                   Eval      msg = f_cvtApiErrCodeToMsg(errCode)                        RADDAT
      *                                                                                       RADDAT
      *  If everything is fine ...                                                            RADDAT
 B01 C                   If        o_isDone                                                   RADDAT
     C                   Alloc     handleSize    pHandle                                      RADDAT
     C                   Eval      hPointer  = pUsrSpc                                        RADDAT
     C                   Eval      hNbrEntry = 0                                              RADDAT
     C                   Eval      hRes_01   = ''                                             RADDAT
 X01 C                   Else                                                                 RADDAT
      *  ... free ressources                                                                  RADDAT
 B02 C                   If        isUsrSpc                                                   RADDAT
     C                   Callp     f_dltUsrSpc(qUsrSpc_name: qUsrSpc_lib)                     RADDAT
 E02 C                   Endif                                                                RADDAT
     C                   Eval      pHandle = *NULL                                            RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *  Set output values                                                                    RADDAT
     C                   Eval      o_handle = pHandle                                         RADDAT
      *                                                                                       RADDAT
 B01 C                   If        %parms >= cpMsg                                            RADDAT
     C                   Callp     ceegsi(cpMsg        : o_msgType    :                       RADDAT
     C                                    o_msgCurrLen : o_msgMaxLen  : *omit)                RADDAT
     C                   Eval      %subst(o_msg: 1: o_msgCurrLen) = msg                       RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_opnSplFLst...                                                                        RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Close List Spooled Files                                                             RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *                                                                                       RADDAT
      *  Funktionswert:                                                                       RADDAT
      *                                                                                       RADDAT
      *  cTrue      - Funktion fehlerfrei beendet                                             RADDAT
      *  cFalse     - Fehler aufgetreten                                                      RADDAT
      *                                                                                       RADDAT
      *  Parameter Werte:                                                                     RADDAT
      *                                                                                       RADDAT
      *  io_handle  - list handle                                                             RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_cloSplFLst...                                                                        RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D f_cloSplFLst...                                                                        RADDAT
     D                 PI              N                                                      RADDAT
     D  io_handle                                 like(lstSplF_handle_t)                      RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
      *                                                                                       RADDAT
      *  Deklarieren handle                                                                   RADDAT
     D handle          DS                  based(pHandle)                                     RADDAT
     D  hPointer                       *                                                      RADDAT
     D  hNbrEntry                    10I 0                                                    RADDAT
     D  hRes_01                      36A                                                      RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Generic Data Structure für List APIs                                     RADDAT
     D genDtaStrc    E DS                  prefix(genDtaStrc_)                                RADDAT
     D                                     based(pGenDtaStrc)                                 RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Input Section für QUSLSPL API                                            RADDAT
     D inpSct          DS                  based(pInpSct)                                     RADDAT
     D  x_qualSpcName                20A                                                      RADDAT
     D   x_spcName                   10A   overlay(x_qualSpcName:  1)                         RADDAT
     D   x_spcLib                    10A   overlay(x_qualSpcName: 11)                         RADDAT
     D  x_format                      8A                                                      RADDAT
     D  x_user                       10A                                                      RADDAT
     D  x_qOutQ                      20A                                                      RADDAT
     D   x_qOutQ_name                10A   overlay(x_qOutQ:  1)                               RADDAT
     D   x_qOutQ_lib                 10A   overlay(x_qOutQ: 11)                               RADDAT
     D  x_formType                   10A                                                      RADDAT
     D  x_userData                   10A                                                      RADDAT
     D  x_qJob                       26A                                                      RADDAT
     D   x_qJob_name                 10A   overlay(x_qJob:  1)                                RADDAT
     D   x_qJob_user                 10A   overlay(x_qJob: 11)                                RADDAT
     D   x_qJob_nbr                   6A   overlay(x_qJob: 21)                                RADDAT
     D   x_numKeys                   10I 0                                                    RADDAT
     D   x_keyFields               1024A                                                      RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pHandle = io_handle                                        RADDAT
      *                                                                                       RADDAT
      *  Get user space name                                                                  RADDAT
     C                   Eval      pGenDtaStrc = hPointer                                     RADDAT
     C                   Eval      pInpSct     = hPointer + genDtaStrc_ofsInpSct              RADDAT
      *                                                                                       RADDAT
      *  Delete user space                                                                    RADDAT
     C                   Eval      o_isDone = f_dltUsrSpc(x_spcName: x_spcLib)                RADDAT
      *                                                                                       RADDAT
      *  Clear handle data                                                                    RADDAT
     C                   Eval      hPointer  = *NULL                                          RADDAT
     C                   Eval      hNbrEntry = 0                                              RADDAT
     C                   Eval      hRes_01   = ''                                             RADDAT
      *                                                                                       RADDAT
      *  Free handle memory                                                                   RADDAT
     C                   Dealloc(N)              pHandle                                      RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_cloSplFLst...                                                                        RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Get First Spooled File                                                               RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *                                                                                       RADDAT
      *  Funktionswert:                                                                       RADDAT
      *                                                                                       RADDAT
      *  cTrue      - Funktion fehlerfrei beendet                                             RADDAT
      *  cFalse     - Fehler aufgetreten                                                      RADDAT
      *                                                                                       RADDAT
      *  Parameter Werte:                                                                     RADDAT
      *                                                                                       RADDAT
      *  io_handle  - list handle                                                             RADDAT
      *  o_data     - list entry data of type SPLF0100                                        RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_getFirstSplF...                                                                      RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D f_getFirstSplF...                                                                      RADDAT
     D                 PI              N          opdesc                                      RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
     D  o_data                    32767A          options(*varsize)                           RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren handle                                                                   RADDAT
     D handle          DS                  based(pHandle)                                     RADDAT
     D  hPointer                       *                                                      RADDAT
     D  hNbrEntry                    10I 0                                                    RADDAT
     D  hRes_01                      36A                                                      RADDAT
      *                                                                                       RADDAT
      *  Lokale Felder                                                                        RADDAT
     D o_dataPosN      C                   const(2)                                           RADDAT
     D o_dataType      S             10I 0 inz                                                RADDAT
     D o_dataCurrLen   S             10I 0 inz                                                RADDAT
     D o_dataMaxLen    S             10I 0 inz                                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pHandle = i_handle                                         RADDAT
      *                                                                                       RADDAT
      *  Get length of o_data                                                                 RADDAT
     C                   Callp     ceegsi(o_dataPosN   : o_dataType   :                       RADDAT
     C                                    o_dataCurrLen: o_dataMaxLen : *omit)                RADDAT
      *                                                                                       RADDAT
      *  Get first entry                                                                      RADDAT
     C                   Eval      hNbrEntry = 0                                              RADDAT
      *                                                                                       RADDAT
      *  Retrieve entry data                                                                  RADDAT
     C                   Eval      o_isDone = f_getEntry(i_handle      :                      RADDAT
     C                                                   o_data        :                      RADDAT
     C                                                   o_dataCurrLen )                      RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_getFirstSplF...                                                                      RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Get Next Spooled File                                                                RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *                                                                                       RADDAT
      *  Funktionswert:                                                                       RADDAT
      *                                                                                       RADDAT
      *  cTrue      - Funktion fehlerfrei beendet                                             RADDAT
      *  cFalse     - Fehler aufgetreten                                                      RADDAT
      *                                                                                       RADDAT
      *  Parameter Werte:                                                                     RADDAT
      *                                                                                       RADDAT
      *  io_handle  - list handle                                                             RADDAT
      *  o_data     - list entry data of type SPLF0100                                        RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_getNextSplF...                                                                       RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D f_getNextSplF...                                                                       RADDAT
     D                 PI              N          opdesc                                      RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
     D  o_data                    32767A          options(*varsize)                           RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Lokale Felder                                                                        RADDAT
     D o_dataPosN      C                   const(2)                                           RADDAT
     D o_dataType      S             10I 0 inz                                                RADDAT
     D o_dataCurrLen   S             10I 0 inz                                                RADDAT
     D o_dataMaxLen    S             10I 0 inz                                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
      *  Get length of o_data                                                                 RADDAT
     C                   Callp     ceegsi(o_dataPosN   : o_dataType   :                       RADDAT
     C                                    o_dataCurrLen: o_dataMaxLen : *omit)                RADDAT
      *                                                                                       RADDAT
      *  Retrieve entry data                                                                  RADDAT
     C                   Eval      o_isDone = f_getEntry(i_handle      :                      RADDAT
     C                                                   o_data        :                      RADDAT
     C                                                   o_dataCurrLen )                      RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_getNextSplF...                                                                       RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Get Number of Spooled Files available                                                RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *                                                                                       RADDAT
      *  Funktionswert:                                                                       RADDAT
      *                                                                                       RADDAT
      *  numEntries - Anzahl Einträge in der Liste                                            RADDAT
      *                                                                                       RADDAT
      *  Parameter Werte:                                                                     RADDAT
      *                                                                                       RADDAT
      *  i_handle   - list handle                                                             RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_getNumSplFAvl...                                                                     RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D f_getNumSplFAvl...                                                                     RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
      *                                                                                       RADDAT
      *  Deklarieren handle                                                                   RADDAT
     D handle          DS                  based(pHandle)                                     RADDAT
     D  hPointer                       *                                                      RADDAT
     D  hNbrEntry                    10I 0                                                    RADDAT
     D  hRes_01                      36A                                                      RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Generic Data Structure für List APIs                                     RADDAT
     D genDtaStrc    E DS                  prefix(genDtaStrc_)                                RADDAT
     D                                     based(pGenDtaStrc)                                 RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pHandle = i_handle                                         RADDAT
      *                                                                                       RADDAT
     C                   Eval      pGenDtaStrc = hPointer                                     RADDAT
      *                                                                                       RADDAT
     C                   Return    genDtaStrc_nbrEntries                                      RADDAT
      *                                                                                       RADDAT
     P f_getNumSplFAvl...                                                                     RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Retrieve Spooled File Attributes                                                     RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_rtvSplFA...                                                                          RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D f_rtvSplFA...                                                                          RADDAT
     D                 PI                  opdesc like(spla0100_t)                            RADDAT
     D  i_intJobID                   16A   const                                              RADDAT
     D  i_intSplFID                  16A   const                                              RADDAT
     D  o_msg                     32767A         options(*nopass :                            RADDAT
     D                                                   *varsize)                            RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D SPLA0100      E DS                  extname(XDSPLA0100  ) inz                          RADDAT
     D                                     prefix(SPLA0100_    )                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Parameterpositionen                                                      RADDAT
     D cpMsg           C                   const(3)                                           RADDAT
      *                                                                                       RADDAT
      *  Deklarieren optionale Parameterfelder                                                RADDAT
     D msg           E DS                  extname(XDMSG     )  inz                           RADDAT
     D                                     prefix(msg_       )                                RADDAT
      *                                                                                       RADDAT
      *  Arbeitsfelder                                                                        RADDAT
     D errCode       E DS                  extname(XDERRCODE   ) inz                          RADDAT
     D                                     prefix(errCode_     )                              RADDAT
      *                                                                                       RADDAT
      *  CEEGSI                                                                               RADDAT
     D o_msgType       S             10I 0 inz                                                RADDAT
     D o_msgCurrLen    S             10I 0 inz                                                RADDAT
     D o_msgMaxLen     S             10I 0 inz                                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
      *  Wenn der Parameter "Nachricht" übergeben worden ist, ...                             RADDAT
 B01 C                   If        %parms >= cpMsg                                            RADDAT
      *  ... dann                                                                             RADDAT
      *      initialisieren Fehlercode damit API Fehlernachricht                              RADDAT
      *      zurück liefert.                                                                  RADDAT
     C                   Eval      errCode    = f_newApiErrCode(cTrue)                        RADDAT
 X01 C                   Else                                                                 RADDAT
      *  ... sonst                                                                            RADDAT
      *      initialisieren Fehlercode damit API ESCAPE Nachricht schickt                     RADDAT
     C                   Eval      errCode    = f_newApiErrCode(cFalse)                       RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
      *  Abrufen der Spollfile Attribute                                                      RADDAT
     C                   Clear                   SPLA0100                                     RADDAT
     C                   Callp     QUSRSPLA(SPLA0100        :                                 RADDAT
     C                                      %size(SPLA0100) :                                 RADDAT
     C                                      'SPLA0100'      :                                 RADDAT
     C                                      '*INT'          :                                 RADDAT
     C                                      i_intJobID      :                                 RADDAT
     C                                      i_intSplFID     :                                 RADDAT
     C                                      '*INT'          :                                 RADDAT
     C                                      0               :                                 RADDAT
     C                                      errCode         )                                 RADDAT
      *                                                                                       RADDAT
      *  Umsetzen API Fehlercode in Fehlernachricht                                           RADDAT
     C                   Eval      msg = f_cvtApiErrCodeToMsg(errCode)                        RADDAT
      *                                                                                       RADDAT
      *  Wenn der Parameter "Nachricht" übergeben worden ist, ...                             RADDAT
 B01 C                   If        %parms >= cpMsg                                            RADDAT
      *  ... dann                                                                             RADDAT
      *      zurückliefern Fehlernachricht                                                    RADDAT
     C                   Callp     ceegsi(cpMsg        : o_msgType    :                       RADDAT
     C                                    o_msgCurrLen : o_msgMaxLen  : *omit)                RADDAT
     C                   Eval      %subst(o_msg: 1: o_msgCurrLen) = msg                       RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    SPLA0100                                                   RADDAT
      *                                                                                       RADDAT
     P f_rtvSplFA...                                                                          RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Get Entry                                                                            RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_getEntry...                                                                          RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_getEntry...                                                                          RADDAT
     D                 PI              N                                                      RADDAT
     D  i_handle                           value  like(lstSplF_handle_t)                      RADDAT
     D  o_data                    32767A          options(*varsize)                           RADDAT
     D  i_length                     10I 0 value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren handle                                                                   RADDAT
     D handle          DS                  based(pHandle)                                     RADDAT
     D  hPointer                       *                                                      RADDAT
     D  hNbrEntry                    10I 0                                                    RADDAT
     D  hRes_01                      36A                                                      RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Feld für Eintragsdaten                                                   RADDAT
     D pDest           S               *   inz                                                RADDAT
     D pSrc            S               *   inz                                                RADDAT
     D count           S             10I 0 inz                                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Generic Data Structure für List APIs                                     RADDAT
     D genDtaStrc    E DS                  prefix(genDtaStrc_)                                RADDAT
     D                                     based(pGenDtaStrc)                                 RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pHandle = i_handle                                         RADDAT
      *                                                                                       RADDAT
     C                   Eval      pGenDtaStrc = hPointer                                     RADDAT
      * Wenn Einträge vorhanden sind, ...                                                     RADDAT
 B01 C                   If        (genDtaStrc_nbrEntries > 0         )   and                 RADDAT
     C                             (hNbrEntry  < genDtaStrc_nbrEntries)                       RADDAT
      * ... dann                                                                              RADDAT
      *     berechnen Parameter für memcpy                                                    RADDAT
     C                   Eval      pDest = %addr(o_data)                                      RADDAT
     C                   Eval      pSrc  = hPointer               +                           RADDAT
     C                                     genDtaStrc_ofsLstSct   +                           RADDAT
     C                                     hNbrEntry * genDtaStrc_sizeEntry                   RADDAT
 B02 C                   If        i_length < genDtaStrc_sizeEntry                            RADDAT
     C                   Eval      count = i_length                                           RADDAT
 X02 C                   Else                                                                 RADDAT
     C                   Eval      count = genDtaStrc_sizeEntry                               RADDAT
 E02 C                   Endif                                                                RADDAT
      *     extrahieren Eintragsdaten                                                         RADDAT
     C                   Callp     memCpy(pDest: pSrc: count)                                 RADDAT
      *     setzen Eintragsnummer                                                             RADDAT
     C                   Eval      hNbrEntry = hNbrEntry + 1                                  RADDAT
      *     zurückmelden OK                                                                   RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
 X01 C                   Else                                                                 RADDAT
      * ... sonst                                                                             RADDAT
      *     zurückmelden Fehler                                                               RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_getEntry...                                                                          RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Create User Space                                                                    RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_crtUsrSpc...                                                                         RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_crtUsrSpc...                                                                         RADDAT
     D                 PI              N                                                      RADDAT
     D  i_spcName                    10A   value                                              RADDAT
     D  i_spcLib                     10A   value                                              RADDAT
     D  i_text                       50A   value                                              RADDAT
     D  o_errCode                                 like(errCode_t )                            RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
     D qUsrSpc       E DS                  extname(XDQOBJ    ) inz                            RADDAT
     D                                     prefix(qUsrSpc_   )                                RADDAT
     D errCode       E DS                  extname(xderrcode ) inz                            RADDAT
     D                                     prefix(errCode_   )                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      qUsrSpc_name = i_spcName                                   RADDAT
     C                   Eval      qUsrSpc_lib  = i_spcLib                                    RADDAT
     C                   Eval      errCode      = f_newApiErrCode(cTrue)                      RADDAT
      *                                                                                       RADDAT
     C                   Callp     QUSCRTUS(qUsrSpc :                                         RADDAT
     C                                      'TEMP'  :                                         RADDAT
     C                                      65536   :                                         RADDAT
     C                                      x'00'   :                                         RADDAT
     C                                      '*USE'  :                                         RADDAT
     C                                      i_text  :                                         RADDAT
     C                                      '*NO'   :                                         RADDAT
     C                                      errCode )                                         RADDAT
      *                                                                                       RADDAT
     C                   Eval      o_isDone  = not f_isApiError(errCode)                      RADDAT
     C                   Eval      o_errCode = errCode                                        RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_crtUsrSpc...                                                                         RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Delete User Space                                                                    RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_dltUsrSpc...                                                                         RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_dltUsrSpc...                                                                         RADDAT
     D                 PI              N                                                      RADDAT
     D  i_spcName                    10A   value                                              RADDAT
     D  i_spcLib                     10A   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
      *  ... QUSCRTUS                                                                         RADDAT
     D qUsrSpc       E DS                  extname(XDQOBJ      ) inz                          RADDAT
     D                                     prefix(qUsrSpc_     )                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren API Fehlercode                                                           RADDAT
     D errCode       E DS                  extname(xderrcode) inz                             RADDAT
     D                                     prefix(errCode_  )                                 RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      qUsrSpc_name = i_spcName                                   RADDAT
     C                   Eval      qUsrSpc_lib  = i_spcLib                                    RADDAT
     C                   Eval      errCode      = f_newApiErrCode(cTrue)                      RADDAT
      *                                                                                       RADDAT
     C                   Callp     QUSDLTUS(qUsrSpc :                                         RADDAT
     C                                      errCode )                                         RADDAT
      *                                                                                       RADDAT
     C                   Eval      o_isDone = not f_isApiError(errCode)                       RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_dltUsrSpc...                                                                         RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Get Temporary Object Name                                                            RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_getTmpName...                                                                        RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_getTmpName...                                                                        RADDAT
     D                 PI              N                                                      RADDAT
     D  o_fileName                   10A                                                      RADDAT
     D  o_fileLib                    10A                                                      RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Konstanten                                                               RADDAT
     D L_tmpnam        C                   const(39)                            ! <stdio.h>   RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
     D tmpName         S              1A   dim(L_tmpnam)                                      RADDAT
     D                                     based(pTmpName)                                    RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pTmpName = tmpnam(%addr(tmpName))                          RADDAT
      *  Wenn ein temp. Dateiname generiert werden konnte, ...                                RADDAT
 B01 C                   If        pTmpName <> *NULL                                          RADDAT
      *  ... dann                                                                             RADDAT
      *      aufteilen in Name & Bibliothek                                                   RADDAT
     C                   Eval      o_fileLib  = %str(strtok(pTmpName:'/'))                    RADDAT
     C                   Eval      o_fileName = %str(strtok(*NULL   :'/'))                    RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
 X01 C                   Else                                                                 RADDAT
      *  ... sonst                                                                            RADDAT
      *      zurückmelden Fehler                                                              RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_getTmpName...                                                                        RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Is API Error?                                                                        RADDAT
      * -----------------------------------------------------------------                     RADDAT
      *    cTrue  - error                                                                     RADDAT
      *    cFalse - no error                                                                  RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_isApiError...                                                                        RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_isApiError...                                                                        RADDAT
     D                 PI              N                                                      RADDAT
     D  i_errCode                          value  like(errCode_t )                            RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isError       S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren API Fehlercode                                                           RADDAT
     D errCode       E DS                  extname(xderrcode) based(pErrCode)                 RADDAT
     D                                     prefix(errCode_)                                   RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pErrCode = %addr(i_errCode)                                RADDAT
      *                                                                                       RADDAT
 B01 C                   If        errCode_bytAvl = 0                                         RADDAT
     C                   Eval      o_isError = cFalse                                         RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      o_isError = cTrue                                          RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isError                                                  RADDAT
      *                                                                                       RADDAT
     P f_isApiError...                                                                        RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Erstellen leere API error code Datenstruktur                                         RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_newApiErrCode...                                                                     RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_newApiErrCode...                                                                     RADDAT
     D                 PI                         like(errCode_t )                            RADDAT
     D  i_monmsg                       N   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D errCode       E DS                  extname(xderrcode) inz                             RADDAT
     D                                     prefix(errCode_  )                                 RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Clear                   errCode                                      RADDAT
      *                                                                                       RADDAT
 B01 C                   If        i_monMsg = cTrue                                           RADDAT
     C                   Eval      errCode_bytPrv = %size(errCode)                            RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      errCode_bytPrv = 0                                         RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    errCode                                                    RADDAT
      *                                                                                       RADDAT
     P f_newApiErrCode...                                                                     RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Convert API error code to message                                                    RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_cvtApiErrCodeToMsg...                                                                RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_cvtApiErrCodeToMsg...                                                                RADDAT
     D                 PI                         like(msg_t     )                            RADDAT
     D  i_errCode                          value  like(errCode_t )                            RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_msg         E DS                  extname(XDMSG     )  inz                           RADDAT
     D                                     prefix(o_msg_     )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren API Fehlercode                                                           RADDAT
     D errCode       E DS                  extname(xderrcode)                                 RADDAT
     D                                     prefix(errCode_  )                                 RADDAT
     D                                     based(pErrCode   )                                 RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      pErrCode = %addr(i_errCode)                                RADDAT
      *                                                                                       RADDAT
 B01 C                   If        errCode_bytAvl = 0                                         RADDAT
     C                   Clear                   o_msg                                        RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Clear                   o_msg                                        RADDAT
     C                   Eval      o_msg_ID   = errCode_excID                                 RADDAT
     C                   Eval      o_msg_data = errCode_excDta                                RADDAT
     C                   Eval      o_msg_type = '*ESCAPE'                                     RADDAT
     C                   Eval      o_msg_file = 'QCPFMSG'                                     RADDAT
     C                   Eval      o_msg_lib  = 'QSYS'                                        RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_msg                                                      RADDAT
      *                                                                                       RADDAT
     P f_cvtApiErrCodeToMsg...                                                                RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Sort User Space                                                                      RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_sortLst...                                                                           RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_sortLst...                                                                           RADDAT
     D                 PI              N                                                      RADDAT
     D  i_pUsrSpc                      *   value                                              RADDAT
     D  i_compare                    10A   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_isDone        S               N   inz(cFalse)                                        RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
     D genDtaStrc    E DS                  prefix(genDtaStrc_)                                RADDAT
     D                                     based(pGenDtaStrc)                                 RADDAT
     D pCompFunc       S               *   inz procptr                                        RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
      * Ermitteln Sortierfunktion ...                                                         RADDAT
 B01 C                   Select                                                               RADDAT
      * ... nicht sortieren                                                                   RADDAT
     C                   When      i_compare = '*NONE'                                        RADDAT
     C                   Eval      pCompFunc = *NULL                                          RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
      * ... sortieren nach User Data                                                          RADDAT
     C                   When      i_compare = '*USRDTA'                                      RADDAT
     C                   Eval      pCompFunc = %paddr('F_SORTLSTBYUSRDTA')                    RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
      * ... sortieren nach User Name                                                          RADDAT
     C                   When      i_compare = '*USERNAME'                                    RADDAT
     C                   Eval      pCompFunc = %paddr('F_SORTLSTBYUSERNAME')                  RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
      * ... sortieren nach Anzahl Seiten (aufsteigend)                                        RADDAT
     C                   When      i_compare = '*PAGES_ASC'                                   RADDAT
     C                   Eval      pCompFunc = %paddr('F_SORTLSTBYPAGESASC')                  RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
      * ... sortieren nach Anzahl Seiten (absteigend)                                         RADDAT
     C                   When      i_compare = '*PAGES_DSC'                                   RADDAT
     C                   Eval      pCompFunc = %paddr('F_SORTLSTBYPAGESDSC')                  RADDAT
     C                   Eval      o_isDone = cTrue                                           RADDAT
      * ... unbekannte Sortierung = Fehler                                                    RADDAT
 X01 C                   Other                                                                RADDAT
     C                   Eval      pCompFunc = *NULL                                          RADDAT
     C                   Eval      o_isDone = cFalse                                          RADDAT
 E01 C                   Endsl                                                                RADDAT
      *                                                                                       RADDAT
      * Wenn eine Sortierfunktion ermittelt werden konnte, ...                                RADDAT
 B01 C                   If        pCompFunc <> *NULL                                         RADDAT
      * ... dann                                                                              RADDAT
      *     ermitteln Anzahl Einträge und Länge pro Eintrag                                   RADDAT
     C                   Eval      pGenDtaStrc = i_pUsrSpc                                    RADDAT
      *     und sortieren User Space                                                          RADDAT
     C                   Callp     qsort(i_pUsrSpc + genDtaStrc_ofsLstSct :                   RADDAT
     C                                   genDtaStrc_nbrEntries            :                   RADDAT
     C                                   genDtaStrc_sizeEntry             :                   RADDAT
     C                                   pCompFunc                        )                   RADDAT
 X01 C                   Else                                                                 RADDAT
      * ... sonst                                                                             RADDAT
      *     keine Sortierung durchführen                                                      RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_isDone                                                   RADDAT
      *                                                                                       RADDAT
     P f_sortLst...                                                                           RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Sort List by User Data                                                               RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_sortLstByUsrDta...                                                                   RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_sortLstByUsrDta...                                                                   RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren KEY                                                                      RADDAT
     D key           E DS                  extname(XDSPLF0100) based(i_pKey)                  RADDAT
     D                                     prefix(key_       )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren ELEMENT                                                                  RADDAT
     D element       E DS                  extname(XDSPLF0100) based(i_pElement)              RADDAT
     D                                     prefix(element_   )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_result        S             10I 0 inz                                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
 B01 C                   Select                                                               RADDAT
     C                   When      key_usrDta < element_usrDta                                RADDAT
     C                   Eval      o_result = -1                                              RADDAT
     C                   When      key_usrDta > element_usrDta                                RADDAT
     C                   Eval      o_result =  1                                              RADDAT
 X01 C                   Other                                                                RADDAT
     C                   Eval      o_result =  0                                              RADDAT
 E01 C                   Endsl                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_result                                                   RADDAT
      *                                                                                       RADDAT
     P f_sortLstByUsrDta...                                                                   RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Sort List by User Name                                                               RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_sortLstByUserName...                                                                 RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_sortLstByUserName...                                                                 RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren KEY                                                                      RADDAT
     D key           E DS                  extname(XDSPLF0100) based(i_pKey)                  RADDAT
     D                                     prefix(key_       )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren ELEMENT                                                                  RADDAT
     D element       E DS                  extname(XDSPLF0100) based(i_pElement)              RADDAT
     D                                     prefix(element_   )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_result        S             10I 0 inz                                                RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
 B01 C                   Select                                                               RADDAT
     C                   When      key_user < element_user                                    RADDAT
     C                   Eval      o_result = -1                                              RADDAT
     C                   When      key_user > element_user                                    RADDAT
     C                   Eval      o_result =  1                                              RADDAT
 X01 C                   Other                                                                RADDAT
     C                   Eval      o_result =  0                                              RADDAT
 E01 C                   Endsl                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_result                                                   RADDAT
      *                                                                                       RADDAT
     P f_sortLstByUserName...                                                                 RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Sort List by Number of Pages (ASCENDING)                                             RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_sortLstByPagesAsc...                                                                 RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_sortLstByPagesAsc...                                                                 RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren KEY                                                                      RADDAT
     D key           E DS                  extname(XDSPLF0100) based(i_pKey)                  RADDAT
     D                                     prefix(key_       )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren ELEMENT                                                                  RADDAT
     D element       E DS                  extname(XDSPLF0100) based(i_pElement)              RADDAT
     D                                     prefix(element_   )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_result        S             10I 0 inz                                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
     D spla0100_k    E DS                  extname(XDSPLA0100  ) inz                          RADDAT
     D                                     prefix(spla0100_k_  )                              RADDAT
     D spla0100_e    E DS                  extname(XDSPLA0100  ) inz                          RADDAT
     D                                     prefix(spla0100_e_  )                              RADDAT
     D msg_ds        E DS                  extname(XDMSG       ) inz                          RADDAT
     D                                     prefix(msg_         )                              RADDAT
      *  Der folgende Programmcode ist eingefügt worden aufgrund eines                        RADDAT
      *  Fehlers der CEEGSI API. Wenn die CEEGSI API für eine Daten-                          RADDAT
      *  struktur aufgerufen wird, dann wird folgende Fehlermeldung                           RADDAT
      *  generiert:   CEE0502   Missing operational descriptor.                               RADDAT
      *  Wenn der Fehler behoben worden ist, dann können die folgenden                        RADDAT
      *  2 Zeilen gelöscht und die Struktur 'msg_ds' nach 'msg' umbenannt                     RADDAT
      *  werden.                                                                              RADDAT
     D pMsg            S               *   inz(%addr(msg_ds))                                 RADDAT
     D msg             S                   like(msg_ds       ) based(pMsg)                    RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      spla0100_k = f_rtvSplFA(key_intJobID  :                    RADDAT
     C                                                     key_intSplFID :                    RADDAT
     C                                                     msg           )                    RADDAT
 B01 C                   If        msg_ID <> ''                                               RADDAT
     C                   Eval      spla0100_k_totPages = *HIVAL                               RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Eval      spla0100_e = f_rtvSplFA(element_intJobID  :                RADDAT
     C                                                     element_intSplFID :                RADDAT
     C                                                     msg               )                RADDAT
 B01 C                   If        msg_ID <> ''                                               RADDAT
     C                   Eval      spla0100_k_totPages = *HIVAL                               RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
 B01 C                   Select                                                               RADDAT
     C                   When      spla0100_k_totPages < spla0100_e_totPages                  RADDAT
     C                   Eval      o_result = -1                                              RADDAT
     C                   When      spla0100_k_totPages > spla0100_e_totPages                  RADDAT
     C                   Eval      o_result =  1                                              RADDAT
 X01 C                   Other                                                                RADDAT
     C                   Eval      o_result =  0                                              RADDAT
 E01 C                   Endsl                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_result                                                   RADDAT
      *                                                                                       RADDAT
     P f_sortLstByPagesAsc...                                                                 RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *==================================================================*                    RADDAT
      *  Sort List by Number of Pages (DESCENDING)                                            RADDAT
      *==================================================================*                    RADDAT
      *                                                                                       RADDAT
     P f_sortLstByPagesDsc...                                                                 RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D f_sortLstByPagesDsc...                                                                 RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_pKey                         *   value                                              RADDAT
     D  i_pElement                     *   value                                              RADDAT
      *                                                                                       RADDAT
      *  Deklarieren KEY                                                                      RADDAT
     D key           E DS                  extname(XDSPLF0100) based(i_pKey)                  RADDAT
     D                                     prefix(key_       )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren ELEMENT                                                                  RADDAT
     D element       E DS                  extname(XDSPLF0100) based(i_pElement)              RADDAT
     D                                     prefix(element_   )                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Funktionswert                                                            RADDAT
     D o_result        S             10I 0 inz                                                RADDAT
      *                                                                                       RADDAT
      *  Deklarieren Arbeitsfelder                                                            RADDAT
     D spla0100_k    E DS                  extname(XDSPLA0100  ) inz                          RADDAT
     D                                     prefix(spla0100_k_  )                              RADDAT
     D spla0100_e    E DS                  extname(XDSPLA0100  ) inz                          RADDAT
     D                                     prefix(spla0100_e_  )                              RADDAT
     D msg_ds        E DS                  extname(XDMSG       ) inz                          RADDAT
     D                                     prefix(msg_         )                              RADDAT
      *  Der folgende Programmcode ist eingefügt worden aufgrund eines                        RADDAT
      *  Fehlers der CEEGSI API. Wenn die CEEGSI API für eine Daten-                          RADDAT
      *  struktur aufgerufen wird, dann wird folgende Fehlermeldung                           RADDAT
      *  generiert:   CEE0502   Missing operational descriptor.                               RADDAT
      *  Wenn der Fehler behoben worden ist, dann können die folgenden                        RADDAT
      *  2 Zeilen gelöscht und die Struktur 'msg_ds' nach 'msg' umbenannt                     RADDAT
      *  werden.                                                                              RADDAT
     D pMsg            S               *   inz(%addr(msg_ds))                                 RADDAT
     D msg             S                   like(msg_ds       ) based(pMsg)                    RADDAT
      *-------------------------------------------------------------------                    RADDAT
      *                                                                                       RADDAT
     C                   Eval      spla0100_k = f_rtvSplFA(key_intJobID  :                    RADDAT
     C                                                     key_intSplFID :                    RADDAT
     C                                                     msg           )                    RADDAT
 B01 C                   If        msg_ID <> ''                                               RADDAT
     C                   Eval      spla0100_k_totPages = 0                                    RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
     C                   Eval      spla0100_e = f_rtvSplFA(element_intJobID  :                RADDAT
     C                                                     element_intSplFID :                RADDAT
     C                                                     msg               )                RADDAT
 B01 C                   If        msg_ID <> ''                                               RADDAT
     C                   Eval      spla0100_e_totPages = 0                                    RADDAT
 E01 C                   Endif                                                                RADDAT
      *                                                                                       RADDAT
 B01 C                   Select                                                               RADDAT
     C                   When      spla0100_k_totPages > spla0100_e_totPages                  RADDAT
     C                   Eval      o_result = -1                                              RADDAT
     C                   When      spla0100_k_totPages < spla0100_e_totPages                  RADDAT
     C                   Eval      o_result =  1                                              RADDAT
 X01 C                   Other                                                                RADDAT
     C                   Eval      o_result =  0                                              RADDAT
 E01 C                   Endsl                                                                RADDAT
      *                                                                                       RADDAT
     C                   Return    o_result                                                   RADDAT
      *                                                                                       RADDAT
     P f_sortLstByPagesDsc...                                                                 RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
