      /if not defined(QUSLSPL)
      /define QUSLSPL
      *
      *  List Spooled Files (QUSLSPL) API
     d QUSLSPL...
     d                 pr                         extpgm('QUSLSPL')
     d  i_qUsrSpc                    20a   const
     d  i_format                      8a   const
     d  i_user                       10a   const
     d  i_qOutQ                      20a   const
     d  i_formType                   10a   const
     d  i_userData                   10a   const
     d  io_errCode                65535a          options(*nopass: *varsize)    | optGrp 1
     d  i_qJob                       26a   const  options(*nopass)              | optGrp 2
     d  i_keyFldsRtn                 10i 0 const  options(*nopass)              |
     d                                            dim(32)                       |
     D  i_numFldsRtn                 10i 0 const  options(*nopass)              |
      *
      *  Input Parameter Section
     d QUSLSPL_inpParm_t...
     d                 ds                  qualified               based(pDummy)
     d  qUsrSpc                            likeds(QUSLSPL_qObj_t)
     d  format                        8a
     d  user                         10a
     d  qOutQ                              likeds(QUSLSPL_qObj_t)
     d  formType                     10a
     d  userData                     10a
     d  qJob                               likeds(QUSLSPL_qJob_t)
     d  numKeyFlds                   10i 0
     d  flds                         10i 0 dim(32)
      *
      *  SPLF0100 List Data Section
     d splf0100_t...
     d                 ds                  qualified               based(pDummy)
     d  user                   1     10a
     d  outQ                  11     20a
     d  outQLib               21     30a
     d  formType              31     40a
     d  userData              41     50a
     d  intJobId              51     66a
     d  intSplFId             67     82a
     d  reserved_1            83     84a
     d  auxStgPool            85     88i 0
      *
     d QUSLSPL_qObj_t...
     d                 ds                  qualified               based(pDummy)
     d  name                   1     10
     d  lib                   11     20
      *
     d QUSLSPL_qJob_t...
     d                 ds                  qualified               based(pDummy)
     d  name                         10a
     d  user                         10a
     d  nbr                           6a
      *
      /endif
