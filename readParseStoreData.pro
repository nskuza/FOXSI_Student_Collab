datFile = 'alphaRawData.csv'
; Name of whatever data file you are analyzing goes here.
workflowID = 4619 ;FIELD05 in data
workflowVersion = FLOAT(53.169) ;FIELD07 in data
; Workflow number and vesion currently being analyzed. To analyze multiple versions or IDs apply multiple times.
tasks = 4
; Number of tasks being analyzed. Script will extract tasks (0) through (tasks -1)

;-------------------------------- User must set variables above this line.---------------------------------------

dataSetA = READ_CSV(datFile, COUNT=numDat, HEADER = dummyHeader, NUM_HEADER=1, TABLE_HEADER=colHead) 
; Opens the datFile variable/ numDat records the number of data lines/dataSetHeaders records 
; the column headers as a vector of strings/ N_TABLE_HEADER defines how many lines are skipped
; before recording data, in this case just 1 line, the header line/
; Make sure the data file is in the right directory. dataSetA is the uncut raw data set  

;HELP, dataSetA
; Use the above line to determine the data structure of the dataSet if something isn't clear.
; Access individual fields(columns) with the dot operator. (ex: dataSet.FIELD10[0:10])

CID = MAKE_ARRAY(numDat, /LONG)
SID = MAKE_ARRAY(numDat, /LONG)
DATA = MAKE_ARRAY(numDat, /STRING)
dataSet = {data, classificationID:CID, subjectID:SID, datString:DATA} 
; In general, responses will be put into data sets that have the following data structure. Each point will 
; have a classification ID, subject ID and a datString which is pulled from the annotations column in the data file. 
; Each tag is an array with a length equal to the number of data points. Each data point is represented by an index.

j=0 ; Number of datasets that have the workflowID and Version necessary.
FOR I=0,(numDat-1) DO BEGIN
  IF (dataSetA.FIELD05[I] EQ workflowID) && FLOAT(dataSetA.FIELD07[I]) EQ workflowVersion THEN BEGIN
    dataSet.classificationID[J] = dataSetA.FIELD01[I]
    dataSet.subjectID[J] = dataSetA.FIELD14[I]
    dataSet.datString[J] = dataSetA.FIELD12[I]
    J = J + 1
  ENDIF
ENDFOR
; This FOR loop includes an IF statement to select only responses that include the proper workflowID and Version#.
; FIELD01 == classificationID/ FIELD14 == subjectID/ FIELD12 == datString(annotations in CSV file) 

taskSet = REPLICATE(dataSet, tasks)
; taskSet represents the largest data structure in this script. Contains an entire n dimensional data fo each task
; within the data file.

TI = MAKE_ARRAY(tasks, /INTEGER)
; Individual indexes to keep tack of entries within the taskSets 

FOR I=0, (numDat-1) DO BEGIN
  var = STRSPLIT(dataSet.datString[I], '{"task":', /REGEX, /EXTRACT)
  ; Creates an array of Strings from every datString seperated by specific tasks. Each resulting String contains
  ; at most 1 T#.
  FOR J=0, N_ELEMENTS(var) - 1 DO BEGIN
    cTemp = LONG(dataSet.classificationID[I])
    sTemp = LONG(dataSet.subjectID[I])
    ; The LONG INT data structure variables need to be declared so that their member functions can be
    ; called.
    FOR K=0, tasks-1 DO BEGIN
      s = STRING(K)
      s = s.trim() 
      s = 'T' + s ;s is the task label of interest in each if-statement comparison
      IF (var[J].Contains(s) EQ 1) THEN BEGIN
        taskSet[K].classificationID[TI[K]] = cTemp
        taskSet[K].subjectID[TI[K]] = sTemp
        taskSet[K].datString[TI[K]] = var[J]
        TI[K] = TI[K] + 1 
      ENDIF
    ENDFOR  
  ENDFOR
ENDFOR
; Tripled nested FOR Loop? Why not?! 
; They will seperate the data into sections based on whether or not they contain the proper task
; labels for each structure. Datasets are indexed based on how many values are found that match the task label
; These indices can be used to keep track of the amount of data collected. [ PRINT, TI[0:tasks-1] ]    
  
END