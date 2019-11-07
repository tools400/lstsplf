/* -------------------------------------------------------------------------- */
/* LSTSPLF    - SCRIPT MEMBER                                                 */
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

             XMLGENVRS XSRCFILE(QLSTSPLF) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO) XVAR(&CRTTSTPGM)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QLSTSPLF)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDBOOLEAN ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDERRCODE ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMSG     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQOBJ    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(GENLSTHDR ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTSPLF_T ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTSPLF   ) XMBRATR(BND  ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTSPLFR1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLSTSPLF  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PUSLUTILS ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSLSPL   ) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSRSPLA  ) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USLUTILS  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QLSTJOB) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&CRTTSTPGM'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

