      /if not defined(QUSRSPLA)
      /define QUSRSPLA
      *
      *  Retrieve Spooled File Attributes (QUSRSPLA) API
     d QUSRSPLA...
     d                 pr                         extpgm('QUSRSPLA')
     d  i_rcvVar                  65535a          options(*varsize)
     d  i_lenRcvVar                  10i 0 const
     d  i_format                      8a   const
     d  i_qJob                       26a   const
     d  i_intJobId                   16a   const
     d  i_intSplFId                  16a   const
     d  i_splF                       10a   const
     d  i_splFNbr                    10i 0 const
     d  io_errCode                65535a          options(*nopass: *varsize)    | optGrp 1
      *
      *  SPLA0100 Format
     d spla0100_t...
     d                 ds                  qualified               based(pDummy)
     d  bytRet                 1      4i 0
     d  bytAvl                 5      8i 0
     d  intJobId               9     24a
     d  intSplFId             25     40a
     d  job                   41     50a
     d  user                  51     60a
     d  jobNbr                61     66a
     d  splF                  67     76a
     d  splFNbr               77     80i 0
     d  formType              81     90a
     d  userData              91    100a
     d  status               101    110a
     d  available            111    120a
     d  hold                 121    130a
     d  save                 131    140a
     d  pages                141    144i 0
     d  currPage             145    148i 0
     d  startPage            149    152i 0
     d  endPage              153    156i 0
     d  lastPagePrint        157    160i 0
     d  restart              161    164i 0
     d  copies               165    168i 0
     d  copiesLeft           169    172i 0
     d  lpi                  173    176i 0
     d  cpi                  177    180i 0
     d  priority             181    182a
     d  outQNm               183    192a
     d  outQLib              193    202a
     d  dateOpened           203    209a
     d  timeOpened           210    215a
     d  deviceFileNm         216    225a
     d  deviveFileLib        226    235a
     d  pgmOpnFileNm         236    245a
     d  pgmOpnFileLib        246    255a
     d  accCode              256    270a
     d  printText            271    300a
     d  rcdLen               301    304i 0
     d  maxRcds              305    308i 0
     d  devType              309    318a
     d  printDevType         319    328a
     d  document             329    340a
     d  folder               341    404a
     d  s36ProcName          405    412a
     d  fidelity             413    422a
     d  rplUnprtChars        423    423a
     d  rplChar              424    424a
     d  pageLength           425    428i 0
     d  pageWidth            429    432i 0
     d  numSeparators        433    436i 0
     d  pageOverflow         437    440i 0
     d  multyByteChar        441    450a
     d  dbcsExtChar          451    460a
     d  dbcsShiftIO          461    470a
     d  dbcsCharRot          471    480a
     d  dbcsCPI              481    484i 0
     d  graphCharSet         485    494a
     d  codePage             495    504a
     d  formDefNm            505    514a
     d  formDefLib           515    524a
     d  srcDrawer            525    528i 0
     d  prtFont              529    538a
     d  s36SplFId            539    544a
     d  pageRot              545    548i 0
     d  justification        549    552i 0
     d  duplex               553    562a
     d  foldRecords          563    572a
     d  ctrlChar             573    582a
     d  alignForms           583    592a
     d  quality              593    602a
     d  formFeed             603    612a
     d  volumes              613    683a
     d  fileLabelId          684    700a
     d  exchangeType         701    710a
     d  charCode             711    720a
     d  totRcds              721    724i 0
     d  pagesPerSide         725    728i 0
     d  fontOvrNm            729    738a
     d  fontOvrLib           739    748a
     d  fontOvrDwn           749    756p 5
     d  fonrOvrAcr           757    764p 5
     d  backOvrNm            765    774a
     d  backOvrLib           775    784a
     d  backOvrDwn           785    792p 5
     d  backOvrAcr           793    800p 5
     d  unitMeasure          801    810a
     d  pageDefNm            811    820a
     d  pageDefLib           821    830a
     d  lineSpacing          831    840a
     d  fontSize             841    848p 5
     d  fontMgnDwn           849    856p 5
     d  fontMgnAcr           857    864p 5
     d  backMgnDwn           865    872p 0
     d  backMgnAcr           873    880p 5
     d  lengthOfPage         881    888p 5
     d  widthOfPage          889    896p 5
     d  measureMethod        897    906a
     d  afp                  907    907a
     d  charsetNm            908    917a
     d  charsetLib           918    927a
     d  codePageNm           928    937a
     d  codePageLib          938    947a
     d  codeFontNm           948    957a
     d  codeFontLib          958    967a
     d  dbcsCdeFntNm         968    977a
     d  dbcsCdeFntLib        978    987a
     d  usrDefFile           988    997a
     d  reduceOutput         998   1008a
     d  outputBin           1009   1012i 0
     d  ccsid               1013   1016i 0
     d  usrDefText          1017   1116a
     d  systemCreated       1117   1124a
     d  idCreated           1125   1132a
     d  userCreated         1133   1142a
     d  reserved_1          1143   1144a
     d  offsUsrDefOpt       1145   1148i 0
     d  numUsrDefOpt        1149   1152i 0
     d  lenUsrDefOptE       1153   1156i 0
     d  usrDefData          1157   1411a
     d  usrDefObjNm         1412   1421a
     d  usrDefObjLib        1422   1431a
     d  usrObjType          1432   1441a
     d  reserved_2          1442   1444a
     d  charSetPntSze       1445   1452p 5
     d  codFntPntSze        1453   1460p 5
     d  dbcsCdFnPnSze       1461   1468p 5
     d  auxStgPool          1469   1472i 0
     d  splFSize            1473   1476i 0
     d  splFSizeMlt         1477   1480i 0
     d  iNetPPJobId         1481   1484i 0
     d  splFCrtSecMtd       1485   1485a
     d  splFCrtAutMtd       1486   1486a
     d  startPrcDate        1487   1493a
     d  startPrcTime        1494   1499a
     d  endPrcDate          1500   1506a
     d  endPrcTime          1507   1512a
     d  jobSystem           1513   1520a
     d  devAuxPool          1521   1530a
     d  expDate             1531   1537a
      *
      /endif
