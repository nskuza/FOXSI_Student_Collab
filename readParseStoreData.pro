datFile = 'alphaRawData.csv'
; Name of whatever data file you are analyzing goes here. Opens the file.
workflowID = 4619 ;FIELD05 in data
workflowVersion = FLOAT(53.169) ;FIELD07 in data
; Workflow number and vesion currently being analyzed. To analyze multiple versions apply multiple times.
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

data = {response, classificationID:100000000, subjectID:100000000, datString:''} 
; In general responses will have the following data structure. Arrays for each task will be seperated for easy access.

dataSetB = REPLICATE(data, numDat)
; Creates the array that will be used to store full annotations data for just this workflowID and workflowVersion

j=0 ; Number of datasets that have the workflowID and Version necessary.
FOR I=0,(numDat-1) DO BEGIN
  IF (dataSetA.FIELD05[I] EQ workflowID) && (FLOAT(dataSetA.FIELD07[I]) EQ workflowVersion) THEN BEGIN
    dataSetB[J] = {response, dataSetA.FIELD01[I], dataSetA.FIELD14[I], dataSetA.FIELD12[I]}
    J = J + 1
  ENDIF
ENDFOR
; *Special note that this check for equal workflowVersion MUST have a better way to implement but unaware of any at this
; point and time. This FOR loop includes an IF statement to select only responses that include the proper workflowID 
; and Version#.
; FIELD01 == classificationID/ FIELD14 == subjectID/ FIELD12 == datString(annotations in CSV file) 

genericTaskSet = REPLICATE(data, 2*numDat) 
taskSet = REPLICATE(genericTaskSet, tasks)
; This is supposed to create an array of data structures called "genericTaskSet" and then makes an array of these arrays with each
; one matching a particular task. Having trouble determining the syntax, apparently first argument must be a scalar, not a 
; structure.

TI = MAKE_ARRAY(tasks, /INTEGER)
; Individual indexes to keep tack of entries within the taskSets 

FOR I=0, (numDat-1) DO BEGIN
  var = STRSPLIT(dataSetB[I].datString, '{"task":', /REGEX, /EXTRACT)
  ; Creates an array of Strings from every datString seperated by specific tasks. Each resulting String contains
  ; at most 1 T#.
  FOR J=0, N_ELEMENTS(var) - 1 DO BEGIN
    classID = LONG(dataSetB[I].classificationID)
    subID = LONG(dataSetB[I].subjectID)
    ; The LONG INT data structure variables need to be declared so that their member functions can be
    ; called.
    FOR K=0, tasks-1 DO BEGIN
      s = 'T' + STRING(K) 
      IF (var[J].Contains(s) EQ 1) THEN BEGIN
        taskSet[TI[K]] = {response, classID, subID, var[J]}
        TI[K] = TI[K] + 1 
      ENDIF
    ENDFOR  
  ENDFOR
ENDFOR
; Tripled nested FOR Loop? Why not?! 
; They will seperate the data into sections based on whether or not they contain the proper task
; labels for each structure. Both the indexes and datasets are indexed.    
  
END