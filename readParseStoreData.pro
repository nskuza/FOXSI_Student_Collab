datFile = 'alphaRawData.csv'
;Name of whatever data file you are analyzing goes here. Opens the file.

dataSetA = READ_CSV(datFile, COUNT=numDat, HEADER = dummyHeader, NUM_HEADER=1, TABLE_HEADER=colHead) 
; Opens the datFile variable/ numDat records the number of data lines/dataSetHeaders records 
; the column headers as a vector of strings/ N_TABLE_HEADER defines how many lines are skipped
; before recording data, in this case just 1 line, the header line/
; Make sure the data file is in the right directory. dataSetA is the uncut raw data set  

;HELP, dataSetA
; Use the above line to determine the data structure of the dataSet if something isn't clear.
; Access individual fields(columns) with the dot operator. (ex: dataSet.FIELD10[0:10])

workflowID = 4619 ;FIELD05 in data
workflowVersion = DOUBLE(53.169000) ;FIELD07 in data
;Workflow number and vesion currently being analyzed. To analyze multiple versions apply multiple times.

data = {response, classificationID:100000000, subjectID:100000000, datString:''} 
; In general responses will have the following data structure. Arrays for each task will be seperated for easy access.

dataSetB = REPLICATE(data, numDat)
; Creates the array that will be used to store full annotations data for just this workflowID and workflowVersion


j=0 ;Number of datasets that have the workflowID and Version necessary.
FOR I=0,(numDat-1) DO BEGIN
  IF (dataSetA.FIELD05[I] EQ workflowID) && (dataSetA.FIELD07[I] - workflowVersion < 0.0001) THEN BEGIN
    dataSetB[J] = {response, dataSetA.FIELD01[I], dataSetA.FIELD14[I], dataSetA.FIELD12[I]}
    J = J + 1
  ENDIF
ENDFOR
; *Special note that this check for equal workflowVersion MUST have a better way to implement but unaware of any at this
; point and time. This FOR loop includes an IF statement to select only responses that include the proper workflowID 
; and Version#.
; FIELD01 == classificationID/ FIELD14 == subjectID/ FIELD12 == datString(annotations in CSV file) 


T0fullSet = REPLICATE(data, 2*numDat) ;"Mark the center of any sources...in relation to flare loops"
A = 0 
T1fullSet = REPLICATE(data, 2*numDat) ;"Outline all flare arches..."
B = 0
T2fullSet = REPLICATE(data, 2*numDat)   ;"How many arch-like structures..."
C = 0
T3fullSet = REPLICATE(data, 2*numDat) ;"Mark the center of any sources...in relation to the sun."
D = 0
; The above section creates an array of reponses for each task label. Create as many as there are tasks in the system. 


FOR I=0, (numDat-1) DO BEGIN
  var = STRSPLIT(dataSetB[I].datString, '{"task":', /REGEX, /EXTRACT)
  ; Creates an array of Strings from every datString seperated by specific tasks. Each resulting String contains
  ; at most 1 T#.
  FOR J=0, N_ELEMENTS(var) - 1 DO BEGIN
    classID = LONG(dataSetB[I].classificationID)
    subID = LONG(dataSetB[I].subjectID)
    ; The LONG INT data structure variables need to be declared so that their member functions can be
    ; called.
    
    IF (var[J].Contains('T0') EQ 1) THEN BEGIN
      T0fullSet[A] = {response, classID, subID, var[J]}
      A = A + 1 
    ENDIF  
    IF (var[J].Contains('T1') EQ 1) THEN BEGIN
      T1fullSet[B] = {response, classID, subID, var[J]}
      B = B + 1 
    ENDIF 
    IF (var[J].Contains('T2') EQ 1) THEN BEGIN
      T2fullSet[C] = {response, classID, subID, var[J]}
      C = C + 1
    ENDIF
    IF (var[J].Contains('T3') EQ 1) THEN BEGIN
      T3fullSet[D] = {response, classID, subID, var[J]}
      D = D + 1
    ENDIF
  ENDFOR
ENDFOR
; Nested FOR Loops that will seperate the data into sections based on whether or not they contain the proper task
; labels for each structure. Currently receiving an odd error. Not sure how to fix.    
  
END