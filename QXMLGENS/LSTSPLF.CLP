/* --------------------------------------------------------------- */
/* LSTSPLF    - SCRIPT MEMBER                                      */ /* RADD */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)
                                                                      /* RADD */
             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO)                             /* RADD */
                                                                      /* RADD */
/* ---------------------------------- */                              /* RADD */
/*  Delete old objects                */                              /* RADD */
/* ---------------------------------- */                              /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/GENDTASTRC))     /* RADD */
             XMLGENCMD  XCMD(DLTMOD    MODULE(&TOLIB/LSTSPLF   ))     /* RADD */
             XMLGENCMD  XCMD(DLTSRVPGM SRVPGM(&TOLIB/LSTSPLF   ))     /* RADD */
             XMLGENCMD  XCMD(DLTMOD    MODULE(&TOLIB/LSTSPLF_T ))     /* RADD */
             XMLGENCMD  XCMD(DLTPGM       PGM(&TOLIB/LSTSPLF_T ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDERRCODE ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDMSG     ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDQOBJ    ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDSPLA0100))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDSPLF0100))     /* RADD */

/* ---------------------------------- */                              /* RADD */
/*  Deploy source member              */                              /* RADD */
/* ---------------------------------- */                              /* RADD */
             XMLGENMBR  XMBR(GENDTASTRC) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(PLSTSPLF  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(LSTSPLF   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(LSTSPLF_T ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(XDERRCODE ) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(XDMSG     ) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(XDQOBJ    ) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(XDSPLA0100) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
             XMLGENMBR  XMBR(XDSPLF0100) XMBRATR(PF   ) +
                          XFROMSRCF(QLSTSPLF  ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QLSTSPLF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)                /* RADD */
                                                                      /* RADD */
/* ---------------------------------- */                              /* RADD */
/*  Create external data structures   */                              /* RADD */
/* ---------------------------------- */                              /* RADD */
             XMLGENCMD  XCMD(CRTPF FILE(&TOLIB/GENDTASTRC) +
                          SRCFILE(&TOLIB/QLSTSPLF) SRCMBR(*FILE) +
                          FILETYPE(*DATA) MBR(*FILE) MAXMBRS(1))      /* RADD */

             XMLGENCMD  XCMD(CRTPF FILE(&TOLIB/XDERRCODE ) +
                          SRCFILE(&TOLIB/QLSTSPLF) SRCMBR(*FILE) +
                          FILETYPE(*DATA) MBR(*FILE) MAXMBRS(1))      /* RADD */
                                                                      /* RADD */
             XMLGENCMD  XCMD(CRTPF FILE(&TOLIB/XDMSG     ) +
                          SRCFILE(&TOLIB/QLSTSPLF) SRCMBR(*FILE) +
                          FILETYPE(*DATA) MBR(*FILE) MAXMBRS(1))      /* RADD */
                                                                      /* RADD */
             XMLGENCMD  XCMD(CRTPF FILE(&TOLIB/XDQOBJ    ) +
                          SRCFILE(&TOLIB/QLSTSPLF) SRCMBR(*FILE) +
                          FILETYPE(*DATA) MBR(*FILE) MAXMBRS(1))      /* RADD */
                                                                      /* RADD */
             XMLGENCMD  XCMD(CRTPF FILE(&TOLIB/XDSPLA0100) +
                          SRCFILE(&TOLIB/QLSTSPLF) SRCMBR(*FILE) +
                          FILETYPE(*DATA) MBR(*FILE) MAXMBRS(1))      /* RADD */
                                                                      /* RADD */
             XMLGENCMD  XCMD(CRTPF FILE(&TOLIB/XDSPLF0100) +
                          SRCFILE(&TOLIB/QLSTSPLF) SRCMBR(*FILE) +
                          FILETYPE(*DATA) MBR(*FILE) MAXMBRS(1))      /* RADD */
                                                                      /* RADD */
/* ---------------------------------- */                              /* RADD */
/*  Create service program            */                              /* RADD */
/* ---------------------------------- */                              /* RADD */
             XMLGENCMD  XCMD(CRTRPGMOD MODULE(&TOLIB/LSTSPLF   ) +
                          SRCFILE(&TOLIB/QLSTSPLF  ) +
                          SRCMBR(*MODULE) +
                          DBGVIEW(*LIST) +
                          TRUNCNBR(*NO))                              /* RADD */
                                                                      /* RADD */
             XMLGENCMD  XCMD(CRTSRVPGM SRVPGM(&TOLIB/LSTSPLF   ) +
                          MODULE(&TOLIB/LSTSPLF)  +
                          EXPORT(*ALL) +
                          ACTGRP(*CALLER) +
                          DETAIL(*BASIC) +
                          ALWUPD(*YES) +
                          ALWLIBUPD(*YES) +
                          TEXT('SrvPgm  : List Spooled Files  '))     /* RADD */
                                                                      /* RADD */
/* ---------------------------------- */                              /* RADD */
/*  Create test program               */                              /* RADD */
/* ---------------------------------- */                              /* RADD */
             XMLGENCMD  XCMD(CRTRPGMOD MODULE(&TOLIB/LSTSPLF_T ) +
                          SRCFILE(&TOLIB/QLSTSPLF  ) +
                          SRCMBR(*MODULE) +
                          DBGVIEW(*LIST) +
                          TRUNCNBR(*NO)) +
                          XCND(YES)                                   /* RADD */
                                                                      /* RADD */
             XMLGENCMD  XCMD(CRTPGM       PGM(&TOLIB/LSTSPLF_T ) +
                          MODULE(*PGM) +
                          BNDSRVPGM(&TOLIB/LSTSPLF) +
                          ACTGRP(*NEW) +
                          DETAIL(*BASIC)                        ) +
                          XCND(YES)                                   /* RADD */
                                                                      /* RADD */
/* ---------------------------------- */                              /* RADD */
/*  Delete obsolete objects           */                              /* RADD */
/* ---------------------------------- */                              /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/GENDTASTRC))     /* RADD */
             XMLGENCMD  XCMD(DLTMOD    MODULE(&TOLIB/LSTSPLF   ))     /* RADD */
             XMLGENCMD  XCMD(DLTMOD    MODULE(&TOLIB/LSTSPLF_T ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDERRCODE ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDMSG     ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDQOBJ    ))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDSPLA0100))     /* RADD */
             XMLGENCMD  XCMD(DLTF        FILE(&TOLIB/XDSPLF0100))     /* RADD */

